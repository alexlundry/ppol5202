# install.packages(c("wbwdi", "countrycode", "gifski", "av", "gganimate", "plotly"))
library(wbwdi)
library(countrycode)
library(tidyverse)
library(gganimate)
library(plotly)

###############################################################
# 1. Urban Population vs. Mean Annual Air Pollution
###############################################################
urban_pollution <- wdi_get(indicators = c("SP.URB.TOTL.IN.ZS", "EN.ATM.PM25.MC.M3"),
                           entities   = "all") %>%
  mutate(indicator_id = if_else(indicator_id == "SP.URB.TOTL.IN.ZS", "urban_pop_pct", "mean_annual_air_pollution")) %>%
  pivot_wider(names_from = indicator_id,
              values_from = value) %>%
  mutate(country_name = countrycode(entity_id,
                                    origin = "iso3c",
                                    destination = "country.name"),
         continent = countrycode(entity_id,
                                 origin = "iso3c",
                                 destination = "continent")) %>%
  filter(year >= 1990,
         is.na(continent) == F)


###############################################################
# 2. Fertility Rate vs. Female Labor Force Participation
###############################################################
fertility_female_lfp <- wdi_get(indicators = c("SP.DYN.TFRT.IN", "SL.TLF.CACT.FE.ZS"), entities  = "all") %>%
  mutate(indicator_id = if_else(indicator_id == "SP.DYN.TFRT.IN", "fertility_rate", "female_labor_force")) %>%
  pivot_wider(names_from = indicator_id, values_from = value)  %>%
  mutate(country_name = countrycode(entity_id,
                                    origin = "iso3c",
                                    destination = "country.name"),
         continent = countrycode(entity_id,
                                 origin = "iso3c",
                                 destination = "continent")) %>%
  filter(year >= 1990,
         is.na(continent) == F)

###############################################################
# 3. Internet Usage vs. Mobile Subscriptions
###############################################################
internet_mobile <- wdi_get(indicators = c("IT.NET.USER.ZS", "IT.CEL.SETS.P2"), entities   = "all") %>%
  mutate(indicator_id = if_else(indicator_id == "IT.NET.USER.ZS", "internet_users_percent", "mobile_subs_per_100")) %>%
  pivot_wider(names_from = indicator_id, values_from = value)  %>%
  mutate(country_name = countrycode(entity_id,
                                    origin = "iso3c",
                                    destination = "country.name"),
         continent = countrycode(entity_id,
                                 origin = "iso3c",
                                 destination = "continent")) %>%
  filter(year >= 1990,
         is.na(continent) == F)