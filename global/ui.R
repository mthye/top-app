# Theme for app  ----------------------------------------------------------

mytheme <- fresh::create_theme(
  bs4dash_vars(
    navbar_light_color = "#bec5cb",
    navbar_light_active_color = "#FFF",
    navbar_light_hover_color = "#FFF"
  ),
  bs4dash_yiq(
    contrasted_threshold = 10, 
    text_light = "#272c30"
  ),
  bs4dash_layout(main_bg = "#353c42"),
  bs4dash_sidebar_light(
    bg = "#272c30", 
    color =  "#873cc7",
    hover_color = "#fe9923", 
    submenu_bg = "#272c30", 
    submenu_color = "#FFF", 
    submenu_hover_color = "#FFF",
    submenu_active_bg = "#fe9923",
    submenu_active_color = "#FFF"
  ),
  # bs4dash_status(
  #   primary = "#873cc7", danger = "#423CC7", light = "#57ac0c", success = "#a3369e"), 
  #   bs4dash_color(gray_900 = "#FFF", white = "#272c30")
  bs4dash_status(
    primary = "#2a92a9", danger = "#fe9923", light = "#57ac0c", success = "#873cc7"), 
  bs4dash_color(gray_900 = "#FFF", white = "#272c30")
  
)

pickerStyle <- paste0("color:white;
                font-weight: bold;
                background: pink;")

# Custom CSS for app ------------------------------------------------------

custom_css <- "

.dropdown-menu {
  background-color: ghostwhite !important;
  color: black !important;
}

.btn-light {
  background-color: ghostwhite !important;
  color: black !important;
}

.btn-light.dropdown-toggle {
  background-color: ghostwhite;
  color: black !important;
}

.dropdown-toggle .filter-option-inner-inner {
    background-color: ghostwhite;
    color:#302d33;
}

.filter-option {
  color: green !important;
  background-color: white;
  fill: pink;
}

.form-control {
  background-color: ghostwhite !important;
}

.handsontable td, .handsontable th {
  color: black;
  background-color: ghostwhite;
}

.handsontable .colHeader {
    font-weight: bold;
}

.handsontable td {
  color: black;
}

.handsontable .htDimmed, .current, .highlight {
    color: purple;
    background-color: white;
    font-weight: normal;
}

.handsontable.listbox .ht_master table {
  border: 1px solid ghostwhite;
  border-collapse: separate;
  background: ghostwhite;
  color: black;
}

.handsontable.listbox td {
  background: ghostwhite;
  color: black;
}

.handsontable.listbox td, .handsontable.listbox th {
  background: ghostwhite;
  color: black;
}
a.action-button {
                    color: #a3369e;
                    text-decoration-line: underline; 
}

.sF-dirWindow {
  display: flex;
}

.sF-breadcrumps {
  width: calc(100% - 380px) !important;

.h4 {
  font-size: 20px !important;
}

.card-title {
  font-size: 20px !important;
  font-weight: bold;
}
}
"

# Main UI function (Dashboard & Menu) --------------------------------------------------------

ui <- function(request) { 
  dashboardPage(
    #dark = NULL,
    header = dashboardHeader(),
    sidebar = bs4DashSidebar(
      collapsed = TRUE,
      sidebarMenu(
        id = "sidebar",
        menuItem(text = "Home", tabName = "home", icon = shiny::icon("home", style="color: #fff"), badgeColor = "primary"),
        menuItem(
          text = "Transparency Criteria", tabName = "standards", startExpanded = TRUE,
          icon = shiny::icon("table", style="color: #fff"),
          menuSubItem("Data", tabName = "data"),
          menuSubItem("Analytic Methods", tabName = "code"),
          menuSubItem("Research Materials", tabName = "materials"),
          menuSubItem("Design and Analysis", tabName = "design"),
          menuSubItem("Preregistration", tabName = "prereg")
        ),
        menuItem(text = "Generate Report", tabName = "results", icon = shiny::icon("list-ol", style="color: #fff")),
        menuItem(text = "FAQ & Tips", tabName = "resources", icon = shiny::icon("info-circle", style="color: #fff"))
      )
    ),
    body = dashboardBody(
      use_theme(mytheme), # <-- use the theme
      tags$head(tags$style(HTML(custom_css))),
      downloadButton("downloadData", "Save Progress...", icon = icon("download"), style="margin-bottom:25px;"), 
      #bookmarkButton(label = "Save Progress...", icon = shiny::icon("link", lib = "glyphicon")),
      #actionButton("downloadData", 'Save Progress...', icon = icon("download")),
      
      tabItems(
        tabItem(
          tabName = "home",
          fluidRow(
            source(file.path("ui", "home_ui.R"), local = TRUE)$value,
          )
        ),
        tabItem(
          tabName = "data",
          fluidRow(
            source(file.path("ui", "data_ui.R"), local = TRUE)$value,
          )
        ),
        tabItem(
          tabName = "code",
          fluidRow(
            source(file.path("ui", "code_ui.R"), local = TRUE)$value,
          )
        ),
        tabItem(
          tabName = "materials",
          fluidRow(
            source(file.path("ui", "materials_ui.R"), local = TRUE)$value,
          )
        ),
        tabItem(
          tabName = "design",
          fluidRow(
            source(file.path("ui", "design_ui.R"), local = TRUE)$value,
          )
        ),
        tabItem(
          tabName = "prereg",
          fluidRow(
            source(file.path("ui", "prereg_ui.R"), local = TRUE)$value,
          )
        ),
        tabItem(
          tabName = "results",
          fluidPage(
            shinyjs::useShinyjs(),
            uiOutput("generateTOP"),
            uiOutput("downloadTOP")
          )
        ),
        tabItem(
          tabName = "resources",
          fluidRow(
            source(file.path("ui", "faq_ui.R"), local = TRUE)$value,
          )
        )
      )
    )
  )
}
