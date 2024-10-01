tabBox(
  title = HTML("<h5 style='color: #cfabed;'>Design and Analysis Transparency</h5>"),
  
  id = "S5_box", width = 12,
  tabPanel(
    "", value = "tab5a",
    
    uiOutput("insertQ5"),
    
    div(style = "display:table-row; float:left",
        actionBttn("previousS3",
                   icon = shiny::icon("backward"),
                   label = "Back", color = "primary",  style = "jelly", size = "sm"),
    ),
    div(style = "display:table-row; float:right", 
        actionBttn("next6", 
                   icon = shiny::icon("forward"), 
                   label = "Next", color = "primary",  style = "jelly", size = "sm")
    ),
    br()
  )
)
