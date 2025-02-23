members <- jsonlite::fromJSON(txt = "../../data/member-info.json")
rownames(members) <- members$id
members <- subset(members, select = -c(id))

test_that("Get Senate profiles for 2023 special session", {
  file <- "../../data/2023_spc_senate.rds"
  profiles <- write_profiles_ga(file, members)
  expect_that(3, equals(3))
})

test_that("Get Senate profiles for 2023-24 session", {
  file <- "../../data/2023_24_senate.rds"
  profiles <- write_profiles_ga(file, members)
  expect_that(3, equals(3))
})