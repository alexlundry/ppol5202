###############################################
# Tidyverse Exercises: Annotated Answer Key
#
# This script demonstrates a set of small data
# wrangling tasks using the tidyverse.
# Each exercise shows the code solution along
# with explanatory comments for every step.
###############################################

###############################
# Exercise 1
###############################
mtcars %>%
  # Keep only the cars with 6 cylinders
  filter(cyl == 6) %>%
  # Select just the mpg, hp, and wt columns
  select(mpg, hp, wt) %>%
  # Create a new column "power_to_weight" = horsepower divided by weight
  mutate(power_to_weight = hp / wt) %>%
  # Calculate average mpg and average power-to-weight ratio
  summarize(avg_mpg = mean(mpg, na.rm = TRUE),
            avg_power_to_weight = mean(power_to_weight, na.rm = TRUE))


###############################
# Exercise 2
###############################
iris %>%
  # Group the data by species of iris
  group_by(Species) %>%
  # For each species, calculate average petal length and width
  summarize(avg_petal_length = mean(Petal.Length, na.rm = TRUE),
            avg_petal_width = mean(Petal.Width, na.rm = TRUE)) %>%
  # Arrange rows in descending order of average petal length
  arrange(desc(avg_petal_length))


###############################
# Exercise 3
###############################
gapminder %>%
  # Keep only rows from the year 2007 and continent Asia
  filter(year == 2007, continent == "Asia") %>%
  # Select country, life expectancy, and GDP per capita
  select(country, lifeExp, gdpPercap) %>%
  # Sort countries by life expectancy (highest first)
  arrange(desc(lifeExp))


###############################
# Exercise 4
###############################
ToothGrowth %>%
  # Create a new column converting dose units to milligrams
  mutate(dose_mg = dose * 10) %>%
  # Group data by supplement type (VC or OJ)
  group_by(supp) %>%
  # For each supplement, calculate average tooth length and count samples
  summarize(avg_length = mean(len, na.rm = TRUE),
            total_samples = n())


###############################
# Exercise 5
###############################
airquality %>%
  # Keep only rows from May and June
  filter(Month %in% c(5, 6)) %>%
  # Convert Fahrenheit temperatures to Celsius
  mutate(Temp_C = (Temp - 32) * 5/9) %>%
  # Calculate average temperature and maximum ozone level
  summarize(avg_temp = mean(Temp_C, na.rm = TRUE),
            max_ozone = max(Ozone, na.rm = TRUE))


###############################
# Exercise 6
###############################
mtcars %>%
  # Count number of cars by cylinder, weighting counts by wt variable
  count(cyl, wt = wt, sort = TRUE)


###############################
# Exercise 7
###############################
iris %>%
  # Create a new column "sepal_large" indicating if Sepal.Length > 5
  mutate(sepal_large = ifelse(Sepal.Length > 5, "Yes", "No"))


###############################
# Exercise 8
###############################
airquality %>%
  # Create a new categorical variable describing ozone levels
  mutate(air_quality = case_when(
    Ozone >= 100 ~ "High",                     # High if ozone is at least 100
    Ozone >= 50 & Ozone < 100 ~ "Moderate",    # Moderate if between 50–99
    is.na(Ozone) ~ "Missing",                  # Mark missing values explicitly
    TRUE ~ "Low"                               # Otherwise classify as Low
  ))


###############################
# Exercise 9
###############################
ToothGrowth %>%
  # Create a new categorical variable for dose levels
  mutate(dose_category = recode(dose,
                                `0.5` = "Low",
                                `1` = "Medium",
                                `2` = "High"))
