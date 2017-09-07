# Format paths for system2 call
formatPath <- function(path){
  
  if(.Platform$OS.type == "unix") {
    
    return(paste0('"', path, '"'))
    
  }else {
    
    return(paste0('"', gsub("/", "\\\\",  path), '"'))
    
  }
  
}