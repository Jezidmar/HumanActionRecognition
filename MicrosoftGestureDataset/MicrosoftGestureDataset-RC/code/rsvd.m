function U = rsvd(X, k, power_iterations)
    % rsvd computes the approximate rank-k left singular vectors of matrix X using randomized algorithms.
    %
    % Inputs:
    % - X: Input matrix (can be sparse)
    % - k: Target rank (number of singular vectors to compute)
    % - power_iterations: Number of power iterations (default is 0)
    %
    % Output:
    % - U: Approximate left singular vectors (size m x k)

    if nargin < 3
        power_iterations = 0;
    end

    [m, n] = size(X);
    Omega = randn(n, k);

    % Initial Projection
    Y = X * Omega;

    % Power Iterations
    for i = 1:power_iterations
        Y = X * (X' * Y);
    end

    % QR Decomposition
    [Q, ~] = qr(Y, 0);  % Economy QR decomposition

    % Form B
    B = Q' * X;

    % SVD of B
    [Uhat, ~, ~] = svd(B, 'econ');  % We can ignore S and V

    % Compute final U
    U = Q * Uhat(:, 1:k);
end




