library(shiny)
library(ggplot2)
library(dplyr)


# module plot -------------------------------------------------------------

plot_ui <- function(id) {
  ns <- NS(id)

  tagList(
    selectInput(
      inputId = ns("selected_col"),
      label = "Selected column",
      choices = colnames(mtcars)
    ),
    plotOutput(
      outputId = ns("plot")
    )
  )
}


plot_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      output$plot <- renderPlot({
        mtcars %>%
          ggplot(aes(
            x = .data[[input$selected_col]],
            y = mpg
          )) +
          geom_point()
      })
    }
  )
}


ui <- fluidPage(
  plot_ui(id = "plot_1")
)


server <- function(input, output, session) {
  plot_server(id = "plot_1")
}

shinyApp(ui, server)
