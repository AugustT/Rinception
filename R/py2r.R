py2R <- function(x){
  
  x <- gsub('^\\[[[:digit:]]+\\][[:space:]]*\\\"' , '', gsub('\\\"[[:space:]]*$', '', x))
  split <- unlist(strsplit(x, split = ','))
  data.frame(species = as.character(split[1]),
             score = as.numeric(split[2]))
  
}