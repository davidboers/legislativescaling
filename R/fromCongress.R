library(rjson)

# Scraping

scrape_votes <- function(term, year, chamber) {
  # Root path: ../congress/data/{term}/votes/{year}
  # May need to be changed if you cloned the scraping
  # repository in a different place
  path_root <- paste("..", "congress", "data", term, "votes", year,
                     sep = "/")
  folder_names <- list.files(path_root,
                             pattern = paste(chamber, "[0-9]{1-3}", sep = ""))
  file_names <- paste(path_root, folder_names, "data.json", sep = "/")
  votes <- lapply(file_names, handle_vote)
  return(votes)
}

handle_vote <- function(file) {
  data <- fromJSON(file = file)
  vote_values <- names(data$votes)
  table <- data.frame()
  for (col in vote_values) {
    voters <- data.frame(Reduce(rbind, data$votes[[col]]))
    if (nrow(voters) == 0) {
      next
    }
    voters$memberVoted <- col
    rownames(voters) <- voters$id
    table <- rbind(table, voters)
  }
  names(table)[names(table) == "memberVoted"] <- paste(data$vote_id)
  return(list(table = table, vote_id = data$vote_id))
}

# Make profiles

compare_vote_cong <- function(r1, r2) {
  isyn1 <- r1 %in% c("Yea", "Nay", "Aye", "No")
  isyn2 <- r2 %in% c("Yea", "Nay", "Aye", "No")
  diff <- r1 != r2
  b <- isyn1 & isyn2 & diff
  return(b)
}

merge_vote_tables <- function(i, x) {
  i <- merge(i, x, by = "row.names", no.dups = FALSE)
  rownames(i) <- i$Row.names
  i$Row.names <- NULL
  return(i)
}

merge_member_tables <- function(i, x) {
  duprows <- rownames(x) %in% rownames(i)
  return(rbind(i, x[!duprows, ]))
}

make_profiles_cong <- function(file) {
  votes <- readRDS(file)
  vote_tables <- lapply(votes,
                        function(x) subset(x$table, select = c(x$vote_id)))
  vote_table <- Reduce(merge_vote_tables, vote_tables)
  member_tables <- lapply(votes,
                          function(x) { x$table[x$vote_id] <- NULL
                                      return(x$table) })
  members <- Reduce(merge_member_tables, member_tables)
  for (col in as.character(colnames(members))) {
    members[, col] <- as.character(members[, col])
  }
  return(make_profiles(vote_table, members, compare_vote_cong))
}

write_profiles_cong <- function(file) {
  profiles <- make_profiles_cong(file)
  csv_file <- gsub(".rds", ".csv", file)
  write.csv(profiles, csv_file)
  return(profiles)
}