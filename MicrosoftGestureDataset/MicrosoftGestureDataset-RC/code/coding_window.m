function [idx1,idx2,C1,C2]=coding_window(sigma_A,sigma_D,f)

[idx1, C1] = kmeans(sigma_A, f,MaxIter=5000);
[idx2, C2] = kmeans(sigma_D, f,MaxIter=5000);
end
%
