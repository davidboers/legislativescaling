
test_that("Get US Senate profiles for the 119th Congress", {
  write_profiles_cong("../../data/119_2025_us_s.rds")
})

test_that("Get US House profiles for the 119th Congress", {
  write_profiles_cong("../../data/119_2025_us_h.rds")
})

test_that("Get US Senate profiles for the 118th Congress", {
  write_profiles_cong("../../data/118_2024_us_s.rds")
})

test_that("Get US House profiles for the 118th Congress", {
  write_profiles_cong("../../data/118_2024_us_h.rds")
})