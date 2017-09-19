#' Classify an image using an Inception v3 model
#' 
#' Classify uses a model and labels created through training of the inception model
#' to assign classification probabilities to a new image or images.
#' 
#' @param images Character vector of paths, or a single path, to the image/s to be classified
#' @param model Character giving the path to the model file. This file is created by
#'  \code{retrainInception}, which returns the path.
#' @param labels Character giving the path to the labels file. This file is created by
#'  \code{retrainInception}, which returns the path.
#' @param verbose Logical should updates on classifiation be printed to console
#' @details This code requires tensorflow and python to run. These should be installed first. 
#' Tensorflow can be installed from within R using \code{tensorflow::install_tensorflow()}.
#' The function \code{classify} is a simple wrapper around pre-existing python scripts which can be found
#' here \url{https://github.com/tensorflow/tensorflow/tree/master/tensorflow/examples/image_retraining}
#' @return A list of dataframes, in each case giving the top 5 classifications and their
#' probabilities
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
#' # Get the paths to three images
#' images <- list.files(file.path(tDir, 'images/flower_photos'),
#'                      recursive = TRUE, full.names = TRUE)
#'
#' # Classify 5 images at random
#' classify(images = sample(images, 5),
#'          model = incep$model,
#'          labels = incep$labels)
#'
#' }

classify <- function(images, model, labels, verbose = TRUE){
  
  stopifnot(all(sapply(list(images,model,labels), FUN = is.character)))
  
  classify_path <- file.path(system.file("python", package = "Rinception"), 'classify_image.py')
  
  exist <- sapply(images, FUN = file.exists)
  if(any(!exist)) stop(paste('Some images dont exist:', images[!exist]))
  
  Cimg <- function(image, classify_path, model, labels){
    
    if(verbose) cat(paste('Classifying', image, '\n'))

    raw_classifcation <- system2(command = 'python',
                                 args = c(formatPath(classify_path),
                                          formatPath(image),
                                          formatPath(model),
                                          formatPath(labels)),
                                 stdout = TRUE,
                                 stderr = TRUE)
  
    classification <- as.data.frame(do.call(rbind,
                                            strsplit(raw_classifcation,
                                                      ',')))
    colnames(classification) <- c('class', 'probability') 
    
    return(classification)
  }
  
  classifications <- lapply(images,
                            FUN = Cimg,
                            classify_path = classify_path,
                            model = model,
                            labels = labels)
  
  names(classifications) <- images
  
  return(classifications)
  
}