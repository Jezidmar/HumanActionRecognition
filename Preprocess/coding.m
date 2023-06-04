function [idx1,idx2,featureVectorS,featureVectorT,C1,C2]=coding(sigma_A,sigma_D,f)






%f=1007;  MSRC-12 dataset choice 


[idx1, C1] = kmeans(sigma_A', f,MaxIter=500);
[idx2, C2] = kmeans(sigma_D', f,MaxIter=500);
%

%

% Calculate the histogram of codeword assignments for each frame

histograms = cell(2, 1);
histograms{1} = histcounts(idx1, f);
histograms{2} = histcounts(idx2, f);


% Concatenate the histograms to form the feature vector for the entire video

featureVectorS = horzcat(histograms{1});
featureVectorT = horzcat(histograms{2});

%hist(featureVectorT);
%hist(featureVectorS);        %za isprobavanje.


%mozes updejtat tako da odredis reprezentativne framese... u prijevodu
%izbaci prvih par, zadnjih par.
%takodjer, jos nisi skuzio sto da radis sa S_T, i S_D

end
%
