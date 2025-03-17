library(cluster)
library(usedist)

distance_func <- function(r1, r2) {
  r <- t(rbind(r1, r2))
  r1 <- r[, 1]
  r2 <- r[, 2]
  delta <- sum(!is.na(r1) & !is.na(r2) &
                 as.character(r1) != as.character(r2))
  if (is.na(delta) || delta == 0) {
    return(1)
  } else {
    return(delta)
  }
}

makeplot <- function(obj) {
  my_distance_func <- function(r1, r2) distance_func(r1, r2)
  return(cmdscale(custom_dist(obj, my_distance_func)))
}

custom_dist <- function(obj, distance_func) {
  return(dist_make(obj, distance_func))
}