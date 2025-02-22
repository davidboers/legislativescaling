library(cluster)
library(usedist)

makeplot <- function(obj, distance_func) {
  return(cmdscale(custom_dist(obj, distance_func)))
}

custom_dist <- function(obj, distance_func) {
  return(dist_make(obj, distance_func))
}