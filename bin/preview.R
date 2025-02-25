library(devtools)
load_all("../R")

data <- readRDS("../data/2025_26_senate.rds")

members <- readRDS("../data/members_2023_spc_senate.rds")
members

whip_table <- make_whip_table(data, members)
defection_rates(data, whip_table, members)