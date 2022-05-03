# library(shiny)
# library(dplyr)
# library(shinycssloaders)

# preparing ---------------------------------------------------------------

data("diamonds", package = "ggplot2")
data("mtcars")
data("CO2")

mtcars <- mtcars %>%
  as_tibble() %>%
  mutate(across(c(cyl, vs, am, gear, carb), .fns = forcats::as_factor))

table_summary <- function(df, col) {
  df %>%
    group_by(.data[[col]]) %>%
    summarise(
      round(across(
        .cols = where(is.numeric), .fns = list(avg = mean),
        .names = "{.col}_{.fn}"
      ), 2)
    )
}


# table module ui ----------------------------------------------------------

table_ui <- function(id) {
  ns <- NS(id)

  fluidRow(
    column(uiOutput(ns("selected_column")), width = 12),
    column(reactableOutput(
      outputId = ns("table")
    ) %>% withSpinner(type = 5, size = 0.5), width = 12)
  )
}


# table module server ------------------------------------------------------

table_server <- function(id, data, show_sum) {
  
  moduleServer(
    id,
    function(input, output, session) {
      output$selected_column <- renderUI({
        req(show_sum())
        cols <- data() %>%
          select(where(is.factor)) %>%
          colnames()
        selectInput(
          inputId = session$ns("summary_column"),
          label = "summary based on (categorical):",
          choices = cols,
          selected = cols[1]
        )
      })

      summary_data <- reactive({
        req(input$summary_column %in% colnames(data()))
        table_summary(data(), input$summary_column)
      })

      output$table <- renderReactable({
        if (show_sum()) {
          reactable(summary_data(), highlight = TRUE, outlined = TRUE, 
                    bordered = TRUE, striped = TRUE)
        } else {
          reactable(data(), highlight = TRUE, outlined = TRUE, 
                    bordered = TRUE, striped = TRUE,
                    filterable = TRUE, minRows = 10)
        }
      })
    }
  )
}


# testing the module ------------------------------------------------------

table_demo <- function() {
  ui <- fluidPage(table_ui("x"))
  server <- function(input, output, session) {
    table_server("x", reactive({
      mtcars
    }), reactive({
      TRUE
    }))
  }

  shinyApp(ui, server)
}
