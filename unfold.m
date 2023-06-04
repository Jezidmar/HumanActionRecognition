%fold i unfold
function [M1,M2,M3]=unfold123(K)

[dim1,dim2,dim3]=size(K);
M1 = reshape(K, [dim1 dim2*dim3]);

% Unfold T in the second mode (i.e., keeping the second dimension fixed)
M2 = reshape(permute(K, [2 1 3]), [dim2 dim1*dim3]);

% Unfold T in the third mode (i.e., keeping the third dimension fixed)
M3 = reshape(permute(K, [3 1 2]), [dim3 dim1*dim2]);


%Ovo radi.

%B = nmodeproduct(K, U, n)