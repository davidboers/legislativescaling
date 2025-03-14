
test_that("Get Senate profiles for 2023 special session", {
  file <- "../../data/2023_spc_senate.rds"
  members <- readRDS("../../data/members_2023_spc_senate.rds")
  write_profiles_ga(file, members)
  expect_that(3, equals(3))
})

test_that("Get Senate profiles for 2025-26 session", {
  file <- "../../data/2025_26_senate.rds"
  members <- readRDS("../../data/members_2025_26_senate.rds")
  profiles <- write_profiles_ga(file, members)
  expect_that(nrow(profiles), equals(56))
})

test_that("Get House profiles for 2025-26 session", {
  file <- "../../data/2025_26_house.rds"
  members <- readRDS("../../data/members_2025_26_house.rds")
  profiles <- write_profiles_ga(file, members)
  expect_that(nrow(profiles), equals(180))
})