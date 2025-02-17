token <- get_token()

test_that("Get House vote list for 2023-24 term", {
  lst <- get_vote_list(id_2023_24, "1", token)
  expect_that(nrow(lst), equals(890))
})

test_that("Get Senate vote list for 2023-24 term", {
  lst <- get_vote_list(id_2023_24, "2", token)
  expect_that(nrow(lst), equals(902))
})