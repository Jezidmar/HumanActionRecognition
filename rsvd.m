%randomized SVD


function [U]=rsvd(X,dim_i)

k=dim_i;   %zelim kvadratnu matricu U vratiti
[m,n]=size(X);


%argument k je za rank



rng(5);
Omega = randn(n,k);


Y = X * Omega;


rng(6);
[Q, R] = qr(Y);


B = Q' * X;

rng(7);
[Uhat, Sigma, V] = svd(B);

U = Q * Uhat;


