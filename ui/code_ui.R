tabBox(
  title = HTML("<h5 style='color: #cfabed;'>Analytic Methods (Code) Transparency</h5>"),
  id = "S3_box", width = 12,
  tabPanel(
    "", value = "tab3a",

    uiOutput("insertQ3"),

    div(style = "display:table-row; float:left",
        actionBttn("previousS1",
                   icon = shiny::icon("backward"),
                   label = "Back", color = "primary",  style = "jelly", size = "sm"),
    ),
    
    div(style = "display:table-row; float:right",
        actionBttn("next3a",
                   icon = shiny::icon("forward"),
                   label = "Next", color = "primary",  style = "jelly", size = "sm")
    ),
    br()
  ),
  tabPanel(
    "", value = "tab3b",
    uiOutput("insertQ3b"),
    div(style = "display:table-row; float:left",
        actionBttn("previous3b",
                   icon = shiny::icon("backward"),
                   label = "Back", color = "primary",  style = "jelly", size = "sm"),
    ),
    div(style = "display:table-row; float:right",
        actionBttn("next3b",
                   icon = shiny::icon("forward"),
                   label = "Next", color = "primary",  style = "jelly", size = "sm")
    ),
    br()
  ),
  tabPanel(
    "", value = "tab3c",
    uiOutput("insertQ3c"),
    div(style = "display:table-row; float:left",
        actionBttn("previous3c",
                   icon = shiny::icon("backward"),
                   label = "Back", color = "primary",  style = "jelly", size = "sm"),
    ),
    div(style = "display:table-row; float:right",
        actionBttn("next3c",
                   icon = shiny::icon("forward"),
                   label = "Next", color = "primary",  style = "jelly", size = "sm")
    ),
    br()
  )
)