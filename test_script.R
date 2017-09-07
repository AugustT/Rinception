# test script
rm(list = ls())

library(Rinception)

tDir <- tempdir()
org <- getwd()
setwd(tDir)

incep <- retrainInception(imageDir = system.file("test_images", package = "Rinception"),
                          trainingSteps = 50)

images <- list.files(system.file("test_images", package = "Rinception"),
                     recursive = TRUE, full.names = TRUE)[1:3]
  
classify(images = images,
         model = incep$model,
         labels = incep$labels)

setwd(org)