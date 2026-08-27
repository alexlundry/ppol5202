# install.packages("countrycode")
library(tidyverse)
library(scales)
library(countrycode)

# Load the data
d1 <- read_csv("week5/global_power_plant_database_v_1_3/global_power_plant_database.csv")
d1$continent <- countrycode(d1$country, origin = "iso3c", destination = "continent")

d1 <- d1 %>%
  mutate(fossil_fuel = ifelse(primary_fuel %in% c("Coal", "Oil", "Petcoke"), "Fossil Fuel", "Non-Fossil Fuel")) %>%
  filter(continent != "Antarctica",
         is.na(continent) == F)

# Conditional Boxplot ######
## Boxplot: Fuel Type vs. Capacity
d1 %>%
  ggplot(aes(x = reorder(primary_fuel, capacity_mw, FUN = median), y = capacity_mw)) +
  geom_boxplot(aes(fill = fossil_fuel)) +
  labs(title = "Distribution of Power Plant Capacity by Primary Fuel",
       subtitle = "Global Power Plant Database",
       x = "Primary Fuel",
       y = "Power Plant Capacity (MW)") +
  scale_y_log10(labels = label_comma()) +
  scale_fill_manual(values = c("black", "lightgreen")) +
  coord_flip() +
  theme(legend.position = "none")


# Density plot ####
library(ggridges)
# Ridge plot for power plant capacity distribution by continent
ggplot(d1, aes(x = capacity_mw, y = continent, fill = continent)) +
  geom_density_ridges(alpha = 0.4) +
  scale_x_log10(labels = label_number()) +  # Log scale for better visualization of wide range of capacities
  theme_ridges() +
  theme(legend.position = "none") +
  labs(title = "Distribution of Power Plant Capacity by Continent",
       subtitle = "Global Power Plant Database",
       x = "Power Plant Capacity (MW)",
       y = "Continent")

# Bar Charts #####
continent_generation <- d1 %>%
  filter(continent != "Africa") %>%
  group_by(continent, fossil_fuel) %>%
  summarize(total_generation = sum(generation_gwh_2017, na.rm = TRUE), .groups = "drop")

# Stacked bar chart
ggplot(continent_generation, aes(reorder(continent, -total_generation),
                                 total_generation, fill = fossil_fuel)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = str_c(round(total_generation/1e6, 1), "MM")),
            position = position_stack(vjust = 0.5), color = "white") +
  scale_fill_manual(values = c("black", "lightgreen")) +
  scale_y_continuous(labels = label_number(scale = 1/1e6, suffix = "MM")) +
  labs(title = "Total Power Generation by Continent",
       subtitle = "Global Power Plant Database (2017)",
       x = "Continent",
       y = "Total Power Generation (GWh)",
       fill = "Type of Fuel") +
  theme(legend.position = "bottom")

# Grouped bar chart
ggplot(continent_generation, aes(x = reorder(continent, -total_generation), y = total_generation, fill = fossil_fuel)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = str_c(round(total_generation/1e6, 1), "MM")),
            position = position_dodge(width = 0.9), vjust = -0.5) +
  scale_fill_manual(values = c("black", "lightgreen")) +
  scale_y_continuous(labels = label_number(scale = 1/1e6, suffix = "MM")) +
  labs(title = "Total Power Generation by Continent",
       subtitle = "Global Power Plant Database (2017)",
       x = "Continent",
       y = "Total Power Generation (GWh)",
       fill = "Type of Fuel") +
  theme(legend.position = "bottom")

# 100% Stacked Bar Chart
ggplot(continent_generation, aes(x = reorder(continent, -total_generation), y = total_generation, fill = fossil_fuel)) +
  geom_bar(stat = "identity", position = "fill") +
  geom_text(aes(label = str_c(round(total_generation/1e6, 1), "MM")),
            position = position_fill(vjust = 0.5), color = "white") +
  scale_fill_manual(values = c("black", "lightgreen")) +
  scale_y_continuous(labels = label_percent()) +
  labs(title = "Total Power Generation by Continent",
       subtitle = "Global Power Plant Database (2017)",
       x = "Continent",
       y = "Total Power Generation (GWh)",
       fill = "Type of Fuel") +
  theme(legend.position = "bottom")


# Faceting ####
# Scatter plot: Capacity (MW) vs. Generation (GWh), faceted by continent & fossil fuel
d1 %>%
  filter(capacity_mw >= 1 & generation_gwh_2017 >= 1,
         continent != "Africa") %>%
  ggplot(aes(capacity_mw, generation_gwh_2017, color = fossil_fuel)) +
  geom_point(alpha = 0.3) +
  scale_x_log10(labels = label_number()) +
  scale_y_log10(labels = label_number()) +
  scale_color_manual(values = c("black", "lightgreen")) +
  coord_equal() +
  facet_grid(continent ~ fossil_fuel) +
  geom_abline(slope = 1, lty = "dashed", color = "darkgrey") +
  labs(title = "Power Plant Capacity vs. Annual Generation",
       subtitle = "Global Power Plant Database (2017)",
       x = "Power Plant Capacity (MW)",
       y = "Annual Generation (GWh)",
       color = "Continent") +
  theme(legend.position = "none")

