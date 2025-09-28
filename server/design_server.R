observeEvent(input$previousS3, {
  updateTabsetPanel(session, "sidebar", selected = "materials")
})

output$insertQ5 <- renderUI({
  fluidPage(
    h5("5. If the manuscript reports any form of data presentation or analysis, either descriptive or inferential, please confirm that the following details are included in the manuscript:"),
    br(),
    h5("(1) You report how you determined your SAMPLE SIZE"),
    h6("This explanation could consist of a formal sampling plan (e.g. statistical power analysis) or an informal reason of any kind, including (but not limited to) a rule-of-thumb to achieve parity with previous studies, a determination based on the size of a pre-existing dataset, or a determination based on the maximum possible sample size given finite resources (e.g. patient availability, limited recruitment time, etc)."),
    br(),
    h5("(2) You report all DATA EXCLUSIONS (if any) and the INCLUSION and EXCLUSION CRITERIA applied to data acquisition and analysis"),
    h6("This is relevant for for any studies that involved the recruitment of a patient (or patients), participants, animals, biological samples, generation of simulated data, computational modelling, or the reanalysis of existing data (including meta-analysis, systematic reviews, or systematic maps)."),
    br(),
    h5("(3) You report whether the inclusion and exclusion criteria were established PRIOR to data analysis"),
    pickerInput(
      inputId = "Q5",
      label = "",
      choices = c("Yes", "No", "Not Applicable"),
      multiple = FALSE,
      selected = isolate(desValues$Q5),
      options = list(title = "Response required"),
    ),
    
    # optional followup question to clarify why study is exempt from reporting design details
    uiOutput("insertQ5_followup")
    
  )
})

# add question to capture reason why study is exempt from reporting design details
output$insertQ5_followup <- renderUI({
  if (input$Q5 == "No" | input$Q5 == "Not Applicable") {
    desValues$Yes = 0
    desValues$Q5_complete = 0
    
    # allow NA reponses to be flagged as compliant
    if (input$Q5 == "Not Applicable") {
      fullReport$editor$Note[5] <- NA
    } else if (input$Q5 == "No") {
      fullReport$editor$Note[5] <- "Yes"
    }
    
    fluidPage(
      br(),
      h5("You have indicated that this information is not reported in your manuscript.
          Please explain why this information is not reported.
          Your response will be included in the transparency statement published alongside your manuscript."),
      textAreaInput("Q5_followup", 
                label = NULL, 
                value = isolate(desValues$Q5_followup),
                placeholder = "Response required")
    )
    
  } else if (input$Q5 == "Yes") {
    desValues$Yes = 1
    desValues$Q5_complete = 1
    
    fullReport$Standard5 = "The authors report how they determined their sample size, the inclusion and exclusion criteria, all measures, and all manipulations."
    fullReport$S5_complete = 1
    fullReport$editor$Note[5] <- NA # explicitly set note to NA in case authors had previously provided a response to the pop-up but then changed their answer
    
    return(NULL)
  }
})

# when the next button is clicked
observeEvent(input$next6, {
  
  # if no text was provided in the textbox
  if ((input$Q5 == "No" | input$Q5 == "Not Applicable") & 
      (is.null(input$Q5_followup) || input$Q5_followup == "")) {
    
    desValues$YesQ5 = 0
    desValues$Q5_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Incomplete section",
      text = "You have not completed this section (there are missing responses or unanswered questions).",
      type = "error")
    
  } else {
    desValues$Q5_followup = input$Q5_followup
    
    desValues$measureStatus = 1
    fullReport$S5_output = "B"
    desValues$Q5_complete = 1
    fullReport$S5_complete = 1
    desValues$Q5 = "No"
    desValues$YesQ5 = 2
  }
  
  
  if (desValues$Q5_complete == 1) {
    updateTabsetPanel(session, "sidebar", selected = "prereg")
  }
})

