#load necessary libraries
library(tidyverse)
library(scales)
library(janitor)
library(readxl)
library(visdat)

# Data Read In
# political violence
pv <- read_xlsx("week5/political_violence/USA_Canada_2020_2023_Nov24.xlsx")
glimpse(pv)

# Exploratory Analysis #####
pv_explore <- pv %>%
  slice_sample(n = 10000)

pv_explore %>%
  vis_dat()

pv_explore %>%
  vis_dat(sort_type = F)

pv_explore %>%
  abbreviate_vars() %>%
  vis_dat(facet = YEAR)

pv_explore %>%
  vis_miss()

pv_explore %>%
  vis_miss(cluster = T)

count(pv, EVENT_TYPE, SUB_EVENT_TYPE)

# NOMINAL #####
# Bar Charts #####
ggplot(pv, aes(EVENT_TYPE)) +
  geom_bar()

ggplot(pv, aes(fct_infreq(EVENT_TYPE))) +
  geom_bar()

ggplot(pv, aes(fct_infreq(EVENT_TYPE))) +
  geom_bar() +
  coord_flip()

p2 <- pv %>%
  mutate(events = fct_infreq(EVENT_TYPE) %>% fct_rev()) %>%
  count(events)

ggplot(p2, aes(events, n)) +
  geom_bar(stat = "identity") +
  coord_flip()

p3 <- pv %>%
  mutate(events = fct_infreq(EVENT_TYPE) %>% fct_rev(),
         violent = ifelse(events %in% c("Protests", "Strategic developments"),
                          "Non-Violent", "Violent")) %>%
  count(violent, events)

p3 %>%
  ggplot(aes(events, n, fill = violent)) +
  geom_bar(stat = "identity") +
  coord_flip()

p3 %>%
  ggplot(aes(events, n, fill = violent)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_fill_manual(values = c("Violent" = "darkred", "Non-Violent" = "grey"))

p3 %>%
  ggplot(aes(events, n, fill = violent)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Violent" = "darkred", "Non-Violent" = "grey")) +
  labs(title = "North American Political Conflict 2020-2023",
     x = "",
     y  = "N",
     fill = "Violence?") +
  coord_flip()

# Sophisticated Bar Chart #####
p3 %>%
  ggplot(aes(events, n, fill = violent)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = ifelse(n > 6000, comma(n), "")), hjust = 1) +
  geom_text(aes(label = ifelse(n < 6000, comma(n), "")), hjust = 0.1) +
  scale_fill_manual(values = c("Violent" = "darkred", "Non-Violent" = "grey")) +
  scale_y_continuous(labels = label_comma()) +
  labs(title = "North American Political Conflict 2020-2023",
       x = "",
       y  = "N",
       fill = "Violence?") +
  coord_flip()

# Pie Chart #####
pie1 <- pv %>%
  mutate(violent = ifelse(EVENT_TYPE %in% c("Protests", "Strategic developments"),
                                  "Non-Violent", "Violent")) %>%
  count(violent) %>%
  ggplot(aes(x = "", y = n, fill = violent)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Violent" = "darkred", "Non-Violent" = "grey"))

pie1

pie2 <- pie1 +
  coord_polar("y", start = 0) +
  theme_void()

pie2

# Treemap #####
library(treemapify)

pv %>%
  mutate(events = fct_infreq(EVENT_TYPE) %>% fct_rev(),
         violent = ifelse(events %in% c("Protests", "Strategic developments"),
                          "Non-Violent", "Violent")) %>%
  count(violent, events, total = n()) %>%
  mutate(pct = n / total) %>%
  ggplot(aes(fill = events, area = pct)) +
  geom_treemap() +
  geom_treemap_text(aes(label = str_c(events, " ", round(pct*100, 0), "%")),
                    color = "white",
                    place = "center", reflow = T) +
  labs(title = "North American Political Conflict 2020-2023") +
  theme(legend.position = "none")

# Waffle Chart #####
# install.packages("waffle")
library(waffle)


pv %>%
  filter(COUNTRY == "United States") %>%
  mutate(violent = ifelse(EVENT_TYPE %in% c("Protests", "Strategic developments"),
                          "Non-Violent", "Violent")) %>%
  count(violent) %>%
  mutate(total = sum(n),
         pct = n / total,
         base100 = round(pct * 100, 0)) %>%
  arrange(base100) %>%
  ggplot(aes(fill = violent, values = base100)) +
  geom_waffle(
    n_rows = 10,
    size = 0.33,
    colour = "white",
    flip = T
  ) +
  coord_equal() +
  theme_void() +
  labs(title = "Violence & Political Conflict in the United States 2020-2023",
       subtitle = "For every 100 US political conflicts, only 3 were violent.",
       fill = "Type of Conflict") +
  scale_fill_manual(values = c("grey", "darkred")) +
  theme(legend.position = "bottom")

# NUMERIC #####
# Data Read In
# co2 emissions
co2_cars_agg_bad <- read_csv("week5/co2_emissions/2022_Cars_Aggregated.csv")

co2_cars_agg <- read_csv("week5/co2_emissions/2022_Cars_Aggregated.csv") %>%
  clean_names()

glimpse(co2_cars_agg_bad)
glimpse(co2_cars_agg)

co2_cars_agg %>%
  abbreviate_vars() %>%
  vis_dat()

count(co2_cars_agg, fuel_type)

# Histogram #####
ggplot(co2_cars_agg, aes(obfcm_co2_emissions_g_km)) +
  geom_histogram()

ggplot(co2_cars_agg, aes(obfcm_co2_emissions_g_km)) +
  geom_histogram(bins = 10)

ggplot(co2_cars_agg, aes(obfcm_co2_emissions_g_km)) +
  geom_histogram(binwidth = 100)

# Density Plot #####
ggplot(co2_cars_agg, aes(obfcm_co2_emissions_g_km)) +
  geom_density(fill = "yellow")

ggplot(co2_cars_agg, aes(x = obfcm_co2_emissions_g_km, fill = fuel_type)) +
  geom_density(alpha = 0.5)

ggplot(co2_cars_agg, aes(x = obfcm_co2_emissions_g_km, fill = fuel_type)) +
  geom_density(alpha = 0.7) +
  facet_wrap(~fuel_type, ncol = 2) +
  theme(legend.position = "none")

# Boxplot #####
ggplot(co2_cars_agg, aes(obfcm_co2_emissions_g_km)) +
  geom_boxplot()

# Violin Plot -----
ggplot(co2_cars_agg, aes(x = "", y = obfcm_co2_emissions_g_km)) +
  geom_violin(fill = "lightblue", alpha = 0.7)

ggplot(co2_cars_agg, aes(x = "", y = obfcm_co2_emissions_g_km)) +
  geom_boxplot(width = 0.1, fill = "white", alpha = 0.8) +
  geom_violin(fill = "lightblue", alpha = 0.7)
