# Rinception

A package for creating image classifiers using transfer learning with inception v3 architecture image recognition model. This package is a simple wrapper around pre-existing python scripts which can be found here https://github.com/tensorflow/tensorflow/tree/master/tensorflow/examples/image_retraining.

# Installation

You will first need to install python and tensorflow if you dont already have them. Python can be installed from https://www.python.org/downloads/. Tensorflow can be installed from within R.

```r
# Install tensorflow
install.packages(tensorflow)
tensorflow::install_tensorflow()
```

With these installed you can install the `Rinception` R package

```r
install.packages('devtools')
install_github('AugustT/Rinception')
```

## Using Rinception

`Rinception` has two main function. The first `retrainInception` is used to train the inception model on a new set of images

```r
# Create a temporary directory to host images
tDir <- tempdir()

# Get example images (218MB) - Flowers
download.file(url = "http://download.tensorflow.org/example_images/flower_photos.tgz", 
              destfile = file.path(tDir, 'images.tgz'))

# Unzip example images
untar(tarfile = file.path(tDir, 'images.tgz'), exdir = file.path(tDir, 'images'))

# Very fast but bad model
incep <- retrainInception(imageDir = file.path(tDir, 'images/flower_photos'),
                          trainingSteps = 50,
                          trainingBatchSize = 10,
                          testBatchSize = 10,
                          validationBatchSize = 20)
```

See the help documentation for the numerous arguements available to `retrainInception`. It is very important to parameterise these correctly to get the best performance from your model.

The second function, `classify` uses the model in the retraining step to classify new images.

```r
# Get the paths to all of the images we downloaded
images <- list.files(file.path(tDir, 'images/flower_photos'),
                     recursive = TRUE, full.names = TRUE)
  
# Classify 5 images at random
classify(images = sample(images, size = 5),
         model = incep$model,
         labels = incep$labels)
```

## Learn more

More information is available on the tensorflow website, https://www.tensorflow.org/tutorials/image_retraining, and the pythos scripts on which this package is based can be viewed here: https://github.com/tensorflow/tensorflow/tree/master/tensorflow/examples/image_retraining