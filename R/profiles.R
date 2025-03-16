make_profiles <- function(vote_table, members, compare_func) {
  scaled <- makeplot(vote_table, compare_func)
  members <- members[rownames(scaled), ]
  members$n <- length(vote_table)
  #whip_table <- make_whip_table(vote_table, members)
  profiles <- data.frame(
    x = scaled[, 1],
    y = scaled[, 2]
  )
  #drates <- defection_rates(vote_table, whip_table, members)
  return(cbind(profiles, members))
}

get_party_whip <- function(party_i, vote_id, vote_table) {
  votes <- vote_table[vote_table$party == party_i, ]
  tbl <- as.data.frame(table(lapply(votes[vote_id], unlist)))
  tbl <- tbl[order(tbl$Freq, decreasing = TRUE), ]
  whip <- tbl[1, 1]
  return(whip)
}

make_whip_table <- function(vote_table, members) {
  vote_table <- cbind(vote_table, members[rownames(vote_table), ])
  parties <- unique(members$party)
  tbl <- data.frame(row.names = colnames(vote_table))
  for (party in parties) {
    tbl[, party] <- sapply(rownames(tbl), function(vote_id) {
      get_party_whip(party, vote_id, vote_table)
    })
  }
  return(tbl)
}

defection_rates <- function(vote_table, whip_table, members) {
  data <- data.frame(row.names = rownames(vote_table))
  data$defectionRate <- sapply(seq_len(nrow(members)), function(i) {
    r <- data.frame(row.names = colnames(vote_table))
    r$vote <- lapply(colnames(vote_table), function(x) vote_table[i, x])
    r$whip <- whip_table[rownames(r), members$party[i]]
    r$defected <- unlist(r$vote) != unlist(r$whip)
    return(nrow(r[r$defected, ]) / nrow(r))
  })
  return(data)
}