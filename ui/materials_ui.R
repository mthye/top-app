tabBox(
  title = HTML("<h5 style='color: #cfabed;'>Research Materials Transparency</h5>"),
  id = "S4_box", width = 12,
  tabPanel(
    "", value = "tab4a", width = 12,
    
    uiOutput("insertQ4"),
    
    div(style = "display:table-row; float:left",
        actionBttn("previousS2",
                   icon = shiny::icon("backward"),
                   label = "Back", color = "primary",  style = "jelly", size = "sm"),
    ),
    div(style = "display:table-row; float:right",
        actionBttn("next4a",
                   icon = shiny::icon("forward"),
                   label = "Next", color = "primary",  style = "jelly", size = "sm")
    ),
    br()
  ),
  tabPanel(
    "", value = "tab4b", width = 12,
    uiOutput("insertQ4b"),
    div(style = "display:table-row; float:left",
        actionBttn("previous4b",
                   icon = shiny::icon("backward"),
                   label = "Back", color = "primary",  style = "jelly", size = "sm"),
    ),
    div(style = "display:table-row; float:right",
        actionBttn("next4b",
                   icon = shiny::icon("forward"),
                   label = "Next", color = "primary",  style = "jelly", size = "sm")
    ),
    br()
  ),
  tabPanel(
    "", value = "tab4c",
    uiOutput("insertQ4c"),
    div(style = "display:table-row; float:left",
        actionBttn("previous4c",
                   icon = shiny::icon("backward"),
                   label = "Back", color = "primary",  style = "jelly", size = "sm"),
    ),
    div(style = "display:table-row; float:right",
        actionBttn("next4c",
                   icon = shiny::icon("forward"),
                   label = "Next", color = "primary",  style = "jelly", size = "sm")
    ),
    br()
  )
)
