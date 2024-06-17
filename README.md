# Human Action Recognition

This repo aims to replicate following methodology:
![Methodology](methodology.png)
Here, I bring non official implementation of algorithm based on paper [Skeleton based HAR](inventions-04-00009-v2.pdf)
. Coding is done in MATLAB and the comments are mostly on Croatian language. Along the code implementation, I added [HAR](HAR.pdf) file where I described the mathISH background of used methods, although it is as well on Croatian language.

The files structure is separated in 2 folders. In Preprocessing folder one can find all algorithms relevant for implementing above mentioned methodology. In Evaluation folder the classification head can be found. I expanded the proposed approaches from paper to SVM & RF. For the reproduction of results, I can send the workspace from session.

I added the pipeline which is suitable for [MSRC-12 Dataset](MSRC_12_gesture_dataset.pdf). Other datasets used in paper are not publicly available.

Because of the compute constraints, I used only first 800 frames from each video file. 
