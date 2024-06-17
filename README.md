# Human Action Recognition

This repo aims to replicate following methodology:
![Methodology](methodology.png)

## Unofficial MATLAB Implementation for Skeleton-based Human Activity Recognition (HAR)

This repository provides an unofficial implementation of a skeleton-based HAR algorithm inspired by the paper "[Skeleton based HAR](inventions-04-00009-v2.pdf)" (Croatian).

**Key Features:**

* **MATLAB Implementation:** The code is implemented in MATLAB with comments primarily in Croatian.
* **Mathematical Background:** A separate document, "[HAR](HAR.pdf)" (Croatian), delves into the mathematical background of the methods used.
* **Modular Structure:** The code is well-structured with two folders:
    * `Preprocessing`: Contains algorithms for data preparation.
    * `Evaluation`: Houses the classification head, including expanded approaches (SVM & RF) not present in the paper.
* **Dataset Compatibility:** The pipeline supports the [MSRC-12 Dataset](MSRC_12_gesture_dataset.pdf). Note that datasets used in the original paper are not publicly available.

**Implementation Notes:**

* **Frame Processing:** Due to computational constraints, only the first 800 frames from each video are processed.
* **Binary 3D Box Dimensions:** The optimal dimensions for the binary 3D boxes are not explicitly defined in the paper. Experimentation with various sizes (25^3, 20^3, 15^3) yielded similar results.
* **Training/Testing Split:** The first 6 instances of each action are used for training, with the remaining 2 instances used for testing. No validation set is employed. This approach leverages only 194 video clips out of 500+.
* **Multithreading Potential:** The code likely benefits from multithreading to enhance computational efficiency.
* **Preprocessing:** Refer to the `parametrization.m` file within the `Preprocessing` folder for details on parameterization during the preprocessing stage.

**Availability:**

The implementation and associated files are currently not publicly available. If you'd like to collaborate or explore reproduction of results, feel free to contact the repository owner.

**Additional Considerations:**

* Consider adding a license file to clarify the terms of use for your code.
* If possible, explore providing a minimal reproducible example for users to test the functionality.
* If you plan to make the code publicly available in the future, provide clear installation and usage instructions.






