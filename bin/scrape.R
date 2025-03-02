library(devtools)
load_all("../R")
token <- get_token()
session_id <- c(id_2023_24, id_2023_24, id_2023_spc,
                id_2023_spc, id_2025_26, id_2025_26)
chamber <- c("1", "2", "1", "2", "1", "2")
file <- c("2023_24_house.rds", "2023_24_senate.rds", "2023_spc_house.rds",
          "2023_spc_senate.rds", "2025_26_house.rds", "2025_26_senate.rds")
databases <- data.frame(id = 1:6, session_id, chamber, file)
for (i in seq_len(nrow(databases))) {
  database <- databases[i, ]
  members <- get_member_list(database$session_id, database$chamber, token)
  lst <- get_vote_list(database$session_id, database$chamber, token)
  data <- make_full_table(lst, token)
  saveRDS(data, file = paste("../data", database$file, sep = "/"))
  membersfile <- paste("members_", database$file, sep = "")
  saveRDS(members, file = paste("../data", membersfile, sep = "/"))
  print(paste("Made database:", database$file))
}