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
    if (nrow(data) == 0) {
      data <- data.frame(row.names = vote_data$member)
    }
    data[paste(vote_id)] <- vote_data$memberVoted
  }
  return(data)
}