tabBox(
  title = HTML("<h5 style='color: #cfabed;'>Study Preregistration</h5>"),
  
  id = "S6_box", width = 12,
  tabPanel(
    "", value = "tab6",
    uiOutput("insertQ6"),
    # fluidPage(
    #   h5("6. Was any part of the study procedures pre-registered in a time-stamped, 
    #         institutional registry PRIOR to the research being conducted? "),
    #   h6("Study procedures include any components of the research undertaken prior 
    #         to data analysis, such as specification of hypotheses, sampling plans, recruitment 
    #         processes, definition of study variables and data acquisition methods. Please note 
    #         that an approved ethics application generally does not count as a pre-registered study 
    #         procedure unless the application is time-stamped and publicly available."),
    #   pickerInput(
    #     inputId = "Q6",
    #     label = "",
    #     choices = c("Yes", "No"),
    #     multiple = FALSE, 
    #     options = list(title = "Response required")
    #   )),
    #uiOutput("insertQ6b"),
    #uiOutput("insertQ6c"),
    # uiOutput("insertQ7"),
    # uiOutput("insertQ7a"),
    # uiOutput("insertQ7b"),
    # uiOutput("insertQ7c")
    )
)
