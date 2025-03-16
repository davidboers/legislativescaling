library(cluster)
library(usedist)

distance_func <- function(r1, r2, compare_func) {
  r <- t(rbind(r1, r2))
  r1 <- as.character(r[, 1])
  r2 <- as.character(r[, 2])
  delta <- sum(compare_func(r1, r2))
  if (is.na(delta) || delta == 0) {
    return(1)
  } else {
    return(delta)
  }
}

makeplot <- function(obj, compare_func) {
  my_distance_func <- function(r1, r2) distance_func(r1, r2, compare_func)
  return(cmdscale(custom_dist(obj, my_distance_func)))
}

custom_dist <- function(obj, distance_func) {
  return(dist_make(obj, distance_func))
}