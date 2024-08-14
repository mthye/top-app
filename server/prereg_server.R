# Q6  ---------------------------------------------------------------------
output$insertQ6 <- renderUI({
  fluidPage(
    h5("6. Was any part of the study procedures pre-registered in a time-stamped, 
            institutional registry PRIOR to the research being conducted? "),
    h6("Study procedures include any components of the research undertaken prior 
            to data analysis, such as specification of hypotheses, sampling plans, recruitment 
            processes, definition of study variables and data acquisition methods. Please note 
            that an approved ethics application generally does not count as a pre-registered study 
            procedure unless the application is time-stamped and publicly available."),
    pickerInput(
      inputId = "Q6",
      label = "",
      choices = c("Yes", "No"),
      selected = isolate(preregValues$Q6),
      multiple = FALSE, 
      options = list(title = "Response required")
    ),
    
    #uiOutput("insertQ6b"),
    #uiOutput("insertQ6c"),
    uiOutput("insertQ7"),
    uiOutput("insertQ7a"),
    uiOutput("insertQ7b"),
    uiOutput("insertQ7c"),
  )
})

#If user says no to study prereg go to next section
observeEvent(input$Q6, {

    # Reset all responses that follow in this decision tree
    preregValues$studyDevs = 0
    preregValues$studyRep = 0
    preregValues$Q6a = NULL

    if (input$Q6 == "Yes") {
      inputSweetAlert(
        session = session,
        inputId = "Q6a",
        input = "text",
        title = "Please enter the exact URL to the time-stamped study procedures in an independent repository.",
        inputPlaceholder = "e.g.: https://osf.io/9f6gx/",
        allowOutsideClick = FALSE,
        showCloseButton = FALSE
      )
      preregValues$studyYes = 0
    } else if (input$Q6 == "No") {

      fullReport$S6_complete = 1
      fullReport$S6_output = "A"

      preregValues$studyYes = 2
      preregValues$Q6_complete = 1

      preregValues$Q6 = "No"


      #updateTabsetPanel(session, "sidebar", selected = "results")
    }
})

observeEvent(input$Q6a, {
  
  # URL checks
  if (input$Q6a=="") {
    sendSweetAlert(
      session = session,
      title = "No URL provided",
      text = "You have not provided a URL - please choose your response and copy/paste or type a URL in the text box provided.",
      type = "error"
    )
    
    updatePickerInput(
      session,
      inputId = "Q6",
      selected = ""
    )
    
    preregValues$studyYes = 0
    fullReport$S6_complete = 0
    preregValues$Q6_complete = 0
    preregValues$Q6 = ""
  } else {
    # Create a dataframe to store all URL checks - these should be reset on input
    preregValues$Q6a = data.frame(matrix(ncol = 4, nrow = 1))
    names(preregValues$Q6a) <- c("URL", "Valid_check", "Repo_check", "Http_check")
    
    preregValues$Q6a$URL <- as.character(input$Q6a)
    preregValues$Q6a$Valid_check <- ifelse(is_valid_url(preregValues$Q6a$URL)==TRUE, "valid", "invalid")
  }
  
  if ("valid" %in% preregValues$Q6a$Valid_check) {
    
    preregValues$Q6a$Http_check <- ifelse(http_error(preregValues$Q6a$URL)==FALSE, "valid", "invalid")
    preregValues$Q6a$Repo_check <- ifelse(TRUE %in% str_contains(preregValues$Q6a$URL, 
                                                                 c("drive", "google", "dropbox"), ignore.case = TRUE),
                                          "invalid", "valid")
    
  }
  
  if ("valid" %in% preregValues$Q6a$Http_check & "invalid" %in% preregValues$Q6a$Repo_check) {
    sendSweetAlert(
      session = session,
      title = "Invalid repository",
      text = "Google Drive and Dropbox are not considered valid repositories for public archiving of code.",
      type = "error"
    )
    updatePickerInput(
      session,
      inputId = "Q6",
      selected = ""
    )
    
    preregValues$studyYes = 0
    fullReport$S6_complete = 0
    preregValues$Q6_complete = 0
    preregValues$Q6 = ""
  } 
  
  if ("invalid" %in% preregValues$Q6a$Http_check | "invalid" %in% preregValues$Q6a$Valid_check) {
    
    sendSweetAlert(
      session = session,
      title = "Invalid URL",
      text = "The URL you provided is invalid / does not exist. Please check that you have used the exact address (including https://...).",
      type = "error"
    )
    
    updatePickerInput(
      session,
      inputId = "Q6",
      selected = ""
    )
    preregValues$studyYes = 0
    fullReport$S6_complete = 0
    preregValues$Q6_complete = 0
    preregValues$Q6 = ""
  } 
  
  if ("valid" %in% preregValues$Q6a$Http_check & "valid" %in% preregValues$Q6a$Repo_check) {
    preregValues$studyYes = 1
    preregValues$Q6_complete = 1
    preregValues$Q6 = "Yes"
    fullReport$S6_complete = 1
  }
})

# Q6b  ---------------------------------------------------------------------

# output$insertQ6b <- renderUI({
#   if (preregValues$studyYes == 1) {
#     fluidPage(
#       h5("Did the study procedures in the manuscript or supplementary information deviate in 
#          any way from those described  in the pre-registered protocol?"),
#       p(em("For the purposes of this question, a 'deviation' is any explicit change from the 
#          pre-registered procedures, as well as the reporting of any additional procedures 
#          in the manuscript that were either missing from the protocol or were documented 
#          with less precision in the protocol than in the manuscript.")),
#       pickerInput(
#         inputId = "Q6b",
#         label = "",
#         choices = c("Yes", "No"),
#         multiple = FALSE,
#         options = list(
#           title = "Response required"
#         )
#       )
#     )} 
# })

# observeEvent(input$Q6b, {
#   if (input$Q6b=="No") {
#     confirmSweetAlert(
#       session = session,
#       inputId = "popupQ6b",
#       type = "warning",
#       title = "Confirmation",
#       text = "Are you sure there were no deviations from the pre-registered study 
#       procedures? Authors often under-report deviations from protocol, such as the 
#       incomplete reporting of study variables and more detailed descriptions of 
#       procedures in the manuscript than in the protocol. If you are sure there 
#       were no deviations, this will be noted in the TOP statement.",
#       btn_labels = c("No", "Yes I am sure"),
#       btn_colors = c("#04B404", "#FE642E")
#     )
#     preregValues$studyDevs = 0
#     preregValues$Q6b_complete = 0
#     preregValues$Q6b = ""
#   } else if (input$Q6b=="Yes") {
#     preregValues$studyDevs = 1
#     fullReport$S6_complete = 0
#     preregValues$Q6b_complete = 1
#     preregValues$Q6b = "Yes"
#   }
# })

# observeEvent(input$popupQ6b, {
#   if (input$popupQ6b==TRUE) {
#     preregValues$studyDevs = 2
#     # sendSweetAlert(
#     #   session = session, html = TRUE,
#     #   title = "Section successfully completed!", 
#     #   text = tagList(
#     #     "Download your session responses to avoid potential data loss.",
#     #     downloadBttn(
#     #       outputId = "downloadRDS"
#     #     )
#     #   ),
#     #   type = "success"
#     # )
#     
#     #go to next section
#     #updateTabsetPanel(session, "sidebar", selected = "results")
#     fullReport$S6_complete = 1
#     fullReport$S6_output = "B"
#     
#     
#     fullReport$S6_url = as.character(input$Q6a)
#     preregValues$Q6b_complete = 1
#     preregValues$Q6b = "No"
#  
#   } else {
#     updatePickerInput(
#       session,
#       inputId = "Q6b",
#       selected = ""
#     )
#     
#     preregValues$studyDevs = 0
#     fullReport$S6_complete = 0
#     preregValues$Q6b_complete = 0
#     preregValues$Q6b = ""
#   }
# })

# Q6c  ---------------------------------------------------------------------

# output$insertQ6c <- renderUI({
#   if (preregValues$studyDevs == 1) {
#     fluidPage(
#       h5("Are ALL deviations from the pre-registered study procedures reported in the 
#          manuscript or supplementary information?"),
#       pickerInput(
#         inputId = "Q6c",
#         label = "",
#         choices = c("Yes", "No"),
#         multiple = FALSE,
#         options = list(
#           title = "Response required"
#         )
#       )
#     )} 
# })

# observeEvent(input$Q6c, {
#   if (input$Q6c=="No") {
#     inputSweetAlert(
#       session = session,
#       inputId = "popupQ6c",
#       title = "Confirmation",
#       text = "You have indicated that the reporting of study procedures deviated from 
#       the pre-registered protocol, but that these deviations are not reported in the 
#       manuscript or supplementary information. Is this correct? If so, this will be 
#       noted in the TOP statement and you will be asked to provide an explanation for 
#       the lack of disclosure.",
#       input = "text",
#       type = "question",
#       btn_labels = c("Yes I am sure", "No, change my answer")
#     )
#     preregValues$studyRep = 0
#     preregValues$Q6c_complete = 0
#     preregValues$Q6c = ""
#   } else if (input$Q6c=="Yes") {
#     preregValues$studyRep = 1
#     
#      #   sendSweetAlert(
#      #   session = session, html = TRUE,
#      #   title = "Section successfully completed!", 
#      #   text = tagList(
#      #     "Download your session responses to avoid potential data loss.",
#      #     downloadBttn(
#      #       outputId = "downloadRDS"
#      #     )
#      #   ),
#      #   type = "success"
#      # )
#     #updateTabsetPanel(session, "sidebar", selected = "results")
#        
#     fullReport$S6_complete = 1
#     fullReport$S6_output = "C"
# 
#     fullReport$S6_url = as.character(input$Q6a)
#   }
# })

#something is wrong here?
# observeEvent(input$popupQ6c, {
#   if (input$popupQ6c=="No, change my answer") {
#     updatePickerInput(
#       session,
#       inputId = "Q6c",
#       selected = ""
#     )
#     preregValues$studyRep = 0
#     preregValues$Q6c_complete = 0
#     preregValues$Q6c = ""
#   } else if (input$popupQ6c=="") {
#     sendSweetAlert(
#       session = session,
#       title = "No response in the text box",
#       text = "You selected 'Yes I am sure' but did not provide the required details in the text box.
#       Your answer to this question has been reset.",
#       type = "error"
#     )
#     updatePickerInput(
#       session,
#       inputId = "Q6c",
#       selected = ""
#     )
#     preregValues$studyRep = 0
#     preregValues$Q6c_complete = 0
#     preregValues$Q6c = ""
#   } else {
#     preregValues$studyRep = 2
#     preregValues$Q6c_complete = 1
#     preregValues$Q6c = "No"
# 
#       # sendSweetAlert(
#       #   session = session, html = TRUE,
#       #   title = "Section successfully completed!", 
#       #   text = tagList(
#       #     "Download your session responses to avoid potential data loss.",
#       #     downloadBttn(
#       #       outputId = "downloadRDS"
#       #     )
#       #   ),
#       #   type = "success"
#       # )
#       #updateTabsetPanel(session, "sidebar", selected = "results")
#     
#     fullReport$S6_complete = 1
#     fullReport$S6_output = "D"
#     fullReport$S6_url = as.character(input$Q6a)
#     fullReport$S6_explain = as.character(input$popupQ6c)
#     
#     preregValues$Q6c_complete = 1
#     preregValues$Q6c = "No"
#     doc <- isolate(fullReport$doc) %>%
#       cursor_reach(keyword = "Study Preregistration") %>%
#       body_add_par(paste("At least part of the study procedures was pre-registered in a time-stamped, institutional registry prior to the research being conducted.",
#                          "Study procedures were preregistered at:",
#                          as.character(input$Q6a), " ")) %>%
#       body_add_par(paste("The actual study procedures deviated from the preregistered protocol. These deviations are not fully disclosed. The authors have provided the following explanation:", as.character(input$popupQ6c))) %>%
#       body_add_par("")
#     
#     fullReport$doc <- doc
#   }
# })


# Q7  ---------------------------------------------------------------------

output$insertQ7 <- renderUI({
  fluidPage(
    h5("Was any part of the analysis plans pre-registered in a time-stamped, 
            institutional registry PRIOR to the research being conducted?"),
    h6("Analysis plans typically include methods of data preprocessing, intended 
            reporting of descriptive statistics, proposed sequences of analyses, and 
            details of statistical models and assumptions. Please note that an approved 
            ethics application generally does not count as a pre-registered analysis plan 
            unless the application is time-stamped and publicly available."),
    pickerInput(
      inputId = "Q7",
      label = "",
      choices = c("Yes", "No"),
      selected = isolate(preregValues$Q7),
      multiple = FALSE,
      options = list(
       title = "Response required"
      )
    )
  )
})

observeEvent(input$Q7, {

  preregValues$analysisDevs = 0
  preregValues$analysisRep = 0
  preregValues$Q7a = NULL

  if (input$Q7 == "Yes") {
    inputSweetAlert(
      session = session,
      inputId = "Q7a",
      input = "text",
      title = "Please enter the exact URL to the time-stamped analysis plans in an independent repository.",
      inputPlaceholder = "e.g.: https://osf.io/9f6gx/",
      allowOutsideClick = FALSE,
      showCloseButton = FALSE
    )
    preregValues$analysisYes = 0

  } else if (input$Q7 == "No") {

    fullReport$S7_complete = 1
    fullReport$S7_output = "A"

    preregValues$analysisYes = 2
    preregValues$Q7_complete = 1
    preregValues$Q7 = "No"

    # sendSweetAlert(
    #   session = session, html = TRUE,
    #   title = "Section successfully completed!",
    #   text = tagList(
    #     "Download your session responses to avoid potential data loss.",
    #     downloadBttn(
    #       outputId = "downloadRDS"
    #     )
    #   ),
    #   type = "success"
    # )
    updateTabsetPanel(session, "sidebar", selected = "results")
  }
})

observeEvent(input$Q7a, {
  # URL checks
  if (input$Q7a=="") {
    sendSweetAlert(
      session = session,
      title = "No URL provided",
      text = "You have not provided a URL - please choose your response and copy/paste or type a URL in the text box provided.",
      type = "error"
    )
    
    updatePickerInput(
      session,
      inputId = "Q7",
      selected = ""
    )
    
    preregValues$analysisYes = 0
    fullReport$S7_complete = 0
    preregValues$Q7_complete = 0
    preregValues$Q7 = ""
  } else {
    # Create a dataframe to store all URL checks - these should be reset on input
    preregValues$Q7a = data.frame(matrix(ncol = 4, nrow = 1))
    names(preregValues$Q7a) <- c("URL", "Valid_check", "Repo_check", "Http_check")
    
    preregValues$Q7a$URL <- as.character(input$Q7a)
    preregValues$Q7a$Valid_check <- ifelse(is_valid_url(preregValues$Q7a$URL)==TRUE, "valid", "invalid")
  }
  
  if ("valid" %in% preregValues$Q7a$Valid_check) {
    
    preregValues$Q7a$Http_check <- ifelse(http_error(preregValues$Q7a$URL)==FALSE, "valid", "invalid")
    preregValues$Q7a$Repo_check <- ifelse(TRUE %in% str_contains(preregValues$Q7a$URL, 
                                                                 c("drive", "google", "dropbox"), ignore.case = TRUE),
                                          "invalid", "valid")
  }
  
  if ("valid" %in% preregValues$Q7a$Http_check & "invalid" %in% preregValues$Q7a$Repo_check) {
    sendSweetAlert(
      session = session,
      title = "Invalid repository",
      text = "Google Drive and Dropbox are not considered valid repositories for public archiving of code.",
      type = "error"
    )
    
    updatePickerInput(
      session,
      inputId = "Q7",
      selected = ""
    )
    
    preregValues$analysisYes = 0
    fullReport$S7_complete = 0
    preregValues$Q7_complete = 0
    preregValues$Q7 = ""
  } 
  
  if ("invalid" %in% preregValues$Q7a$Http_check | "invalid" %in% preregValues$Q7a$Valid_check) {
    
    sendSweetAlert(
      session = session,
      title = "Invalid URL",
      text = "The URL you provided is invalid / does not exist. Please check that you have used the exact address (including https://...).",
      type = "error"
    )
    
    updatePickerInput(
      session,
      inputId = "Q7",
      selected = ""
    )
    preregValues$analysisYes = 0
    fullReport$S7_complete = 0
    preregValues$Q7_complete = 0
    preregValues$Q7 = "0"
  } 
  
  if ("valid" %in% preregValues$Q7a$Http_check & "valid" %in% preregValues$Q7a$Repo_check) {
    preregValues$analysisYes = 1
    fullReport$S7_complete = 0
    preregValues$Q7_complete = 1
    preregValues$Q7 = "Yes"
  }
  
})

# Q7b  ---------------------------------------------------------------------

output$insertQ7b <- renderUI({
  if (preregValues$analysisYes == 1) {
    fluidPage(
      h5("Did the reported study procedures and/or analyses in the manuscript or supplementary information deviate 
         in any way from those described  in the pre-registered protocol?"),
      h6("For the purposes of this question, a 'deviation' is any explicit change from the 
         pre-registered analysis plans, as well as the reporting of any additional analyses 
         in the manuscript that were either missing from the protocol or were documented with 
         less precision in the protocol than in the manuscript."),
      pickerInput(
        inputId = "Q7b",
        label = "",
        choices = c("Yes", "No"),
        selected = isolate(preregValues$Q7b),
        multiple = FALSE,
        options = list(
          title = "Response required"
        )
      )
    )}
})

observeEvent(input$Q7b, {
  if (input$Q7b=="No") {
    confirmSweetAlert(
      session = session,
      inputId = "popupQ7b",
      type = "warning",
      title = "Confirmation",
      text = "Are you sure there were no deviations from the pre-registered analysis plans? 
      Authors often under-report deviations from protocol, such as changes in analysis parameters, 
      the addition or replacement of analyses, or more detailed descriptions of analysis steps in 
      the manuscript than in the protocol. If you are sure there were no deviations, this will be 
      noted in the Transparency statement.",
      btn_labels = c("No", "Yes I am sure"),
      btn_colors = c("#04B404", "#FE642E")
    )
    preregValues$analysisDevs = 0
    preregValues$Q7b_complete = 0
    preregValues$Q7b = ""
  } else if (input$Q7b=="Yes") {
    preregValues$analysisDevs = 1
    fullReport$S7_complete = 0
    preregValues$Q7b_complete = 1
    preregValues$Q7b = "Yes"
  }
})

observeEvent(input$popupQ7b, {
  if (input$popupQ7b==TRUE) {
    preregValues$analysisDevs = 2
    # sendSweetAlert(
    #   session = session,
    #   title = "Section successfully completed!",
    #   text = "All your responses are valid. You will now proceed to the next section.",
    #   type = "success"
    # )
    #go to next section
    updateTabsetPanel(session, "sidebar", selected = "results")
    fullReport$S7_complete = 1
    fullReport$S7_output = "B"
    fullReport$S7_url = as.character(input$Q7a)
    preregValues$Q7b_complete = 1
    preregValues$Q7b = "No"
  } else {
    updatePickerInput(
      session,
      inputId = "Q7b",
      selected = ""
    )
    preregValues$analysisDevs = 0
    fullReport$S7_complete = 0
    preregValues$Q7b_complete = 0
    preregValues$Q7b = ""
  }
})

# Q7c  ---------------------------------------------------------------------

output$insertQ7c <- renderUI({
  if (preregValues$analysisDevs==1) {
    fluidPage(
      h5("Are ALL deviations from the pre-registered study procedures and/or analysis plans reported in 
         the manuscript or supplementary information?"),
      h6("Please ensure that any additional analyses in the manuscript that were 
         NOT described in the pre-registered plans are clearly identified in the 
         manuscript as “unregistered”, “post hoc”, or “exploratory”."),
      pickerInput(
        inputId = "Q7c",
        label = "",
        choices = c("Yes", "No"),
        selected= isolate(preregValues$Q7c),
        multiple = FALSE,
        options = list(
          title = "Response required"
        )
      )
    )} 
})

observeEvent(input$Q7c, {
  if (input$Q7c=="No") {
    inputSweetAlert(
      session = session,
      inputId = "popupQ7c",
      title = "Confirmation",
      text = "You have indicated that the reporting of the analyses deviated from the 
      pre-registered protocol, but that these deviations are not reported in the manuscript 
      or supplementary information. Is this correct? If so, this will be noted in the Transparency 
      Statement and you will be asked to provide an explanation for the lack of disclosure.",
      input = "text",
      type = "question",
      btn_labels = c("Yes I am sure", "No, change my answer")
    )
    preregValues$analysisRep = 0
    preregValues$Q7c_complete = 0
    preregValues$Q7c = ""
  } else if (input$Q7c=="Yes") {
    preregValues$analysisRep = 0
    
    # sendSweetAlert(
    #   session = session, html = TRUE,
    #   title = "Section successfully completed!", 
    #   text = tagList(
    #     "Download your session responses to avoid potential data loss.",
    #     downloadBttn(
    #       outputId = "downloadRDS"
    #     )
    #   ),
    #   type = "success"
    # )
    #updateTabsetPanel(session, "sidebar", selected = "results")
    
    updateTabsetPanel(session, "sidebar", selected = "results")
    
    fullReport$S7_complete = 1
    fullReport$S7_output = "C"
    fullReport$S7_url = as.character(input$Q7a)
    preregValues$Q7c_complete = 1
    preregValues$Q7c = "Yes"
  }
})

observeEvent(input$popupQ7c, {
  if (input$popupQ7c=="No, change my answer") {
    updatePickerInput(
      session,
      inputId = "Q7c",
      selected = ""
    )
    preregValues$analysisRep = 0
    preregValues$Q7c_complete = 0
    preregValues$Q7c = ""
    
  } else if (input$popupQ7c=="") {
    sendSweetAlert(
      session = session,
      title = "No response in the text box",
      text = "You selected 'Yes I am sure' but did not provide the required details in the text box.
      Your answer to this question has been reset.",
      type = "error"
    )
    updatePickerInput(
      session,
      inputId = "Q7c",
      selected = ""
    )
    preregValues$analysisRep = 0
    preregValues$Q7c_complete = 0
    preregValues$Q7c = ""
  } else {
    preregValues$analysisRep = 2
    
    # sendSweetAlert(
    #   session = session, html = TRUE,
    #   title = "Section successfully completed!", 
    #   text = tagList(
    #     "Download your session responses to avoid potential data loss.",
    #     downloadBttn(
    #       outputId = "downloadRDS"
    #     )
    #   ),
    #   type = "success"
    # )
    updateTabsetPanel(session, "sidebar", selected = "results")
    
    fullReport$S7_complete = 1
    fullReport$S7_output = "D"
    fullReport$S7_url = as.character(input$Q7a)
    fullReport$S7_explain = as.character(input$popupQ7c)
    preregValues$Q7c_complete = 1
    preregValues$Q7c = "No"
  }
})




