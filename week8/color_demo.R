###########################
# Load required libraries
library(ggplot2)
library(dplyr)
library(gapminder)  # Ensure gapminder is installed

# Filter dataset for cleaner visuals
gapminder_2007 <- gapminder %>% filter(year == 2007)

# Manual color assignment
ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point(size = 3) +
  scale_color_manual(values = c("Asia" = "red", "Europe" = "blue", "Africa" = "green",
                               "Americas" = "purple", "Oceania" = "orange"))

# Easy upgrade (Brewer Palette)
# The brewer scales provide sequential, diverging and qualitative colour schemes from ColorBrewer.
# scale_color_brewer for discrete data
# scale_color_distiller for continuous data
# scale_color_fermenter for binned continuous data ("discretize continuous data")
ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point(size = 3) +
  scale_color_brewer(palette = "Set1") # discrete data

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = lifeExp)) + # Diverging colors for continuous data
  geom_point(size = 3) +
  scale_color_distiller(palette = "Spectral", direction = 1)

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = lifeExp)) + # Diverging colors for continuous data
  geom_point(size = 3) +
  scale_color_distiller(palette = "Spectral", direction = -1)

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = lifeExp)) + # Sequential colors for continuous data
  geom_point(size = 3) +
  scale_color_distiller(palette = "Oranges")

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) + # binned color
  geom_point(aes(color = lifeExp)) +
  scale_color_fermenter()

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = lifeExp)) +
  scale_color_fermenter(palette = "Spectral", breaks = c(55, 70))

# Colorblind Friendly
# scale_color_viridis_d for discrete data
# scale_color_viridis_c for continuous data
# scale_color_viridis_b to bin continuous data
ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point(size = 3) +
  scale_color_viridis_d(option = "plasma")

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = lifeExp)) +
  geom_point(size = 3) +
  scale_color_viridis_c(option = "inferno")

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = lifeExp)) +
  geom_point(size = 3) +
  scale_color_viridis_b()

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = lifeExp)) +
  geom_point(size = 3) +
  scale_color_viridis_b(breaks = c(55, 70))

# Continuous color scaling (Gradient)
# scale_*_gradient⁠ creates a two color gradient (low-high),
# ⁠scale_*_gradient2⁠ creates a diverging color gradient (low-mid-high)
# scale_*_gradientn⁠ creates a n-color gradient.
ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = lifeExp)) +
  geom_point(size = 3) +
  scale_color_gradient(low = "blue", high = "red") # 2 color gradient

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = lifeExp)) +
  geom_point(size = 3) +
  scale_color_gradient2(low = "blue", mid = "white", high = "red", midpoint = 60) # 3 color gradient

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = lifeExp)) +
  geom_point(size = 3) +
  scale_color_gradientn(colors = c("blue", "green", "yellow", "red")) # custom multi-point gradient
