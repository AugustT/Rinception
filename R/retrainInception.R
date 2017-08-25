# Distributed under http://www.apache.org/licenses/LICENSE-2.0 licence

# Modified from python scripts available here: 
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/examples/image_retraining/retrain.py

# Undertakes transfer learning with inception v3 architecture image recognition model

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
                             rondomScale = 0,
                             randomBrightness = 0){
  
  
  # Check arguments conform to type and change on windows / -> \\  
  # checkArgs()
  
  # Check tensorflow is available
  # checkTensorflow()
  
  # check for the presence of Python
  if(Sys.which('python') == '') stop('Python is required but cannot be found, please download and install from: www.python.org/downloads/')
  
  callargs <- paste('--image_dir', imageDir,
                    '--output_graph', outputGraph,
                    '--output_labels', outputLabels,
                    '--summaries_dir', summariesDir,
                    '--how_many_training_steps', trainingSteps,
                    '--learning_rate', learningRate,
                    '--testing_percentage', testingPercentage,
                    '--validation_percentage', validationPaercentage,
                    '--eval_step_interval', evaluationInterval,
                    '--train_batch_size', trainingBatchSize,
                    '--test_batch_size', testBatchSize,
                    '--validation_batch_size', validationBatchSize,
                    '--model_dir', modelDir,
                    '--bottleneck_dir', bottleneckDir,
                    '--final_tensor_name', finalTensorName,
                    '--flip_left_right', flipLeftRight,
                    '--random_crop', randomCrop,
                    '--random_scale', rondomScale,
                    '--random_brightness', randomBrightness)
  
  pycall <- paste('python', 'retrain_new.py', callargs)
  start <- Sys.time()
  cat('Calling Python...\n')
  # system(command = pycall)
  cat(file.path(system.file("python", package = "Rinception"), 'retrain_new.py'), '\n')
  end <- Sys.time()
  cat('Time elapsed:', end - start, '\n')
  cat('Output graph and labels:', outputGraph, outputLabels)
  
}