# module ui ---------------------------------------------------------------

about_ui <- function(id) {
  ns <- NS(id)

  fluidRow(
    column(
      uiOutput(ns("data_markdown")),
      width = 12
    )
  )
}


# module server -----------------------------------------------------------


about_server <- function(id, data_name) {
  moduleServer(
    id,
    function(input, output, session) {
      output$data_markdown <- renderUI({
        switch(data_name(),
          "mtcars" = includeMarkdown("mtcars.md"),
          "diamonds" = includeMarkdown("diamonds.md"),
          "CO2" = includeMarkdown("co2.md")
        )
      })
    }
  )
}


# module testing ----------------------------------------------------------

about_demo <- function(data_name) {
  ui <- fluidPage(about_ui("x"))
  server <- function(input, output, session) {
    about_server("x", reactive({
      data_name
    }))
  }

  shinyApp(ui, server)
}
