function Z = mod3dTemp(Z,X)
    % Initialize the sparse tensor with zeros

	%Matrix Z represents matrix that we want to update

	%Matrix X represents current frame
	dim1=size(X,1);
	dim2=size(X,2);
	dim3=size(X,3);
    	
    	

	% Reshape the third-order tensor into a two-dimensional matrix
	B = reshape(X, [], 1);

	% Find the indices and values of non-zero elements in the two-dimensional matrix
	[row, col, values] = find(B);
	
	[i, j, k] = ind2sub([dim1, dim2, dim3], row);

	
	for n = 1:length(i)
    		Z(i(n), j(n), k(n)) = 1;
	end	
end