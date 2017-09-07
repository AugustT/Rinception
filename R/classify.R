# This takes an image and a retrained model and returns
# classifications

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
    colnames(classification) <- c('species', 'probability') 
    
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