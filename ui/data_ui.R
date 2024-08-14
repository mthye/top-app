tabBox(
  title = HTML("<h5 style='color: #cfabed;'>Data Transparency</h5>"),
  
  id = "S2_box", width = 12,
  tabPanel(
    "", value = "id", width = 12,
    fluidPage(
      textInput("ms_id", h5("1. Manuscript Number"), placeholder = "e.g.: CORTEX-D-12-34567R1"),
      
      div(style = "display:table-row; float:right",
          actionBttn("next2",
                     icon = shiny::icon("forward"),
                     label = "Next", color = "primary",  style = "jelly", size = "sm"),
      ),
      br()
    )
  ),
  
  tabPanel(
    "", value = "tab2a", width = 12,
    
    uiOutput("insertQ2"),
    
    div(style = "display:table-row; float:right",
        actionBttn("next2a",
                   icon = shiny::icon("forward"),
                   label = "Next", color = "primary",  style = "jelly", size = "sm")
    ),
    div(style = "display:table-row; float:left", 
        actionBttn("backid", 
                   icon = shiny::icon("backward"), 
                   label = "Back", color = "primary",  style = "jelly", size = "sm")
    ),
    br(),
    br(),
    br()
  ),
  
  tabPanel(
    "", value = "tab2b", width = 12,
    
    uiOutput("insertQ2b"),
    div(style = "display:table-row; float:right", 
        actionBttn("next2b", 
                   icon = shiny::icon("forward"), 
                   label = "Next", color = "primary",  style = "jelly", size = "sm")
    ),
    div(style = "display:table-row; float:left", 
        actionBttn("back2b", 
                   icon = shiny::icon("backward"), 
                   label = "Back", color = "primary",  style = "jelly", size = "sm")
    ),
    br()
  ),
  tabPanel(
    "", value = "tab2c",
    
    uiOutput("insertQ2c"),     
    div(style = "display:table-row; float:right", 
        actionBttn("next2c", 
                   icon = shiny::icon("forward"), 
                   label = "Next", color = "primary",  style = "jelly", size = "sm")
    ),
    div(style = "display:table-row; float:left", 
        actionBttn("back2c", 
                   icon = shiny::icon("backward"), 
                   label = "Back", color = "primary",  style = "jelly", size = "sm")
    ),
    br()
  )
)
