library(devtools)
load_all("../R")

data <- readRDS("../data/2023_spc_senate.rds")

members <- jsonlite::fromJSON(txt = "../data/member-info.json")
rownames(members) <- members$id
members <- subset(members, select = -c(id))

whip_table <- make_whip_table(data, members)
whip_table
defection_rates(data, whip_table, members)