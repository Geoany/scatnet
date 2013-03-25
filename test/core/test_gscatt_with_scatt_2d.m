% load an image
x = uiuc_sample;

clear options;
options.J = 4;
options.L = 8;
J = options.J;
L = options.L;

% compute propagators
size_in = size(x);
propagators = propagators_builder_2d(size_in, options);

% compute scattering
[S, U] = gscatt(x, propagators);

% assert correct number of coefficients
number_of_order_1 = J*L;

assert(numel(S{2}.sig) == number_of_order_1);

number_of_order_2 = J*(J-1)/2 * L^2;

assert(numel(S{3}.sig) == number_of_order_2);


