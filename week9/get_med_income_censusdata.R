library(tidyverse)
library(tidycensus)

us_med_income <- get_acs(
  geography = "state",
  variables = "B19013_001",
  geometry = TRUE,
  year = 2020
)

st_write(us_med_income, "data/us_med_income.gpkg", driver = "GPKG")

us_med_income <- us_med_income %>%
  as_tibble() %>%
  select(state = NAME, med_income = estimate)

us_med_income <- USAboundaries::state_codes %>%
  select(state_name, state_abbr) %>%
  right_join(us_med_income, , by = c("state_name" = "state"))

write_csv(us_med_income, "data/us_med_income.csv")
