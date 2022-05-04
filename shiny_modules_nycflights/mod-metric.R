
# metric module -----------------------------------------------------------

metric_ui <- function(id) {
  fluidRow(
    column(h4(text_ui(NS(id, "metric"))), width = 12, offset = 1),
    column(plot_ui(NS(id, "metric")), width = 12)
  )
}

metric_server <- function(id, df, vbl, threshold, theme) {
  moduleServer(id, function(input, output, session) {
    text_server("metric", df, vbl, threshold)
    plot_server("metric", df, vbl, threshold, theme)
  })
}


metric_demo <- function() {
  df <- data.frame(day = 1:30, arr_delay = 1:30)
  ui <- fluidPage(metric_ui("x"))
  server <- function(input, output, session) {
    metric_server("x", reactive({
      df
    }), "arr_delay", 15, theme = "infographic")
  }
  shinyApp(ui, server)
}
