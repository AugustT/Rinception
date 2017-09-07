# Distributed under http://www.apache.org/licenses/LICENSE-2.0 licence

# Modified from python scripts available here: 
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/examples/image_retraining/retrain.py

# Undertakes transfer learning with inception v3 architecture image recognition model

# avoid use of ".." in paths

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
  
  
  # Check arguments conform to type and change on windows / -> \\  
  # checkArgs()
  
  # Check tensorflow is available
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
              labels = file.path(getwd(), outputLabels)))
  
}