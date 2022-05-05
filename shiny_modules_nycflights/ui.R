dashboardPage(
  title = "shiny app",
  preloader = list(html = tagList(
    waiter::spin_1(),
    "Loading ..."
  ), color = "#343a40"),
  dark = NULL,
  fullscreen = TRUE,
  ## Header --------------------
  dashboardHeader(
    title = dashboardBrand(
      title = "NYC Flight Delays",
      color = "success",
      href = "https://github.com/shafayetShafee",
      image = "https://github.com/shafayetShafee.png"
    ),
    skin = "light",
    status = "success",
    border = TRUE,
    sidebarIcon = icon("bars"),
    controlbarIcon = icon("th"),
    fixed = FALSE
  ),
  ## Sidebar --------------------
  dashboardSidebar(
    skin = "light",
    status = "success",
    elevation = 4,
    sidebarMenu(
      id = "sidebar",
      menuItem(
        "Arrival Delays",
        icon = icon("plane-arrival"),
        tabName = "arrival"
      ),
      menuItem(
        "Proportion of Delays",
        tabName = "prop_delay",
        icon = icon("plane")
      ),
      menuItem(
        "Departure Delays",
        icon = icon("plane-departure"),
        tabName = "departure"
      )
    )
  ),
  ### Control-bar ----------------------
  controlbar = dashboardControlbar(
    skin = "light",
    pinned = TRUE,
    collapsed = FALSE,
    overlay = FALSE,
    controlbarMenu(
      id = "controlbarmenu",
      selected = "Controls",
      type = "pills",
      controlbarItem(
        title = "Controls",
        selectInput("month",
          label = "Select Month",
          choices = setNames(1:12, month.name),
          selected = 1
        ),
        selectInput(
          inputId = "ec_theme", label = "Select plot theme",
          choices = echart_theme, selected = "infographic"
        )
      )
    )
  ),
  ### Footer --------------------
  footer = dashboardFooter(
    left = a(
      href = "https://twitter.com/shafayet_shafee",
      target = "_blank", "@shafayetShafee"
    ),
    right = "2022"
  ),
  ## Body --------------------
  dashboardBody(
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "style2.css"
      )
    ),
    fluidRow(
      column(
        width = 12,
        tags$div(
          align = "center", h1(textOutput("title")),
          style = "padding: 10px"
        )
      ),
      tabItems(
        tabItem(
          tabName = "arrival",
          fluidRow(
            column(metric_ui("arr_delay"), width = 11)
          )
        ),
        tabItem(
          tabName = "departure",
          fluidRow(
            column(metric_ui("dep_delay"), width = 11)
          )
        ),
        tabItem(
          tabName = "prop_delay",
          fluidRow(
            column(metric_ui("ind_arr_delay"), width = 11)
          )
        )
      )
    )
  )
)
