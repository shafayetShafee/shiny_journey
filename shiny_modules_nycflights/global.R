library(shinydashboard)
library(echarts4r)
library(dplyr)
library(shiny)
library(nycflights13)

echart_theme <- c(
  "auritus", "azul", "bee-inspired", "blue", "caravan", "carp", "chalk",
  "cool", "dark-blue", "dark-bold", "dark-digerati", "dark-fresh-cut",
  "dark-mushroom",
  "dark", "eduardo", "essos", "forest", "fresh-cut", "fruit", "gray", "green",
  "halloween", "helianthus", "infographic", "inspired", "jazz", "london", "macarons",
  "macarons2", "mint", "purple-passion", "red-velvet", "red", "roma", "royal",
  "sakura", "shine", "tech-blue", "vintage", "walden", "wef", "weforum", "westeros",
  "wonderland"
)

ua_data <- nycflights13::flights %>%
  dplyr::filter(carrier == "UA") %>%
  mutate(
    ind_arr_delay = (arr_delay > 5)
  ) %>%
  group_by(year, month, day) %>%
  summarise(
    n = n(),
    across(ends_with("delay"), mean, na.rm = TRUE)
  ) %>%
  ungroup()

axis_names <- setNames(
  c("Departure Delay", "Arrival Delay", "Proportion Delay"),
  c("dep_delay", "arr_delay", "ind_arr_delay")
)


viz_monthly <- function(df, y_var, threshold = NULL, theme) {
  df %>%
    e_charts_("day", dispose = TRUE) %>%
    e_line_(y_var, name = "Delay") %>%
    e_mark_line(data = list(yAxis = threshold)) %>%
    e_x_axis(
      nameLocation = "center",
      nameTextStyle = list(
        padding = c(10, 4, 10, 4),
        fontSize = 16
      )
    ) %>%
    e_y_axis(
      nameLocation = "center",
      nameTextStyle = list(
        padding = c(10, 4, 20, 4),
        fontSize = 16
      )
    ) %>%
    e_tooltip(
      trigger = "axis",
      formatter = e_tooltip_item_formatter("decimal")
    ) %>%
    e_theme(theme) %>%
    e_legend(bottom = 0) %>%
    e_axis_labels(x = "Day", y = axis_names[[y_var]]) %>%
    e_toolbox_feature(feature = "saveAsImage")
}


source("mod-plot.R")
source("mod-text.R")
source("mod-metric.R")
