#' Create an image classifier
#' 
#' Undertakes transfer learning with inception v3 architecture image recognition model.
#' 
#' @param imageDir Character Path the directory containing folders of images. Each folder should be named as the class e.g. 'dogs, 'cats', 'birds', and contain training images of those classes
#' @param outputGraph Character Path saying where to save the trained graph
#' @param outputLabels Character Path saying Where to save the trained graph's a labels
#' @param summariesDir Character Path saying where to save summary logs for TensorBoard.
#' @param trainingSteps Numeric how many training steps to run before ending, defaults to 4000. The more the better.
#' @param learningRate Numeric How large a learning rate to use when training, defaults to 0.01
#' @param testingPercentage Numeric What percentage of images to use as a test set, defaults to 10
#' @param validationPaercentage Numeric What percentage of images to use as a validation set, defaults to 10
#' @param evaluationInterval Numeric How often to evaluate the training results, defaults to intervals of 10
#' @param trainingBatchSize Numeric How many images to train on at a time, defaults to 500
#' @param testBatchSize Numeric How many images to test on at a time. This test set is only used infrequently to verify the overall accuracy of the model. Defaultss to 500
#' @param validationBatchSize Numeric How many images to use in an evaluation batch. This validation set is used much more often than the test set, and is an early indicator of how accurate the model is during training. Defaults to 100
#' @param modelDir Character Path to classify_image_graph_def.pb, imagenet_synset_to_human_label_map.txt, and imagenet_2012_challenge_label_map_proto.pbtxt. The model will be automatically downloaded if it hasnt been already.
#' @param bottleneckDir Character Path to cache bottleneck layer values as files
#' @param finalTensorName Character The name of the output classification layer in the retrained graph
#' @param flipLeftRight Logical Whether to randomly flip half of the training images horizontally, defualts to FALSE
#' @param randomCrop Numeric A percentage determining how much of a margin to randomly crop off the training images. Defaults to 0
#' @param randomScale Numeric A percentage determining how much to randomly scale up the size of the training images by. Defaults to 0
#' @param randomBrightness Numeric A percentage determining how much to randomly multiply the training image input pixels up or down by. Defaults to 0
#' @details This code requires tensorflow and python to run. These should be installed first. 
#' Tensorflow can be installed from within R using \code{tensorflow::install_tensorflow()}.
#' The function \code{retrainInception} is a simple wrapper around pre-existing python scripts which can be found
#' here \url{https://github.com/tensorflow/tensorflow/tree/master/tensorflow/examples/image_retraining}. Avoid use of avoid use of ".." in paths.
#' @return A list of paths for the model, model labels and the logs directory
#' @export        
#' @examples
#' \dontrun{
#' # Get example images (218MB)
#' tDir <- tempdir()
#' download.file(url = "http://download.tensorflow.org/example_images/flower_photos.tgz", 
#'               destfile = file.path(tDir, 'images.tgz'))
#'
#' # Unzip example images
#' untar(tarfile = file.path(tDir, 'images.tgz'), exdir = file.path(tDir, 'images'))
#'
#' # Train a model using images shipped with Rinception
#' # This is quick and dirty
#' incep <- retrainInception(imageDir = file.path(tDir, 'images/flower_photos'),
#'                           trainingSteps = 50,
#'                           trainingBatchSize = 10,
#'                           testBatchSize = 10,
#'                           validationBatchSize = 20)
#'                          
#' # Use Tensorboard to examine the model
#' tensorflow::tensorboard(log_dir = incep$log_dir)
#' }

retrainInception <- function(imageDir = 'images',
                             outputGraph = 'output_graph.pb',
                             outputLabels = 'output_labels.txt',
                             summariesDir = 'summaries',
                             trainingSteps = 4000,
                             learningRate = 0.01,
                             testingPercentage = 10,
                             validationPaercentage = 10,
                             evaluationInterval = 10,
                             trainingBatchSize = 500,
                             testBatchSize = 500,
                             validationBatchSize = 100,
                             modelDir = 'imagenet',
                             bottleneckDir = 'bottleneck',
                             finalTensorName = 'final_result',
                             flipLeftRight = FALSE,
                             randomCrop = 0,
                             randomScale = 0,
                             randomBrightness = 0){
  
  
  # Check arguments conform to type 
  stopifnot(is.character(imageDir),
            is.character(outputGraph),
            is.character(outputLabels),
            is.character(summariesDir),
            is.numeric(trainingSteps),
            is.numeric(learningRate),
            is.numeric(testingPercentage),
            is.numeric(validationPaercentage),
            is.numeric(evaluationInterval),
            is.numeric(trainingBatchSize),
            is.numeric(testBatchSize),
            is.numeric(validationBatchSize),
            is.character(modelDir),
            is.character(bottleneckDir),
            is.character(finalTensorName),
            is.logical(flipLeftRight),
            is.numeric(randomCrop),
            is.numeric(randomScale),
            is.numeric(randomBrightness))
  
  # Check tensorflow is available, how?
  # checkTensorflow()
  
  # check for the presence of Python
  if(Sys.which('python') == '') stop('Python is required but cannot be found, please download and install from: www.python.org/downloads/')
  
  callargs <- c('--image_dir', formatPath(imageDir),
                '--output_graph', formatPath(outputGraph),
                '--output_labels', formatPath(outputLabels),
                '--summaries_dir', formatPath(summariesDir),
                '--how_many_training_steps', trainingSteps,
                '--learning_rate', learningRate,
                '--testing_percentage', testingPercentage,
                '--validation_percentage', validationPaercentage,
                '--eval_step_interval', evaluationInterval,
                '--train_batch_size', trainingBatchSize,
                '--test_batch_size', testBatchSize,
                '--validation_batch_size', validationBatchSize,
                '--model_dir', formatPath(modelDir),
                '--bottleneck_dir', formatPath(bottleneckDir),
                '--final_tensor_name', finalTensorName,
                '--flip_left_right', flipLeftRight,
                '--random_crop', randomCrop,
                '--random_scale', randomScale,
                '--random_brightness', randomBrightness)
  
  retrain_path <- file.path(system.file("python", package = "Rinception"), 'retrain_new.py')
  start <- Sys.time()
  cat('Calling Python...\n')
  cat(retrain_path, '\n')
  cat(callargs, '\n')

  system2(command = 'python',
          args = c(formatPath(retrain_path), callargs))
  
  end <- Sys.time()
  cat('Time elapsed:', end - start, '\n')
  cat('Output graph and labels:', outputGraph, outputLabels)
  
  return(list(model = file.path(getwd(), outputGraph),
              labels = file.path(getwd(), outputLabels),
              log_dir = file.path(getwd(), summariesDir)))
  
}