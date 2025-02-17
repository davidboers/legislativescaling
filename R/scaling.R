library(cluster)

makeplot <- function(obj) {
  return(cmdscale(dist(obj)))
}