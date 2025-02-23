library(devtools)
load_all("../R")
db_files <- c("2023_24_house.rds", "2023_24_senate.rds", "2023_spc_house.rds",
              "2023_spc_senate.rds", "2025_26_house.rds", "2025_26_senate.rds")

distance_func_ga <- function(r1, r2) {
  r <- t(rbind(r1, r2))
  names <- colnames(r)
  r %>% filter(!is.na(rlang::.data[names[[1]]]) & # nolint: object_usage_linter.
                 !is.na(rlang::.data[names[[2]]]))
  delta <- ifelse(r[names[1]] < 2 | r[names[2]] < 2, 0,
                  ifelse(r[names[1]] != r[names[2]], 1, 0))
  delta <- sum(delta)
  if (is.na(delta)) {
    delta <- 1
  }
  return(delta)
}

for (file in db_files) {
  file <- paste("../data", file, sep = "/")
  data <- readRDS(file)
  scaled <- makeplot(data, distance_func_ga)
  profiles <- data.frame(
    x = scaled[, 1],
    y = scaled[, 2]
  )
  profiles <- cbind(profiles, members[rownames(scaled), ])
  csv_file <- gsub(".rds", ".csv", file)
  write.csv(profiles, csv_file)
}

warnings()