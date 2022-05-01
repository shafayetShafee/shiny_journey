
dashboardPage(
  skin = "red",
  dashboardHeader(
    title = "Exploring the 1973 US Arrests data.",
    titleWidth = 300, # width in CSS unit
    tags$li(class = "dropdown", tags$a(
      href = "https://github.com/shafayetShafee",
      icon("github"), "", target = "_blank"
    ))
  ),
  dashboardSidebar(
    sidebarMenu(
      id = "sidebar",
      menuItem(text = "Dataset", tabName = "data", icon = icon("database")),
      menuItem(text = "Visualization", tabName = "viz", icon = icon("chart-line")),
      conditionalPanel(
        "input.sidebar == 'viz' && input.t2 == 'distro'",
        selectInput(
          inputId = "var1", label = "Select the variable", choices = c1,
          selected = "Rape"
        )
      ),
      conditionalPanel(
        "input.sidebar == 'viz' && input.t2 == 'trends'",
        selectInput(
          inputId = "var2", label = "Select the variable", choices = c2,
          selected = "Rape"
        )
      ),
      conditionalPanel(
        "input.sidebar == 'viz' && input.t2 == 'relation'",
        selectInput(
          inputId = "sctr_x", label = "Select the X variable", choices = c1,
          selected = "Rape"
        )
      ),
      conditionalPanel(
        "input.sidebar == 'viz' && input.t2 == 'relation'",
        selectInput(
          inputId = "sctr_y", label = "Select the Y variable", choices = c1,
          selected = "Assault"
        )
      ),
      menuItem(text = "Choropleth Map", tabName = "map", icon = icon("map")),
      conditionalPanel(
        "input.sidebar == 'map'",
        selectInput(
          inputId = "map_var", label = "Select the variable",
          choices = c2, selected = "Rape"
        )
      ),
      conditionalPanel(
        "input.sidebar != 'data'",
        selectInput(
          inputId = "theme", label = "Select the Echarts plot theme",
          choices = echart_theme, selected = "infographic"
        )
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "data",
        tabBox(
          id = "t1", width = 12,
          tabPanel(
            title = "About", icon = icon("address-card"),
            fluidRow(
              column(
                width = 8,
                tags$img(
                  src = "crime.jpg", width = "100%", height = "100%",
                  alt = "A crime scene with some police vehicles"
                ),
                tags$br(),
                tags$a("Photo by Campbell Jensen on Unsplash"), align = "center"
              ),
              column(
                width = 4, tags$br(),
                tags$h4("This data set contains statistics, in arrests per 100,000
                                         residents for assault, murder, and rape in each of the 50 US
                                         states in 1973. Also given is the percent of the population
                                         living in urban areas."),
              )
            )
          ),
          tabPanel(
            title = "Data", icon = icon("table"),
            dataTableOutput("data_table")
          ),
          tabPanel(
            title = "Structure", icon = icon("uncharted"),
            verbatimTextOutput("structure")
          ),
          tabPanel(
            title = "Summary Stats", icon = icon("chart-pie"),
            verbatimTextOutput("summary")
          ),
        )
      ),
      tabItem(
        tabName = "viz",
        tabBox(
          id = "t2", width = 12,
          tabPanel(
            title = "Crime Trends by State", value = "trends",
            fluidRow(
              tags$div(
                align = "center",
                box(tableOutput("top5"),
                  title = textOutput("head1"),
                  collapsible = TRUE, collapsed = TRUE, solidHeader = TRUE,
                  status = "primary"
                )
              ),
              tags$div(
                align = "center",
                box(tableOutput("low5"),
                  title = textOutput("head2"),
                  collapsible = TRUE, collapsed = TRUE, solidHeader = TRUE,
                  status = "primary"
                )
              )
            ),
            echarts4rOutput("bar") %>%
              withSpinner(type = 7, color = "#c23531", size = 0.5)
          ),
          tabPanel(
            title = "Distribution", value = "distro",
            fluidRow(
              column(
                width = 12,
                uiOutput("dist_title")
              ),
              column(
                width = 8,
                echarts4rOutput("hist") %>%
                  withSpinner(type = 7, color = "#c23531", size = 0.5)
              ),
              column(
                width = 4,
                echarts4rOutput("boxp") %>%
                  withSpinner(type = 7, color = "#c23531", size = 0.5)
              )
            )
          ),
          tabPanel(
            title = "Correlation Matrix",
            echarts4rOutput("corrplot")
          ),
          tabPanel(
            title = "Bivariate Relationship",
            value = "relation",
            echarts4rOutput("scatter") %>%
              withSpinner(type = 7, color = "#c23531", size = 0.5)
          )
        )
      ),
      tabItem(
        tabName = "map",
        box(echarts4rOutput("choropleth") %>%
          withSpinner(type = 7, color = "#c23531", size = 0.5), width = 12)
      )
    )
  )
)
