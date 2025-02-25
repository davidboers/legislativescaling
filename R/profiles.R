get_party_whip <- function(party_i, vote_id, vote_table) {
  votes <- vote_table[vote_table$party == party_i, ]
  tbl <- as.data.frame(table(lapply(votes[vote_id], unlist)))
  whip <- tbl[1, 1]
  return(whip)
}

make_whip_table <- function(vote_table, members) {
  vote_table2 <- cbind(vote_table, members[rownames(vote_table), ])
  parties <- unique(members$party)
  tbl <- data.frame(row.names = colnames(vote_table))
  for (party in parties) {
    tbl[, party] <- sapply(colnames(vote_table), function(vote_id) {
      get_party_whip(party, vote_id, vote_table2)
    })
  }
  return(tbl)
}

defection_rates <- function(vote_table, whip_table, members) {
  data <- data.frame(row.names = rownames(vote_table))
  data$rate <- sapply(seq_len(nrow(members)), function(i) {
    r <- data.frame(row.names = colnames(vote_table))
    r$vote <- lapply(colnames(vote_table), function(x) vote_table[i, x])
    r$whip <- whip_table[members$party[i]]
    c <- 0
    for (n in rownames(r)) {
      c <- c + (r[n, 1] != r[n, 2])
    }
    return(c / nrow(r))
  })
  return(data)
}