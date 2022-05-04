
# plot module -------------------------------------------------------------

plot_ui <- function(id) {
  fluidRow(
    column(12, echarts4rOutput(NS(id, "plot")))
  )
}


plot_server <- function(id, df, vbl, threshold = NULL, theme) {
  moduleServer(id, function(input, output, session) {
    plot <- reactive({
      viz_monthly(df(), vbl, threshold, theme())
    })
    output$plot <- renderEcharts4r({
      plot()
    })
  })
}


plot_demo <- function() {
  df <- data.frame(day = 1:30, arr_delay = 1:30)
  ui <- fluidPage(plot_ui("x"))
  server <- function(input, output, session) {
    plot_server("x", reactive({
      df
    }), "arr_delay", 10, reactive("infographic"))
  }
  shinyApp(ui, server)
}
