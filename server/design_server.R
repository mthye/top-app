output$insertQ5 <- renderUI({
  fluidPage(
    h5("5. If the manuscript reports any form of data presentation or analysis, either descriptive or inferential, please confirm that the following details are included in the manuscript."),
    br(),
    h5("(1) You report how you determined your SAMPLE SIZE"),
    h6("This explanation could consist of a formal sampling plan (e.g. statistical power analysis) or an informal reason of any kind, including (but not limited to) a rule-of-thumb to achieve parity with previous studies, a determination based on the size of a pre-existing dataset, or a determination based on the maximum possible sample size given finite resources (e.g. patient availability, limited recruitment time, etc)."),
    br(),
    h5("(2) The INCLUSION and EXCLUSION CRITERIA applied to data acquisition and analysis are reported"),
    h6("This is relevant for for any studies that involved the recruitment of a patient (or patients), participants, animals, biological samples, generation of simulated data, computational modelling, or the reanalysis of existing data (including meta-analysis, systematic reviews, or systematic maps)."),
    br(),
    h5("(3) The manuscript reports whether the inclusion and exclusion criteria were established PRIOR to data analysis"),
    br(),
    h5("(4) All MANIPULATIONS of data or variables are reported"),
    br(),
    h5("(5) All MEASURES are reported, including one or more dependent variables or any other form of qualitative or quantitative observation"),
    
    pickerInput(
      inputId = "Q5",
      label = "",
      choices = c("Yes", "No", "Not Applicable"),
      multiple = FALSE,
      selected = isolate(desValues$Q5),
      options = list(title = "Response required"),
    ),
    
  )
})

observeEvent(input$Q5, {
  if (input$Q5 == "No" | input$Q5 == "Not Applicable") {
    inputSweetAlert(
      session = session,
      inputId = "popupQ5",
      title = "Further details required",
      type = "question",
      input = "textarea",
      text = "You have indicated that this information is not reported in your manuscript. Are you sure this is correct?
        If so, please explain why this information is not reported.
        Otherwise close this window and change your response.
        Your statement will be included in your report for further editorial assessment.",
      btn_labels = c("Yes I am sure", "No, change my answer")
    )
    
    desValues$Yes = 0
    
  } else if (input$Q5 == "Yes") {
    desValues$Yes = 1
    desValues$Q5_complete = 1
    
    fullReport$Standard5 = "The authors report how they determined their sample size, the inclusion and exclusion criteria, all measures, and all manipulations."
    fullReport$S5_complete = 1
  }
})

observeEvent(input$popupQ5, {
  if (input$popupQ5 == "No, change my answer") {
    updatePickerInput(session,
                      inputId = "Q5",
                      selected = "")
    desValues$YesQ5 = 0
    desValues$Q5_complete = 0
    desValues$Q5 = ""
  } else if (input$popupQ5 == "") {
    sendSweetAlert(
      session = session,
      title = "No response in the text box",
      text = "You selected 'Yes I am sure' but did not provide the required details in the text box.
      Your answer to this question has been reset.",
      type = "error"
    )
    updatePickerInput(session,
                      inputId = "Q5",
                      selected = "")
    desValues$YesQ5 = 0
    desValues$Q5_complete = 0
    desValues$Q5 = ""
  } else {
    desValues$measureStatus = 1
    fullReport$S5_output = "B"
    fullReport$editor$Note[5] <- "Yes"
    desValues$Q5_complete = 1
    fullReport$S5_complete = 1
    desValues$Q5 = "No"
    
    fullReport$Standard5 = paste(
      "The manuscript does not report any measures, dependent variables, or other observations.",
      "Note to Editor. The authors have described the nature of the data in the following statement.",
      input$popupQ5)
    
    desValues$YesQ5 = 2
  }
})

observeEvent(input$next6, {
               updateTabsetPanel(session, "sidebar", selected = "prereg")
             })



