library(shiny)
library(DT)
library(dplyr)
library(shinydashboard)


source("mod_table.R")
source("mod_about.R")

data("diamonds", package = "ggplot2")
data("mtcars")
data("CO2")

mtcars <- mtcars %>% 
  as_tibble() %>% 
  mutate(across(c(cyl, vs, am, gear, carb), .fns = forcats::as_factor))


# main app ---------------------------------------------------------------

ui <- dashboardPage(
  dashboardHeader(title = "Exercise with Shiny modules - 01", titleWidth = 350),
  dashboardSidebar(
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
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet",
                type = "text/css",
                href = "style.css")
    ),
    fluidRow(
      tabBox(id = "data_tab", width = 12,
        tabPanel(
          title = "About the Dataset",
          about_ui("about")
        ),
        tabPanel(
          title = "Data-set",
          table_ui("table"),
          value = "summary_table"
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

  table_server(id = "table", datasetInput, reactive({input$summary}))
  about_server(id = "about", reactive({input$dataset}))
}

shinyApp(ui, server)
