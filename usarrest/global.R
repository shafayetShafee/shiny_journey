library(dplyr)
library(tibble)
library(DT)
library(echarts4r)
library(echarts4r.maps)
library(shiny)
library(shinydashboard)
library(shinycssloaders)

df <- USArrests

states <- rownames(df)

df <- df %>%
  rownames_to_column(var = "states")

c1 <- df %>%
  select(-states) %>%
  names(.)

c2 <- df %>%
  select(-c(states, UrbanPop)) %>%
  names(.)

df_no_states <- df %>%
  select(-states)

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

p_mat <- ggcorrplot::cor_pmat(df_no_states)

p_mat_df <- as.data.frame(as.table(round(p_mat, 2))) %>%
  rename(x = Var1, y = Var2, p = Freq) %>%
  mutate(
    p_val = case_when(
      p < 0.001 ~ "<0.001",
      TRUE ~ as.character(p)
    ),
    show = TRUE
  )

corr_df <- as.data.frame(as.table(round(cor(df_no_states), 2))) %>%
  rename(x = Var1, y = Var2, corr = Freq) %>%
  inner_join(p_mat_df, by = c("x", "y"))

