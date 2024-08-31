%Mode- n singular values of core tensor S
%
function [sigma1,sigma2,sigma3]=MSV(S,dim1,dim2,dim3)


sigma1=zeros(dim3,1);
sigma2=zeros(dim1,1);
sigma3=zeros(dim2,1);

for i=1:dim1
    for j=1:dim2
        for k=1:dim3
            sigma1(k)=sigma1(k)+S(i,j,k)^2;
        end
    end
   
end
%

for k=1:dim3
    for j=1:dim2
        for i=1:dim1
            sigma2(i)=sigma2(i)+S(i,j,k)^2;
        end
    end
   
end

%

for k=1:dim3
    for i=1:dim1
        for j=1:dim2
            sigma3(j)=sigma3(j)+S(i,j,k)^2;
        end
    end
   
end


%
