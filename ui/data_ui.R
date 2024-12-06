tabBox(
  title = HTML("<h5 style='color: #cfabed;'>Data Transparency</h5>"),
  
  id = "S2_box", width = 12,
  tabPanel(
    "", value = "id", width = 12,
    fluidPage(
      textInput("ms_id", h5("1. Manuscript Number"), placeholder = "e.g.: CORTEX-D-12-34567R1"),
      h6(HTML("If your manuscript has not yet been assigned a number, please provide a name in the format <b>CORTEX-LASTNAME</b> (e.g., CORTEX-SMITH).")),
      
      br(),
      textInput("ms_title", h5("Manuscript Title"), placeholder = "e.g.: Transparency and Openness Promotion Guidelines"),
      
      br(),
      textInput("ms_author", h5("Corresponding Author"), placeholder = "e.g.: Jane Smith"),
      
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
