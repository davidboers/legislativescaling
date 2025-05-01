library(cluster)
library(usedist)
library(smacof)

distance_func <- function(r1, r2) {
  r <- t(rbind(r1, r2))
  delta <- sum(!is.na(r[, 1]) & !is.na(r[, 2]) &
                 as.character(r[, 1]) != as.character(r[, 2]))
  return(ifelse(is.na(delta) || delta == 0, 1, delta))
}

makeplot <- function(obj) {
  dist_matrix <- custom_dist(obj, distance_func)
  smacof_result <- smacofSym(dist_matrix)
  return(smacof_result$conf)
}

custom_dist <- function(obj, distance_func) {
  return(dist_make(obj, distance_func))
}