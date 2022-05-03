library(echarts4r)

# data("diamonds", package = "ggplot2")
# data("mtcars")
# data("CO2")
#
# mtcars <- mtcars %>%
#   as_tibble() %>%
#   mutate(across(c(cyl, vs, am, gear, carb), .fns = forcats::as_factor))


# module ui ----------------------------------------------------------------

plot_ui <- function(id) {
  ns <- NS(id)

  fluidRow(
    column(
      uiOutput(ns("selected_column")),
      width = 12
    ),
    column(
      echarts4rOutput(ns("hist")) %>% withSpinner(type = 5, size = 0.5),
      width = 6
    ),
    column(
      echarts4rOutput(ns("box")) %>% withSpinner(type = 5, size = 0.5),
      width = 6
    )
  )
}

# module server -----------------------------------------------------------

plot_server <- function(id, data, theme) {
  moduleServer(
    id,
    function(input, output, session) {
      output$selected_column <- renderUI({
        cols <- data() %>%
          select(where(is.numeric)) %>%
          colnames()

        selectInput(
          inputId = session$ns("plot_column"),
          label = "Select a variable",
          choices = cols,
          selected = cols[1]
        )
      })

      echart_plot <- reactive({
        req(input$plot_column %in% colnames(data()))
        data() %>%
          e_charts_() %>%
          e_theme(theme()) %>%
          e_tooltip() %>%
          e_y_axis(
            nameLocation = "center",
            nameTextStyle = list(
              padding = c(10, 4, 20, 4),
              fontSize = 16
            )
          )
      })

      output$hist <- renderEcharts4r({
        echart_plot() %>%
          e_histogram_(input$plot_column,
            barGap = "10%",
            name = "histogram"
          )
      })

      output$box <- renderEcharts4r({
        echart_plot() %>%
          e_boxplot_(input$plot_column,
            name = "boxplot"
          )
      })
    }
  )
}


# testing module ----------------------------------------------------------

plot_demo <- function(data) {
  ui <- fluidPage(plot_ui("x"))
  server <- function(input, output, session) {
    plot_server("x", reactive({
      data
    }), reactive({
      "infographic"
    }))
  }

  shinyApp(ui, server)
}