# Dotplot #####
# Filter for Asian countries and calculate average power plant capacity
asia_capacity <- d1 %>%
  filter(continent == "Asia") %>%
  group_by(country_long) %>%
  summarise(avg_capacity = mean(capacity_mw, na.rm = TRUE)) %>%
  arrange(avg_capacity)

asia_capacity %>%
  ggplot(aes(avg_capacity, reorder(country_long, avg_capacity))) +
  geom_segment(aes(x = 0,
                   xend = avg_capacity,
                   y = reorder(country_long, avg_capacity),
                   yend = reorder(country_long, avg_capacity)),
               color = "lightgrey") +
  geom_point(color = "darkred", size = 2) +
  labs(x = "Average Power Plant Capacity (MW)",
       y = "",
       title = "Average Power Plant Capacity by Country",
       subtitle = "Global Power Plant Database (2017)") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

# Time Series #######
d2 <- d1 %>%
  filter(if_all(starts_with("generation_gwh_"), ~ !is.na(.))) %>%
  select(country:primary_fuel, fossil_fuel, commissioning_year,
         generation_gwh_2013:generation_gwh_2019)

glimpse(d2)

d3 <- d2 %>%
  select(name, gppd_idnr, fossil_fuel, primary_fuel,
         generation_gwh_2013:generation_gwh_2019) %>%
  pivot_longer(cols = generation_gwh_2013:generation_gwh_2019,
               names_to = "year", values_to = "generation") %>%
  mutate(year = as.numeric(str_sub(year, start = -4))) %>%
  group_by(year, fossil_fuel) %>%
  summarize(avg_gen = mean(generation))

glimpse(d3)

ggplot(d3, aes(year, avg_gen, color = fossil_fuel)) +
  geom_line(size = 3) +
  geom_label(aes(label = round(avg_gen, 0), fill = fossil_fuel),
             color = "white", show.legend = F) +
  scale_color_manual(values = c("black", "lightgreen")) +
  scale_fill_manual(values = c("black", "lightgreen")) +
  labs(
    title = "Estimated Annual Generation Over Time",
    x = "Year",
    y = "Estimated Generation (GWh)",
    color = "Type of Fuel"
  )

# stacked area chart ######
ggplot(d3, aes(x = year, y = avg_gen, fill = fossil_fuel)) +
  geom_area(position = "stack") +
  geom_text(aes(label = str_c(round(avg_gen, 0), "gwh")), position = position_stack(vjust = 0.5), color = "white") +
  scale_fill_manual(values = c("black", "lightgreen")) +
  labs(title = "Proportion of Fossil vs. Non-Fossil Fuel Generation",
       subtitle = "2013-2019",
       x = "Year",
       y = "Average Generation (GWh)",
       fill = "Fuel Type")

# 100% stacked area chart ####
ggplot(d3, aes(x = year, y = avg_gen, fill = fossil_fuel)) +
  geom_area(position = "fill") +
  geom_text(aes(label = str_c(round(avg_gen, 0), "gwh")), position = position_fill(vjust = 0.5), color = "white") +
  scale_fill_manual(values = c("black", "lightgreen")) +
  scale_y_continuous(labels = label_percent()) +
  labs(title = "Proportion of Fossil vs. Non-Fossil Fuel Generation",
       subtitle = "2013-2019",
       x = "Year",
       y = "Average Generation (GWh)",
       fill = "Fuel Type")


# Dumbbell plot #######
# install.packages("devtools") # Install devtools if not already installed
library(devtools)
# install_github("hrbrmstr/ggalt")
library(ggalt)

d4 <- d1 %>%
  filter(country == "USA") %>%
  group_by(primary_fuel) %>%
  summarize(across(starts_with("generation_gwh_"), \(x) sum(x, na.rm = TRUE)))

# Create dumbbell plot
ggplot(d4, aes(y = reorder(primary_fuel, generation_gwh_2019), x = generation_gwh_2013, xend = generation_gwh_2019)) +
  geom_dumbbell(size = 1.2,
                size_x = 4,
                size_xend = 4,
                colour = "grey",
                colour_x = "black",
                colour_xend = "orange") +
  scale_x_log10(labels = label_number()) +
  labs(title = "USA Change in Total Generation by Fuel Type 2013-2019",
       x = "Total Generation (GWh)",
       y = "Primary Fuel")
