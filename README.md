# lenny-classifier

image classifier for detecting Lenny

## Description

This repo contains the source code for training and using an image classifier that detects whether an image contains Lenny.
Due to the size footprint, the source images used for training have not been included

This code is based on the [TensorFlow tutorials for image recognition](https://www.tensorflow.org/tutorials/image_recognition) and the
[image retraining tutorial](https://www.tensorflow.org/tutorials/image_retraining) acted as the base of this project. This code was only
slightly modified for logistical reasons, and it was extended with a web endpoint for inspection. The core algorithm (InceptionV3) is the
same and off-the-shelf; we trained it with our own custom dataset and it has performed quite well in our testing.

See the releases tab to download a trained model.
