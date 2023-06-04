

[coeff,score,latent,tsquared,explained] = pca(trainDataS);

k = 150;
projected_data = score(:,1:k);