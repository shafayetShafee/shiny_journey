function(input, output, session) {
  output$title <- renderText({
    paste(month.name[as.integer(input$month)], "Report")
  })

  df_month <- reactive({
    ua_data %>%
      filter(month == input$month)
  })

  metric_server("dep_delay", df_month,
    vbl = "dep_delay", threshold = 10,
    reactive({
      input$ec_theme
    })
  )
  metric_server("arr_delay", df_month,
    vbl = "arr_delay", threshold = 10,
    reactive({
      input$ec_theme
    })
  )
  metric_server("ind_arr_delay", df_month,
    vbl = "ind_arr_delay",
    threshold = 0.5, reactive({
      input$ec_theme
    })
  )
}
