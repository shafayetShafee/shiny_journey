dashboardPage(
  title = "shiny modules", skin = "black",
  dashboardHeader(
    title = "Exploring Shiny modules with NYC flights Delay",
    titleWidth = 450, # width in CSS unit
    tags$li(class = "dropdown", tags$a(
    href = "https://github.com/shafayetShafee/shiny_journey/tree/main/shiny_modules_nycflights",
      icon("github"), "", target = "_blank"
    ))
  ),
  dashboardSidebar(
    selectInput("month", "Month",
      choices = setNames(1:12, month.abb),
      selected = 1
    ),
    selectInput(
      inputId = "ec_theme", label = "Select the Echarts plot theme",
      choices = echart_theme, selected = "infographic"
    )
  ),
  dashboardBody(
    fluidRow(
      tags$div(align = "center", box(h2(textOutput("title")), width = 12))
    ),
    fluidRow(
      tabBox(
        width = 12,
        tabPanel(
          title = "Average Departure Delay",
          fluidRow(
            column(metric_ui("dep_delay"), width = 11)
          )
        ),
        tabPanel(
          title = "Average Arrival Delay",
          fluidRow(
            column(metric_ui("arr_delay"), width = 11)
          )
        ),
        tabPanel(
          title = "Proportion Flights with >5 Min Arrival Delay",
          fluidRow(
            column(metric_ui("ind_arr_delay"), width = 11)
          )
        )
      )
    )
  )
)
