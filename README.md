# Skeleton-Based Human Action Recognition through Third-Order Tensor Representation and Spatio-Temporal Analysis

This repo aims to replicate following methodology:
![Methodology](methodology.png)

## Unofficial MATLAB Implementation for Skeleton-based Human Activity Recognition (HAR)

This repository provides an unofficial implementation of a skeleton-based HAR algorithm inspired by the paper "[Skeleton based HAR](inventions-04-00009-v2.pdf)" (Croatian).

## Tutorial for usage
    - Clone the repo and make sure the dataset is placed according to the needs and include start/end sequences annotation from link http://www.eng.alexu.edu.eg/mehussein
    - One should firstly run script `skel_model.m` so to include the relevant variables in the Workspace
    - Script `construct_codebook.m` should be ran so as to create tensors where the feature vectors for the creation of codebooks will be placed.
    - Once the relevant frames for codebook construction are extracted, we can proceed to building codebook using k-means and final extraction of features; Run script `extract_features.m` with config as desired so to extract the Spatial and Temporal features for each sequence
    - For evaluation as in paper, I implemented script `splitMSRC12Dataset.m` which helps to load all files performed by specified subject. The evaluation script is named `leave_person_out_protocol.m`. 
    - Instead of using DCA and ANN classifier, I found that the best performance is yielded by Random Forests algorithm on the `single` descriptors. I used 1000 trees.

Following are obtained results and the comparison to the results obtained by authors:

## Results
Based on the "leave persons out procedure", I obtained the following results:
![Spatial descriptor](spatial_descriptor.png)

![Temporal descriptor](temporal_descriptor.png)





These results were obtained using following hyperparameters:
   - (x,y,h) = (13,13,15)
   - number_of_singular_values=13
   - Codebook construction
    - K=32 codes in codebook
    - L1 distance used for construction of codebooks `cityblock`
    - There is generally high variance, i.e. local optimas are of relatively similar quality
   - Preprocessing of skeleton
    - Aligning the coordinate system based on hip center
    - Scaling based on spine length
    - Rotation in direction of z axis, i.e. vector [0 0 1]
    - Finally, scaling coordinates so to fit in binary tensor of third order
   - 1000 Trees in Random Forests classifier


Unfortunately, authors did not provide the methodology on construction of both Codebook, descriptors, thus there are many details left in air. I assumed the separate frames represent centers in codebook but in some literature they point out that the multiple frames concatenated can be used as well. I implemented pipeline for extraction of features based on windows, the scripts are named '{regular_name}_window' and the additional hyperparameters are hop_length and window_size which have standard meaning. 

There is possibility that authors used only a fragment of original set, i.e. ~1600 samples since they reffered to the paper where only Video instructed sequences were used. 

Feel free to suggest the improvements via issues section.

Thank you for reading. Cheers!


