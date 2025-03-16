library(devtools)
library(jsonlite)
load_all("../R")

# Georgia General Assembly

db_files <- c("2023_24_house.rds", "2023_24_senate.rds", "2023_spc_house.rds",
              "2023_spc_senate.rds", "2025_26_house.rds", "2025_26_senate.rds")

for (file in db_files) {
  path <- paste("../data", file, sep = "/")
  membersfile <- paste("members_", file, sep = "")
  members <- readRDS(paste("../data", membersfile, sep = "/"))
  write_profiles_ga(path, members)
}

# Congress

write_profiles_cong("../data/119_2025_us_s.rds")
print("Senate finished")
write_profiles_cong("../data/119_2025_us_h.rds")
print("House finished")

warnings()