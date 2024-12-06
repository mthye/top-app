tabBox(
  title = HTML("<h5 style='color: #cfabed;'>Study Preregistration</h5>"),
  
  id = "S6_box", width = 12,
  tabPanel(
    "", value = "tab6",
    uiOutput("insertQ6"),
    
    div(style = "display:table-row; float:left",
        actionBttn("previousS4",
                   icon = shiny::icon("backward"),
                   label = "Back", color = "primary",  style = "jelly", size = "sm"),
    ),
  )
)
