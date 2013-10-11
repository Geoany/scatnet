% AFFINE_TRAIN Train an affine space classifier
%
% Usage
%    model = AFFINE_TRAIN(db, train_set, options)
%
% Input
%    db (struct): The database containing the feature vector.
%    train_set (int): The object indices of the training instances.
%    options (struct): The training options. options.dim specifies the dimen-
%        sionality of the affine spaces modeling each class.
%
% Output
%    model: The affine space model.
%
% See also
%    AFFINE_TEST, AFFINE_PARAM_SEARCH

function model = affine_train(db,train_set,opt)
	if nargin < 3
		opt = struct();
	end
	
	opt = fill_struct(opt,'dim',80);
	
	train_mask = ismember(1:length(db.src.objects),train_set);
	
	for k = 1:length(db.src.classes)
		ind_obj = find([db.src.objects.class]==k&train_mask);
		
		if length(ind_obj) == 0
			continue;
		end
		
		ind_feat = [db.indices{ind_obj}];
		
		mu{k} = sig_mean(db.features(:,ind_feat));
		v{k} = sig_pca(db.features(:,ind_feat),0);
		if size(v{k},2) > max(opt.dim)
			v{k} = v{k}(:,1:max(opt.dim));
		end
	end
	
	model.model_type = 'affine';
	model.dim = opt.dim;
	model.mu = mu;
	model.v = v;
end

function mu = sig_mean(x)
    C = size(x,2);
    
    mu = x*ones(C,1)/C;
end

function [u,s] = sig_pca(x,M)
	if nargin > 1 && M > 0
	    [u,s,v] = svds(x-sig_mean(x)*ones(1,size(x,2)),M);
	    s = abs(diag(s)/sqrt(size(x,2)-1)).^2;
	else
		[u,d] = eig(cov(x'));
		[s,ind] = sort(diag(d),'descend');
		u = u(:,ind);
	end
end