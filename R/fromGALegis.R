library(httr)
library(sodium)

id_2023_24 <- "1031"
id_2023_spc <- "1032"
id_2025_26 <- "1033"

url_base <- "https://www.legis.ga.gov/api"

get_token <- function() {
  url <- paste(url_base, "authentication", "token", sep = "/")
  timestamp <- Sys.time()
  secret <- paste("QFpCwKfd7fjVEXFFwSu36BwwcP83xYgxLAhLYmKkletvarconst",
                  timestamp, sep = "")
  key <- rawToChar(sha512(charToRaw(secret)))
  response <- httr::GET(url, query = list("key" = key,
                                          "ms" = timestamp))
  data <- content(response)
  token <- paste("Bearer", data)
  return(token)
}

scrape_vote <- function(vote_id, token) {
  url <- paste(url_base, "Vote", "detail", vote_id, sep = "/")
  response <- httr::GET(url, accept_json(),
                        add_headers("Authorization" = token))
  data <- content(response)
  return(data)
}

get_vote_list <- function(session_id, chamber, token) {
  url <- paste(url_base, "Vote", "list", chamber, session_id, sep = "/")
  response <- httr::GET(url, accept_json(),
                        add_headers("Authorization" = token))
  data <- content(response)
  data <- data.frame(Reduce(rbind, data))
  return(data)
}

make_full_table <- function(vote_list, token) {
  data <- data.frame()
  for (vote_id in vote_list$id) {
    vote_data <- scrape_vote(vote_id, token)
    if (is.atomic(vote_data)) {
      votes <- vote_data["votes"]
    } else {
      votes <- vote_data$votes
    }
    vote_data <- data.frame(Reduce(rbind, votes))

    members <- data.frame(Reduce(rbind, vote_data$member))
    tdata <- data.frame(row.names = members$id)
    tdata$vote <- vote_data$memberVoted
    if (nrow(tdata) < nrow(data)) {
      rows_to_add <- nrow(data) - nrow(tdata)
      new_rows <- data.frame(matrix(NA, nrow = rows_to_add, ncol = ncol(tdata)))
      colnames(new_rows) <- colnames(tdata)
      tdata <- rbind(tdata, new_rows)
    }
    names(tdata)[names(tdata) == "vote"] <- paste(vote_id)

    if (nrow(data) == 0) {
      data <- tdata
    } else if (nrow(tdata) != 0) {
      data <- cbind(data, tdata)
    }
  }
  return(data)
}

distance_func_ga <- function(r1, r2) {
  r <- t(rbind(r1, r2))
  r1 <- as.character(r[, 1])
  r2 <- as.character(r[, 2])
  delta <- sum(r1 < 2 & r2 < 2 & r1 != r2)
  if (delta == 0) {
    return(1)
  } else {
    return(delta)
  }
}

make_profiles_ga <- function(file, members) {
  data <- readRDS(file)
  scaled <- makeplot(data, distance_func_ga)
  members <- members[rownames(scaled), ]
  whip_table <- make_whip_table(data, members)
  profiles <- data.frame(
    x = scaled[, 1],
    y = scaled[, 2],
    name = members$name,
    party = members$party,
    defection_rate = defection_rates(data, whip_table, members)$rate
  )
  return(profiles)
}

write_profiles_ga <- function(file, members) {
  profiles <- make_profiles_ga(file, members)
  csv_file <- gsub(".rds", ".csv", file)
  write.csv(profiles, csv_file)
  return(profiles)
}