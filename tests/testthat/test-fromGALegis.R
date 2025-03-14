token <- get_token()

test_that("Get Senate votes for 2023 special session", {
  lst <- get_vote_list(id_2023_spc, "2", token)
  data <- make_full_table(lst, token)
  expect_that(nrow(data), equals(56))
  saveRDS(data, file = "../../data/2023_spc_senate.rds")
})

test_that("Get House vote list for 2025-26 term", {
  lst <- get_vote_list(id_2025_26, "1", token)
  expect_that(nrow(lst), equals(890))
})

test_that("Get Senate vote list for 2025-26 term", {
  lst <- get_vote_list(id_2025_26, "2", token)
  expect_that(nrow(lst), equals(902))
})