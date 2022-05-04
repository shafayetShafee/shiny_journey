library(dplyr)
library(reactable)
library(shiny)
library(fresh)
library(bs4Dash)
library(shinycssloaders)


# preparing ---------------------------------------------------------------

source("mod_table.R")
source("mod_about.R")
source("mod_plot.R")

data("diamonds", package = "ggplot2")
data("mtcars")
data("CO2")

mtcars <- mtcars %>%
  as_tibble() %>%
  mutate(across(c(cyl, vs, am, gear, carb), .fns = forcats::as_factor))

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

theme <- create_theme(
  bs4dash_layout(
    main_bg = "#fff3f0",
    sidebar_width = "22%"
  ),
  bs4dash_color(
    gray_900 = "#0a0a0a"
  )
)

# main app ---------------------------------------------------------------

ui <- dashboardPage(
  dark = NULL,
  preloader = list(html = tagList(spin_1(), "Loading ..."), color = "#343a40"),
  scrollToTop = TRUE,
  freshTheme = theme,
  dashboardHeader(
    title = "Exercise with Shiny modules - 01"
  ),
  dashboardSidebar(
    width = "22%",
    minified = FALSE,
    skin = "white",
    elevation = 3,
    selectInput(
      inputId = "dataset", label = "Select a Dataset",
      choices = c("mtcars", "diamonds", "CO2"),
      selected = "mtcars"
    ),
    conditionalPanel(
      "input.data_tab == 'summary_table'",
      div(checkboxInput(
        inputId = "summary",
        label = "Show Summary",
        value = FALSE,
        width = "100%"
      ), class = "cbcontainer")
    ),
    conditionalPanel(
      "input.data_tab == 'plot_tab'",
      selectInput(
        inputId = "theme",
        label = "Plot theme",
        choices = echart_theme,
        selected = "infographic"
      ),
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "style.css"
      )
    ),
    fluidPage(
      fluidRow(
        tabBox(
          id = "data_tab", width = 12,
          tabPanel(
            title = "About",
            about_ui("about")
          ),
          tabPanel(
            title = "Data",
            table_ui("table"),
            value = "summary_table"
          ),
          tabPanel(
            title = "Hisogram & Boxplot",
            plot_ui("plot"),
            value = "plot_tab"
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  datasetInput <- reactive({
    req(input$dataset)
    switch(input$dataset,
      "mtcars" = mtcars,
      "diamonds" = diamonds,
      "CO2" = CO2
    )
  })

  table_server(id = "table", datasetInput, reactive({
    input$summary
  }))
  about_server(id = "about", reactive({
    input$dataset
  }))
  plot_server(id = "plot", datasetInput, reactive({
    input$theme
  }))
}

shinyApp(ui, server)
