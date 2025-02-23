library(devtools)
library(jsonlite)
load_all("../R")
db_files <- c("2023_24_house.rds", "2023_24_senate.rds", "2023_spc_house.rds",
              "2023_spc_senate.rds", "2025_26_house.rds", "2025_26_senate.rds")

members <- jsonlite::fromJSON(txt = "../data/member-info.json")
rownames(members) <- members$id
members <- subset(members, select = -c(id))

for (file in db_files) {
  file <- paste("../data", file, sep = "/")
  write_profiles_ga(file, members)
}

warnings()