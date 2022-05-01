function(input, output, session) {

  # structure of data
  output$structure <- renderPrint({
    df %>% str()
  })

  # summary
  output$summary <- renderPrint({
    df %>% summary()
  })

  # Data table
  output$data_table <- renderDataTable(df)

  output$head1 <- renderText(
    paste0("5 States with high rate of ", input$var2, " Arrests")
  )

  output$head2 <- renderText(
    paste0("5 States with low rate of ", input$var2, " Arrests")
  )

  output$top5 <- renderTable({
    df %>%
      select(states, .data[[input$var2]]) %>%
      slice_max(.data[[input$var2]], n = 5)
  })

  output$low5 <- renderTable({
    df %>%
      select(states, .data[[input$var2]]) %>%
      slice_min(.data[[input$var2]], n = 5)
  })

  # distribution plot
  output$hist <- renderEcharts4r({
    df %>%
      e_charts_(dispose = TRUE) %>%
      e_histogram_(input$var1, name = "histogram") %>%
      e_tooltip(trigger = "axis") %>%
      e_axis_labels(x = input$var1) %>%
      e_x_axis(
        nameLocation = "center",
        nameTextStyle = list(padding = c(20, 4, 10, 4))
      ) %>%
      e_theme(input$theme)
  })

  output$boxp <- renderEcharts4r({
    df %>%
      e_charts_(dispose = TRUE) %>%
      e_boxplot_(input$var1, name = "boxplot") %>%
      e_tooltip() %>%
      e_theme(input$theme)
  })

  output$dist_title <- renderUI(
    h1(paste0("Distribution by ", input$var1))
  )

  output$scatter <- renderEcharts4r({
    df %>%
      e_charts_(input$sctr_x, dispose = TRUE) %>%
      e_scatter_(input$sctr_y) %>%
      e_lm(as.formula(paste0(input$sctr_y, " ~ ", input$sctr_x)), name = "lm fit") %>%
      e_loess(as.formula(paste0(input$sctr_y, " ~ ", input$sctr_x)), name = "loess") %>%
      e_axis_labels(x = input$sctr_x, y = input$sctr_y) %>%
      e_x_axis(
        nameLocation = "center",
        nameTextStyle = list(padding = c(10, 4, 10, 4))
      ) %>%
      e_y_axis(
        nameLocation = "center",
        nameTextStyle = list(padding = c(3, 4, 20, 4))
      ) %>%
      e_title(text = paste("Relation Between", input$sctr_x, "and", input$sctr_y)) %>%
      e_theme(input$theme) %>%
      e_legend(bottom = 0) %>%
      e_tooltip(
        axisPointer = list(
          type = "cross"
        )
      )
  })

  output$corrplot <- renderEcharts4r({
    corr_df %>%
      e_charts(x) %>%
      e_heatmap(y, corr,
        bind = p_val,
        itemStyle = list(emphasis = list(shadowBlur = 10))
      ) %>%
      e_theme("infographic") %>%
      e_visual_map(corr,
        min = -1,
        max = 1
      ) %>%
      e_tooltip(formatter = htmlwidgets::JS("
      function(params){
        return('Corr: ' + params.value[2] + '<br />p-value: ' + params.name)
      }
    ")) %>%
      e_theme(input$theme)
  })

  output$bar <- renderEcharts4r({
    df %>%
      arrange(.data[[input$var2]]) %>%
      e_chart(states) %>%
      e_bar_(input$var2) %>%
      e_x_axis(
        axisLabel = list(
          interval = 0L,
          rotate = 90
        ),
        inverse = F
      ) %>%
      e_y_axis(
        nameLocation = "center",
        nameTextStyle = list(padding = c(3, 4, 20, 4))
      ) %>%
      e_title(paste0("Statewise Arrests for ", input$var2)) %>%
      e_axis_labels(y = paste0(input$var2, " Arrests per 100,000 residents")) %>%
      e_tooltip() %>%
      e_legend(right = 0) %>%
      e_theme(input$theme)
  })


  output$choropleth <- renderEcharts4r({
    df %>%
      e_charts(states) %>%
      em_map("USA") %>%
      e_map_(input$map_var, map = "USA") %>%
      e_visual_map_(input$map_var,
        type = "continuous", calculable = TRUE, orient = "horizontal",
        left = 5, bottom = 20, precision = 2, itemHeight = 240
      ) %>%
      e_tooltip(formatter = htmlwidgets::JS("
      function(params){
        return(params.seriesName + ' arrests: ' + params.value)
      }
    ")) %>%
      e_theme(input$theme) %>%
      e_title(paste0("Visual Map of State-wise ", input$map_var, " arrests per 100,000"))
  })
}
