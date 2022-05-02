# text module -------------------------------------------------------------

text_ui <- function(id) {
  fluidRow(
      column(textOutput(NS(id, "text")), width = 12)
   )
}


text_server <- function(id, df, vbl, threshold) {
  moduleServer(id, function(input, output, session) {
    n <- reactive({
      sum(df()[[vbl]] > threshold)
    })
    output$text <- renderText({
      paste(
        "In this month", axis_names[[vbl]], "exceeded the average daily threshold of",
        threshold, "in a total of", n(), "days"
      )
    })
  })
}


text_demo <- function() {
  
  df <- data.frame(day = 1:30, arr_delay = 1:30)
  ui <- fluidPage(text_ui("x"))
  server <- function(input, output, session) {
    text_server("x", reactive({df}), "arr_delay", 15)
  }
  shinyApp(ui, server)
}
