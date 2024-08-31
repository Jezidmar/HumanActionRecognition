%randomized SVD
function [U] = rsvd(X, dim_i)
%power_iterations=0;
k = dim_i;   % rank approximation parameter
[m, n] = size(X);

Omega = randn(n, k);

% Initial Projection
Y = X * Omega;

% Power Iterations (optional)
%for i = 1:power_iterations
%    Y = X * (X' * Y);
%end

% QR Decomposition
[Q, ~] = qr(Y, 0);  % Economy QR decomposition

% Small SVD on B
B = Q' * X;
[Uhat, ~, ~] = svd(B, 'econ');  % Economy SVD

% Compute final U
U = Q * Uhat;



