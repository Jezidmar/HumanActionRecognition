function sparseTensor = mod3d2(X, dim1, dim2, dim3)
    %Inicijalizacija nul tenzora
    sparseTensor = zeros(dim1, dim2, dim3);
    
    % Normalizacija tocaka
    X(1,:) = (X(1,:) - min(X(1,:))) / (max(X(1,:)) - min(X(1,:)));
    X(2,:) = (X(2,:) - min(X(2,:))) / (max(X(2,:)) - min(X(2,:)));
    X(3,:) = (X(3,:) - min(X(3,:))) / (max(X(3,:)) - min(X(3,:)));
    
    % Spremanje tocaka u tenzor
    for i = 1:size(X, 2)
        xIndex = min(floor(X(1,i) * dim1) + 1,dim1);
        yIndex = min(floor(X(2,i) * dim2) + 1,dim2);
        zIndex = min(floor(X(3,i) * dim3) + 1,dim3);
        sparseTensor(xIndex, yIndex, zIndex) = 1;
    end
end