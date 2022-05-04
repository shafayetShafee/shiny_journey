library(dplyr)           # CRAN v1.0.8
library(shiny)           # CRAN v1.7.1
library(fresh)           # CRAN v0.2.0
library(waiter)          # CRAN v0.2.5
library(bs4Dash)         # CRAN v2.0.3
library(reactable)       # CRAN v0.2.3
library(shinycssloaders) # CRAN v1.0.0


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
  "helianthus", "infographic", "inspired", "jazz", "london", "macarons",
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

## Ui -----------------------------
ui <- dashboardPage(
  preloader = list(html = tagList(spin_1(), "Loading ..."), color = "#343a40"),
  title = "Shiny",
  dark = NULL,
  fullscreen = TRUE,
  ### Header -----------------------------
  dashboardHeader(
    title = dashboardBrand(
      title = "Simple App",
      color = "primary",
      href = "https://github.com/shafayetShafee",
      image = "https://github.com/shafayetShafee.png"
    ),
    skin = "light",
    status = "primary",
    border = TRUE,
    sidebarIcon = icon("bars"),
    controlbarIcon = icon("th"),
    fixed = FALSE
  ),
  ### Sidebar ---------------------------
  dashboardSidebar(
    skin = "light",
    status = "primary",
    elevation = 4,
    sidebarMenu(
      id = "sidebar",
      menuItem(
        "About",
        tabName = "about_tab",
        icon = icon("home")
      ),
      menuItem(
        "Data",
        tabName = "data_tab",
        icon = icon("table")
      ),
      menuItem(
        "Plots",
        tabName = "plot_tab",
        icon = icon("chart-area")
      )
    )
  ),
  ### Control-bar ----------------------
  controlbar = dashboardControlbar(
    skin = "light",
    pinned = FALSE,
    collapsed = FALSE,
    overlay = FALSE,
    controlbarMenu(
      id = "controlbarmenu",
      selected = "Controls",
      type = "pills",
      controlbarItem(
        title = "Controls",
        selectInput(
          inputId = "dataset", label = "Select a Dataset",
          choices = c("mtcars", "diamonds", "CO2"),
          selected = "mtcars"
        ),
        conditionalPanel(
          "input.sidebar == 'data_tab'",
          div(checkboxInput(
            inputId = "summary",
            label = "Show Summary",
            value = FALSE,
            width = "100%"
          ), class = "cbcontainer")
        ),
        conditionalPanel(
          "input.sidebar == 'plot_tab'",
          selectInput(
            inputId = "theme",
            label = "Plot theme",
            choices = echart_theme,
            selected = "infographic"
          )
        )
      )
    )
  ),
  ### Footer ------------------------
  footer = dashboardFooter(
    left = a(
      href = "https://twitter.com/shafayet_shafee",
      target = "_blank", "@shafayetShafee"
    ),
    right = "2022"
  ),
  ### Body -------------------------
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
        tabItems(
          # id = "data_tab", width = 12,
          tabItem(
            tabName = "about_tab",
            about_ui("about")
          ),
          tabItem(
            tabName = "data_tab",
            table_ui("table")
          ),
          tabItem(
            tabName = "plot_tab",
            plot_ui("plot")
          )
        )
      )
    )
  )
)


## server ----------------
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
