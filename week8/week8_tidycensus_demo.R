library(tidyverse)
library(sf)
library(tidycensus)
library(tigris)
library(tilegramsR)
library(scales)

# Only necessary if you do more than 500 API calls a day
# census_api_key("YOUR_API_KEY_GOES_HERE")  # add the parameter install = TRUE if you want your API key stored in your R environment for future use

v23 <- load_variables(2023, "acs5", cache = TRUE)

glimpse(v23)

per_capita_income <- get_acs(
  geography = "state",
  variables = "B19301_001",
  year = 2023,
  survey = "acs5",
  geometry = TRUE # this makes it an SF file
)

head(per_capita_income)

# quick non-map viz
per_capita_income %>%
  ggplot(aes(x = estimate, y = reorder(NAME, estimate))) +
  geom_point()

# make a basic map
ggplot(per_capita_income, aes(fill = estimate)) +
  geom_sf()

# fix the non-contiguous issue
pci_alt <- per_capita_income %>%
  shift_geometry()

ggplot(pci_alt, aes(fill = estimate)) +
  geom_sf()

pci_alt %>%
  ggplot(aes(fill = estimate)) +
  geom_sf(color = "white") +
  scale_fill_viridis_c(option = "viridis", direction = -1) +
  theme_void()

st_crs(pci_alt)

# 4326	WGS 84	Raw lat/lon coordinates (not for visualization)
# 3857	Web Mercator	Web-based maps (Google, OSM, Leaflet)
# 5070	Albers Equal-Area Conic	Thematic mapping (recommended for US)
# 9311	US National Atlas Equal Area	Preserving true area representation
# ESRI:102003	Lambert Conformal Conic	General cartography, preserving shapes
# ESRI:102008	Lambert Azimuthal Equal Area	Good for contiguous US maps
# ESRI:54052	Goode’s Homolosine	Interrupted map that breaks up the US
# ESRI:53015	Wagner IV	US looks inflated and stretched
# ESRI:54029 Van der Grinten	US gets warped into a circle

my_crs <- "ESRI:54029"

pci_alt %>%
  st_transform(crs = my_crs) %>%
  ggplot(aes(fill = estimate)) +
  geom_sf(color = NA) +
  scale_fill_viridis_c(option = "viridis", direction = -1) +
  theme_void()

# cartogram
left_join(sf_NPR1to1, per_capita_income, by = c("FID" = "GEOID")) %>%
  ggplot() +
  geom_sf(aes(fill = estimate))

left_join(sf_NPR1to1, as_tibble(per_capita_income), by = c("FID" = "GEOID")) %>%
  ggplot() +
  geom_sf(aes(fill = estimate))

left_join(sf_NPR1to1, as_tibble(per_capita_income), by = c("FID" = "GEOID")) %>%
  ggplot() +
  geom_sf(aes(fill = estimate)) +
  geom_sf_text(aes(label = state), color = "white") +
  scale_fill_viridis_c(name = "viridis", direction = -1,
                       labels = label_currency(prefix = "$", scale = 1/1000, suffix = "K")) +
  theme_void()

# Abortion policy (categorical maps)
# https://www.kff.org/womens-health-policy/state-indicator/gestational-limit-abortions
ab <- read_csv("week9/data/abortion_law_by_state.csv") %>%
  janitor::clean_names()

glimpse(ab)

usmap <- states()
glimpse(usmap)

ggplot(usmap) +
  geom_sf()

ab <- left_join(usmap, ab, by = c("NAME" = "location")) %>%
  shift_geometry() %>%
  filter(STATEFP <= 56)

stat_limit <- unique(ab$statutory_limit_on_abortions)
stat_limit <- stat_limit[c(1, 2, 6, 8, 7, 5, 3, 9, 4)]

ab <- ab %>%
  mutate(statutory_limit_on_abortions = factor(statutory_limit_on_abortions, stat_limit))

ggplot(ab) +
  geom_sf(aes(fill = statutory_limit_on_abortions), color = "white") +
  scale_fill_viridis_d(option = "mako") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, size = 24, family = "DIN", face = "bold"),
        plot.caption = element_text(size = 8, family = "Gill Sans", face = "italic")) +
  labs(title = "Statutory Limits on Abortion",
       fill = "",
       caption = "KFF analysis of state policies and court decisions, as of December 20, 2024.")

# cartogram
left_join(sf_NPR1to1, as_tibble(ab), by = c("FID" = "GEOID")) %>%
  ggplot() +
  geom_sf(aes(fill = statutory_limit_on_abortions), color = "white") +
  geom_sf_text(aes(label = state), color = "white") +
  scale_fill_viridis_d(option = "mako") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, size = 24, family = "DIN", face = "bold"),
        plot.caption = element_text(size = 8, family = "Gill Sans", face = "italic")) +
  labs(title = "Statutory Limits on Abortion",
       fill = "",
       caption = "KFF analysis of state policies and court decisions, as of December 20, 2024.")

# using multiple geo datasets
pci <- get_acs(
  state = c("MD", "DC"),
  geography = "tract",
  variables = "B19301_001",
  geometry = TRUE,
  year = 2023
)

# Download spatial data for all US counties
counties <- counties(state = c("MD", "DC"))

# Simple viz of Per Capita Income
pci %>%
  ggplot(aes(fill = estimate)) +
  geom_sf()

# multiple geo datasets
st_crs(counties)
st_crs(pci_alt)

pci %>%
  st_transform(crs = 5070) %>%
  ggplot(aes(fill = estimate)) +
  geom_sf(color = "white") +
  scale_fill_viridis_c(option = "viridis",
                       direction = -1) +
  theme_void()

ggplot(pci) +
  geom_sf(aes(fill = estimate), color = "white") +
  scale_fill_viridis_c(option = "viridis", direction = -1,
                       labels = scales::label_currency(prefix = "$", scale = 1/1000, suffix = "K")) +
  geom_sf(data = counties, fill = NA, color = "black") +
  geom_sf_text(data = counties, aes(label = NAME), color = "black", size = 3) +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, size = 20, family = "DIN", face = "bold"),
        plot.caption = element_text(size = 8, family = "Gill Sans", face = "italic")) +
  labs(title = "Per Capita Income by Census Tract, Maryland and DC",
       fill = "2023 Dollars",
       caption = "2023 American Community Survey")
