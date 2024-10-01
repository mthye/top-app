observeEvent(input$previousS2, {
  updateTabsetPanel(session, "sidebar", selected = "code")
})


output$insertQ4 <- renderUI({
  fluidPage(
    h5("4. Does the manuscript or supplementary information report any studies involving generation of original data?"),
    h6("Data that existed prior to the research being undertaken includes data reported in meta-analyses and systematic reviews."),
    pickerInput(
      inputId = "Q4",
      label = "",
      choices = c(
        "Yes", 
        "No - the manuscript does not report data analysis of any kind",
        "No - the manuscript only reports analysis of data that already existed prior to the research being undertaken"
      ),
      selected = isolate(matsValues$Q4),
      multiple = FALSE,
      options = list(title = "Response required"),
    ),
    
    uiOutput("insertQ4a"),
  )
})


observeEvent(input$Q4, {
  if (input$Q4 == "Yes") {
    matsValues$matsYes = 1
    matsValues$Q4 = "Yes"
    fullReport$S4_complete = 0

  } else if (input$Q4 == "No - the manuscript does not report data analysis of any kind") {
    matsValues$matsYes = 2
    matsValues$Q4 = "No - the manuscript does not report data analysis of any kind"
    fullReport$S4_complete = 1
    fullReport$S4_output = "A"

    if (dataValues$dataYes == 1) {
      confirmSweetAlert(
        session = session,
        inputId = "matsIC",
        type = "warning",
        title = "Inconsistent responses",
        text = "You have previously indicated that your manuscript reports the outcomes of data analysis (Data Transparency).
      It is likely that this inconsistency will prevent the journal from being able to progress your manuscript.
      Do you confirm that you want to proceed without changing your response?",
        btn_labels = c("No", "Yes"),
        btn_colors = c("#04B404", "#FE642E")
      )
      fullReport$S4_complete = 0
    } else if (matsValues$matsYes == 2 & dataValues$dataYes != 2) {
      updateTabsetPanel(session, "sidebar", selected = "design")
      fullReport$S4_complete = 1
    }

  } else if (input$Q4 == "No - the manuscript only reports analysis of data that already existed prior to the research being undertaken") {
    matsValues$matsYes = 2
    matsValues$Q4 = "No - the manuscript only reports analysis of data that already existed prior to the research being undertaken"
    fullReport$S4_complete = 1
    fullReport$S4_output = "B"

    updateTabsetPanel(session, "sidebar", selected = "design")

  }

})

observeEvent(input$matsIC, {
  if (input$matsIC == TRUE) {
    matsValues$matsYes = 2
    updateTabsetPanel(session, "sidebar", selected = "design")
    fullReport$S4_complete = 1
  } else if (input$matsIC == FALSE) {
    matsValues$matsYes = 0
    updatePickerInput(session,
                      inputId = "Q4",
                      selected = "")
    fullReport$S4_complete = 0
  }
})

output$insertQ4a <- renderUI({
  if (matsValues$matsYes == 1) {
  #if (matsValues$Q4 == "Yes") {
    fluidPage(
      ## Question 4a
      h5(
        "4a. Select all the types of research materials that were used to generate or acquire data.
         Common examples include code or software used to conduct a study via computer (scripts run in Psychopy,
         E-Prime, Presentation etc) or other electronic devices, surveys, psychometric instruments (e.g. IQ tests,
         personality inventories), and clinical assessment tools."
      ),
      pickerInput(
        inputId = "Q4a",
        width = "300px",
        label = "",
        choices = matsTypes,
        selected = isolate(matsValues$selectedMatsTypes),
        multiple = TRUE,
        options = list(
          "live-search" = TRUE,
          "selected-text-format" = "count",
          "title" = "Types of research materials"
        )
      ),
      
      div(
        style = "display: inline-block;",
        actionButton("newMats", icon("folder-plus"), style = "color: #1D89FF; background-color: white; border-color: white; font-size: 18px")
      ),
      div(
        style = "display: inline-block;",
        h6("Add a type of research materials that is not listed above"
        )),
      br(),
      br()
    )
  }
})

observeEvent(input$next4a, {
  if (input$Q4 == "" |
      #(length(matsValues$selectedMatsTypes) == 0 &
       (length(input$Q4a) == 0 &
       matsValues$matsYes == 1)) {
    sendSweetAlert(session = session,
                   title = "Incomplete section",
                   type = "error")
    fullReport$S4_complete = 0
  }
  
  if (matsValues$matsYes == 2) {
    updateTabsetPanel(session, "sidebar", selected = "design")
    
  }
  
  if ((length(input$Q4a) > 0 &
       matsValues$matsYes == 1)) {
    matsValues$S4a_complete = 1

    updateTabsetPanel(session, "S4_box", selected = "tab4b")
  }
})

output$insertQ4b <- renderUI({
  if (matsValues$matsYes == 1) {
    fluidPage(
      h5(
        "4b. Please indicate the public availability for all selected types of research materials, as explained below."
      ),
      tags$div(
        HTML(
          "<dl>
             <dt>Public availability:</dt>
              <dd>- For all types of research materials you first need to indicate whether ALL, SOME or NO research materials are publicly available.</dd>
             <dt>Availability barrier:</dt>
              <dd>- If ALL research materials are publicly available, please select the option 'N/A - ALL materials are publicly available'.</dd>
              <dd>- If SOME or NO research materials are publicly available, you need to specify the reason(s), such as an ethical barrier.</dd>
             <dt>Public access route:</dt>
              <dd> - If SOME or ALL research materials are publicly available without any restrictions, please indicate how readers can access them. For repositories (e.g. OSF) we ask that you provide a valid URL.</dd>
              <dd> - If NO research materials are publicly available, you should select the option 'N/A - NO materials are publicly available'.</dd>
              </dl>"
        )
      ),
      div(
        style = "display:table-row; float:left",
        
        p(
          em("Note."),
          "Any paper-based materials are expected to be scanned and uploaded to a public repository unless there are legal or ethical barriers to doing so."
        ),
        p(
          "You can copy and paste cell contents for same responses (e.g. URL). Please use the exact address from your browser when adding any URLs (e.g. https://osf.io/9f6gx/)."
        )
      ),
      br(),
      rHandsontableOutput("Q4b"),
      br(),
      br()
    )
  }
})

# Observe input on Q4a and create table for Q4b with all selected material types
observeEvent(input$Q4a, {
  fullReport$S4_complete = 0
  
  matsValues$selectedMatsTypes <- input$Q4a
  
  # matsTable1 <- data.frame(matrix(ncol = 5, nrow = 1))
  # matsTable1[1:5] <- NA_character_
  # matsTable1[1:length(matsValues$selectedMatsTypes), 1] <-
  #   as.character(matsValues$selectedMatsTypes)
  
    # if outputs were previously saved
    if (!is.null(matsValues$saveQ4b)){
      matsTable1 <- data.frame(matsValues$Q4b)
      matsValues$saveQ4b = NULL # set saveQ4b to null to allow changes to be made after reloading data

    } else {
      matsTable1 <- data.frame(matrix(ncol = 5, nrow = 1))
      matsTable1[1:5] <- NA_character_
      matsTable1[1:length(matsValues$selectedMatsTypes), 1] <-
        as.character(matsValues$selectedMatsTypes)
    }
  
  output$Q4b <- renderRHandsontable({
    matsValues$Q4b = hot_to_r(input$Q4b)
    
    if (all(is.na(matsValues$Q4b[, 2:5])) == TRUE) {
      DF <- matsTable1
    } else if (all(is.na(matsValues$Q4b[, 2:5])) == FALSE &
               length(setdiff(
                 as.vector(matsValues$selectedMatsTypes),
                 as.vector(matsValues$Q4b$X1)
               )) == 0) {
      DF <- matsValues$Q4b
      DF <-
        subset(DF, DF$X1 %in% as.vector(matsValues$selectedMatsTypes))
    } else if (all(is.na(matsValues$Q4b[, 2:5])) == FALSE &
               length(setdiff(
                 as.vector(matsValues$selectedMatsTypes),
                 as.vector(matsValues$Q4b$X1)
               )) > 0) {
      new_cats <-
        setdiff(as.vector(matsValues$selectedMatsTypes),
                as.vector(matsValues$Q4b$X1))
      DF <- matsValues$Q4b
      row1 <- nrow(DF) + 1
      
      DF[row1, 1] <- new_cats
    }
    else
    {
      DF <- matsTable1
    }
    
    rhandsontable(
      DF,
      useTypes = TRUE,
      stretchH = "all",
      height = 300,
      colHeaders = c(
        "Type of research materials",
        "Public availability",
        "Availability barrier",
        "Public access route",
        "URL (if applicable)"
      )
    ) %>%
      hot_context_menu(allowRowEdit = FALSE, allowColEdit = FALSE) %>%
      hot_col(col = "Type of research materials",
              readOnly = TRUE,
              allowInvalid = FALSE) %>%
      hot_col(
        col = "Public availability",
        type = "dropdown",
        allowInvalid = FALSE,
        source = c(
          "ALL materials are publicly available",
          "SOME materials are publicly available",
          "NO materials are publicly available"
        )
      ) %>%
      hot_col(
        col = "Availability barrier",
        type = "dropdown",
        source = matsReason,
        allowInvalid = FALSE
      ) %>%
      hot_col(
        col = "Public access route",
        type = "dropdown",
        source = matsPublic,
        allowInvalid = FALSE
      ) %>%
      hot_cols(colWidths = c(220, 225, 250, 250, 120))
  })
})

# Observe input for additional data types (button click)

observeEvent(input$newMats, {
  # Pop up with text input
  inputSweetAlert(
    session,
    inputId = "addMats",
    title = "Add a new unlisted type of research materials",
    text = "Please use abbreviations where possible (if included in the manuscript).",
    input = "text",
    type = "info"
  )
})

# Add user's responses to the list and update it
observeEvent(input$addMats, {
  matsValues$matsTypes <- c(matsValues$matsTypes, input$addMats)
  
  updatePickerInput(
    session,
    inputId = "Q4a",
    label = "",
    choices = matsValues$matsTypes,
    selected = isolate(matsValues$Q4a)
  )
})

# Back buttons  ---------------------------------------------------------------------

observeEvent(input$previous4b,
             {
               updateTabsetPanel(session, "S4_box", selected = "tab4a")
             })

observeEvent(input$previous4c,
             {
               updateTabsetPanel(session, "S4_box", selected = "tab4b")
             })

observeEvent(input$next4b, {
  show_modal_spinner(spin = "orbit",
                     color = "purple",
                     text = "Checking your responses...")
  
  ## Convert table input into an R object
  matsValues$Q4b <- hot_to_r(input$Q4b)
  
  ## Convert all factors into characters
  matsValues$Q4b[] <- lapply(matsValues$Q4b, as.character)
  
  ## Check whether any URLs exist
  matsValues$Q4b$exists <-
    ifelse(is_valid_url(matsValues$Q4b[5]) == TRUE, "valid", "invalid")
  
  if ("valid" %in% matsValues$Q4b) {
    url_validity <- data.frame(matrix(ncol = 2))
    url_validity[1] <-
      matsValues$Q4b$X5[matsValues$Q4b$exists == "valid"]
    url_validity[2] <-
      !ldply(matsValues$Q4b$X5[matsValues$Q4b$exists == "valid"], http_error)
    
    url_valid <- subset(url_validity, url_validity[2] == TRUE)
    url_invalid <- subset(url_validity, url_validity[2] == FALSE)
    
    matsValues$Q4b$exists <-
      ifelse(
        matsValues$Q4b$exists == "valid" &
          matsValues$Q4b[5] %in% url_valid,
        "TRUE",
        ifelse(
          matsValues$Q4b$exists == "valid" &
            matsValues$Q4b[5] %in% url_invalid,
          "FALSE",
          "FALSE"
        )
      )
  } else {
    matsValues$Q4b$exists <-
      ifelse(matsValues$Q4b$exists == "invalid", "FALSE", "NA")
  }
  
  
  ## Conditions for errors, warnings and successful completion
  
  matsValues$Q4b$condition <- if_else(
    is.na(matsValues$Q4b[2]) |
      is.na(matsValues$Q4b[3]) | is.na(matsValues$Q4b[4]),
    "incomplete",
    if_else(
      is.na(matsValues$Q4b[5]) &
        matsValues$Q4b[4] == "Materials in repository (URL required)",
      "url_miss",
      if_else(
        matsValues$Q4b[4] == "Materials are contained in the paper",
        "manuscript",
        if_else(
          matsValues$Q4b[3] == "Technical barrier only" |
            matsValues$Q4b[3] == "Author preference",
          "invalid_barrier",
          if_else(
            matsValues$Q4b[6] == "FALSE" &
              matsValues$Q4b[4] == "Materials in repository (URL required)",
            "invalid_url",
            "success"
          )
        )
      )
    )
  )
  
  
  matsValues$Q4b$inconsistency <-
    if_else(
      matsValues$Q4b[2] == "ALL materials are publicly available" &
        (
          matsValues$Q4b[3] != "N/A - ALL materials are publicly available" |
            matsValues$Q4b[4] == "N/A - NO materials are publicly available"
        ),
      "inconsistent_all",
      if_else(
        matsValues$Q4b[2] == "SOME materials are publicly available" &
          (
            matsValues$Q4b[3] == "N/A - ALL materials are publicly available" |
              matsValues$Q4b[4] == "N/A - NO materials are publicly available"
          ),
        "inconsistent_some",
        if_else(
          matsValues$Q4b[2] == "NO materials are publicly available" &
            (
              matsValues$Q4b[3] == "N/A - ALL materials are publicly available" |
                matsValues$Q4b[4] != "N/A - NO materials are publicly available"
            ),
          "inconsistent_no",
          "success"
        )
      )
    )
  
  
  
  matsValues$Q4b_partialMats <-
    ifelse("SOME materials are publicly available" %in% matsValues$Q4b$X2,
           1,
           2)
  matsValues$Q4b_noneMats <-
    ifelse("NO materials are publicly available" %in% matsValues$Q4b$X2,
           1,
           2)
  
  matsValues$Q4b_invalidrepo <-
    ifelse(TRUE %in% str_contains(
      matsValues$Q4b$X5,
      c("drive", "google", "dropbox"),
      ignore.case = TRUE
    ),
    1,
    2)
  
  ## Save URLs that don't exist to present in an alert later on when user tries to proceed
  matsValues$Q4b_urls <-
    unique(matsValues$Q4b$X5[matsValues$Q4b$condition == "invalid_url"])
  
  matsValues$Q4b_incomplete <-
    ifelse("incomplete" %in% matsValues$Q4b$condition, 1, 2)
  matsValues$Q4b_urlmiss <-
    ifelse("url_miss" %in% matsValues$Q4b$condition, 1, 2)
  matsValues$Q4b_manuscript <-
    ifelse("manuscript" %in% matsValues$Q4b$condition, 1, 2)
  matsValues$Q4b_invalid_url <-
    ifelse("invalid_url" %in% matsValues$Q4b$condition, 1, 2)
  matsValues$Q4b_invalid_barrier <-
    ifelse("invalid_barrier" %in% matsValues$Q4b$condition, 1, 2)
  
  matsValues$Q4b_inconsistent_all <-
    ifelse("inconsistent_all" %in% matsValues$Q4b$inconsistency, 1, 2)
  matsValues$Q4b_inconsistent_some <-
    ifelse("inconsistent_some" %in% matsValues$Q4b$inconsistency, 1, 2)
  matsValues$Q4b_inconsistent_no <-
    ifelse("inconsistent_no" %in% matsValues$Q4b$inconsistency, 1, 2)
  
  # 1. Incomplete section (empty table or missing responses)
  if (is.null(input$Q4b) | matsValues$Q4b_incomplete < 2) {
    matsValues$warning_incomplete_Q4b = 1
    matsValues$Q4b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Incomplete section",
      text = "You have not completed this section (there are missing responses or unanswered questions).",
      type = "error"
    )
  } else if (!is.null(input$Q4b) & matsValues$Q4b_incomplete == 2) {
    matsValues$warning_incomplete_Q4b = 2
  }
  
  # 2. Missed URL when repository is specified
  if (matsValues$warning_incomplete_Q4b == 2 &
      matsValues$Q4b_urlmiss == 1) {
    matsValues$Q4b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Missing URL",
      text = "A URL is required if you have indicated that publicly available materials are archived in a repository.",
      type = "error"
    )
  }
  
  # 3. Materials are in the manuscript and authors haven't yet confirmed the pop-up
  if (matsValues$Q4b_manuscript == 1 &
      (is.null(input$manuscriptOkQ4b) |
       isFALSE(input$manuscriptOkQ4b)) &
      matsValues$warning_incomplete_Q4b == 2 &
      matsValues$Q4b_urlmiss == 2) {
    matsValues$Q4b_complete = 0
    
    matsValues$warning_manuscript = 1
    confirmSweetAlert(
      session = session,
      inputId = "manuscriptOkQ4b",
      type = "warning",
      title = "Warning",
      text = "Do you confirm that the manuscript contains all the research materials?
      If this is NOT the case, the journal will be unable to progress your submission.",
      btn_labels = c("No", "Yes")
    )
  } else if (matsValues$Q4b_manuscript == 1 &
             isTRUE(input$manuscriptOkQ4b) &
             matsValues$warning_incomplete_Q4b == 2 &
             matsValues$Q4b_urlmiss == 2) {
    matsValues$warning_manuscript = 2
  }
  
  # 4. There is an invalid barrier and they haven't confirmed they have approval from the editor
  if (matsValues$Q4b_invalid_barrier == 1 &
      (is.null(input$barrierApprovalQ4b) |
       isFALSE(input$barrierApprovalQ4b)) &
      matsValues$warning_incomplete_Q4b == 2 &
      matsValues$Q4b_urlmiss == 2 &
      (matsValues$warning_manuscript == 2 |
       matsValues$warning_manuscript == 0)) {
    matsValues$Q4b_complete = 0
    
    matsValues$warning_invalid_barrier = 1
    fullReport$editor$Note[4] <- "No"
    
    confirmSweetAlert(
      session = session,
      inputId = "barrierApprovalQ4b",
      title = "Warning",
      text = "If you have selected 'Technical barrier only' or 'Author preference' please note that these
      reasons are generally not an eligible basis for restricting public availability of research materials.
      Do you confirm that you have selected them only following editorial approval?",
      type = "warning",
      btn_labels = c("No", "Yes")
    )
  } else if (matsValues$Q4b_invalid_barrier == 1 &
             isTRUE(input$barrierApprovalQ4b) &
             matsValues$warning_incomplete_Q4b == 2 &
             matsValues$Q4b_urlmiss == 2 &
             (matsValues$warning_manuscript == 2 |
              matsValues$warning_manuscript == 0)) {
    matsValues$warning_invalid_barrier = 2
    fullReport$editor$Note[4] <- "Yes"
    
  }
  
  # 5. Invalid repositories
  if (matsValues$Q4b_invalidrepo == 1 &
      matsValues$warning_incomplete_Q4b == 2 &
      matsValues$Q4b_urlmiss == 2 &
      (matsValues$warning_manuscript == 2 |
       matsValues$warning_manuscript == 0) &
      (matsValues$warning_invalid_barrier == 0 |
       matsValues$warning_invalid_barrier == 2)) {
    matsValues$Q4b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Invalid repository",
      text = "Google Drive and Dropbox are not considered valid repositories for public archiving of research materials.",
      type = "error"
    )
  }
  
  # 6. Invalid URLs
  if (matsValues$Q4b_invalid_url == 1 &
      matsValues$Q4b_invalidrepo == 2 &
      matsValues$warning_incomplete_Q4b == 2 &
      matsValues$Q4b_urlmiss == 2 &
      (matsValues$warning_manuscript == 2 |
       matsValues$warning_manuscript == 0) &
      (matsValues$warning_invalid_barrier == 0 |
       matsValues$warning_invalid_barrier == 2)) {
    matsValues$Q4b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "The following URLs are invalid:",
      text = matsValues$Q4b_urls,
      type = "warning"
    )
  }
  
  # 7. Inconsistent responses - ALL
  if (matsValues$Q4b_inconsistent_all == 1 &
      matsValues$Q4b_invalid_url == 2 &
      matsValues$Q4b_invalidrepo == 2 &
      matsValues$warning_incomplete_Q4b == 2 &
      matsValues$Q4b_urlmiss == 2 &
      (matsValues$warning_manuscript == 2 |
       matsValues$warning_manuscript == 0) &
      (matsValues$warning_invalid_barrier == 0 |
       matsValues$warning_invalid_barrier == 2)) {
    matsValues$Q4b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that ALL materials are publicly available but your other responses do not match -
      make sure that 'N/A - ALL materials are publicly available' is selected where applicable and that a valid public access route is chosen.",
      type = "error"
    )
  }
  
  # 8. Inconsistent responses - SOME
  if (matsValues$Q4b_inconsistent_some == 1 &
      matsValues$Q4b_inconsistent_all == 2 &
      matsValues$Q4b_invalid_url == 2 &
      matsValues$Q4b_invalidrepo == 2 &
      matsValues$warning_incomplete_Q4b == 2 &
      matsValues$Q4b_urlmiss == 2
      &
      (matsValues$warning_manuscript == 2 |
       matsValues$warning_manuscript == 0) &
      (matsValues$warning_invalid_barrier == 0 |
       matsValues$warning_invalid_barrier == 2)) {
    matsValues$Q4b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that SOME materials are publicly available but your other responses do not match -
      for example, you might have selected the option 'N/A - ALL materials are publicly available'.",
      type = "error"
    )
  }
  
  # 9. Inconsistent responses - NONE
  if (matsValues$Q4b_inconsistent_no == 1 &
      matsValues$Q4b_inconsistent_some == 2 &
      matsValues$Q4b_inconsistent_all == 2 &
      matsValues$Q4b_invalid_url == 2 &
      matsValues$Q4b_invalidrepo == 2 &
      matsValues$warning_incomplete_Q4b == 2 &
      matsValues$Q4b_urlmiss == 2 &
      (matsValues$warning_manuscript == 2 |
       matsValues$warning_manuscript == 0) &
      (matsValues$warning_invalid_barrier == 0 |
       matsValues$warning_invalid_barrier == 2)) {
    matsValues$Q4b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that NO materials are publicly available but your other responses do not match -
      for example, you might have selected the option 'N/A - ALL materials are publicly available'.",
      type = "error"
    )
  } else if (matsValues$Q4b_inconsistent_no == 2 &
             matsValues$Q4b_inconsistent_some == 2 &
             matsValues$Q4b_inconsistent_all == 2 &
             matsValues$Q4b_invalid_url == 2 &
             matsValues$Q4b_invalidrepo == 2 &
             matsValues$warning_incomplete_Q4b == 2 &
             matsValues$Q4b_urlmiss == 2 &
             (matsValues$warning_manuscript == 2 |
              matsValues$warning_manuscript == 0) &
             (matsValues$warning_invalid_barrier == 0 |
              matsValues$warning_invalid_barrier == 2)) {
    matsValues$Q4b_complete = 1
    fullReport$S4_table1 = matsValues$Q4b[, 1:5]
    
    names(fullReport$S4_table1) <- c(
      "Type of research materials",
      "Public availability",
      "Availability barrier",
      "Public access route",
      "URL"
    )
    
    fullReport$S4_table1[2] <-
      ifelse(
        fullReport$S4_table1[2] == "ALL materials are publicly available",
        "ALL materials",
        ifelse(
          fullReport$S4_table1[2] == "SOME materials are publicly available",
          "SOME materials",
          "NO materials"
        )
      )
    
    fullReport$S4_table1[3]  <-
      ifelse(
        fullReport$S4_table1[3] == "N/A - ALL materials are publicly available",
        "NA",
        fullReport$S4_table1$`Availability barrier`
      )
    
    fullReport$S4_table1[4]  <-
      ifelse(
        fullReport$S4_table1[4] == "N/A - NO materials are publicly available",
        "NA",
        fullReport$S4_table1$`Public access route`
      )
    
    fullReport$S4_table3 <- subset(fullReport$S4_table1, select = c(1, 4:5))
    
    if (isTRUE(levels(as.factor(fullReport$S4_table1[[2]]))=="ALL materials")) {
      fullReport$S4_output = "C"
    }
  }
  
  remove_modal_spinner()
  
  ##Code for partial/no availability
  
  if (matsValues$Q4b_complete == 1 &
      matsValues$Q4b_partialMats == 2 &
      matsValues$Q4b_noneMats == 2) {
    matsValues$S4b_complete = 1
    # sendSweetAlert(
    #   session = session, 
    #   title = "Section successfully completed!", 
    #   html = TRUE,
    #   text = tagList(
    #     "Download your session responses to avoid potential data loss.",
    #     downloadBttn(
    #       outputId = "downloadRDS"
    #     )
    #   ),
    #   type = "success"
    # )
    updateTabsetPanel(session, "sidebar", selected = "design")
    fullReport$S4_complete = 1
    fullReport$S4_output = "C"
  }
  
  if (matsValues$Q4b_complete == 1 &
      (matsValues$Q4b_partialMats == 1 |
       matsValues$Q4b_noneMats == 1)) {
    matsValues$partialMatsTypes <-
      subset(
        matsValues$Q4b,
        matsValues$Q4b$X2 != "ALL materials are publicly available",
        select = 1:2
      )
    
    # if outputs were previously saved
    if (!is.null(matsValues$saveQ4c)){
      matsTable1 <- data.frame(matsValues$Q4c)
      matsValues$saveQ4c = NULL # set saveQ4b to null to allow changes to be made after reloading data
      
    } else {
      
      matsTable1 <- data.frame(matrix(ncol = 4, nrow = 1))
      matsTable1[1:4] <- NA_character_
      matsTable1[1:nrow(matsValues$partialMatsTypes), 1] <-
        as.character(matsValues$partialMatsTypes$X1)
      
      matsTable1[1:nrow(matsValues$partialMatsTypes), 2] <-
        as.character(matsValues$partialMatsTypes$X2)
      
      matsTable1$X2 <-
        if_else(
          matsTable1$X2 == "NO materials are publicly available",
          "NO materials",
          if_else(
            matsTable1$X2 == "SOME materials are publicly available",
            "SOME materials",
            "NA"
          )
        )
    }
    
    output$Q4c <- renderRHandsontable({
      if (!is.null(input$Q4c)) {
        matsValues$Q4c = hot_to_r(input$Q4c)
        
        if (all(is.na(matsValues$Q4c[, 2:4])) == TRUE) {
          DF <- matsTable1
          
        } else if (all(is.na(matsValues$Q4c[, 2:4])) == FALSE &
                   length(setdiff(
                     matsValues$partialMatsTypes$X1,
                     as.vector(matsValues$Q4c$X1)
                   )) == 0) {
          DF <- matsValues$Q4c
          DF <-
            subset(DF,
                   DF$X1 %in% as.vector(matsValues$partialMatsTypes$X1))
          
        } else if (all(is.na(matsValues$Q4c[, 2:4])) == FALSE &
                   length(setdiff(
                     as.vector(matsValues$partialMatsTypes$X1),
                     as.vector(matsValues$Q4c$X1)
                   )) > 0) {
          
          new_cats <-
            setdiff(
              as.vector(matsValues$partialMatsTypes$X1),
              as.vector(matsValues$Q4c$X1)
            )
          
          DF <- matsValues$Q4c
          row1 <- nrow(DF) + 1
          DF[row1, 1] <- new_cats
          
          if (!is.na(matsValues$partialMatsTypes[row1, 2])) {
            DF[row1, 2] = matsTable1[row1, 2]
          }
        }
      }
      else
      {
        DF <- matsTable1
        
      }
      
      rhandsontable(
        DF,
        useTypes = TRUE,
        stretchH = "all",
        height = 200,
        colHeaders = c(
          "Type of research materials",
          "Public availability",
          "Restricted access route",
          "Restricted access conditions"
        )
      ) %>%
        hot_context_menu(allowRowEdit = FALSE, allowColEdit = FALSE) %>%
        hot_col(col = "Type of research materials",
                readOnly = TRUE,
                allowInvalid = FALSE) %>%
        hot_col(col = "Public availability",
                readOnly = TRUE,
                allowInvalid = FALSE) %>%
        
        hot_col(
          col = "Restricted access route",
          type = "dropdown",
          source = matsRestricted,
          allowInvalid = FALSE
        ) %>%
        hot_col(
          col = "Restricted access conditions",
          type = "dropdown",
          source = matsCondition,
          allowInvalid = FALSE
        ) %>%
        hot_cols(colWidths = c(220, 200, 280, 350))
    })
    
    
    matsValues$S4b_complete=1
    # sendSweetAlert(
    #   session = session, html = TRUE,
    #   title = "Data save reminder", 
    #   text = tagList(
    #     "You will now proceed to the next subsection. 
    #     You can download your session responses now if you wish to pause or continue
    #     to the end of this Standard.",
    #     downloadBttn(
    #       outputId = "downloadRDS"
    #     )
    #   ),
    #   type = "info"
    # )
    updateTabsetPanel(session, "S4_box", selected = "tab4c")
    fullReport$S4_complete = 0
  }
})

output$insertQ4c <- renderUI({
  req(input$Q4b)
  
  if (matsValues$Q4b_complete == 1 &
      (matsValues$Q4b_partialMats == 1 |
       matsValues$Q4b_noneMats == 1)) {
    fluidPage(
      h5(
        "4c. You have indicated partial and/or no public availability for your research material type(s). In this table please explain how readers
         can access the research materials that are not publicly available (restricted access route) and under what conditions they can do so (restricted
         access conditions)."
      ),
      h5(
        "You can copy and paste cell contents for same responses (e.g. URL)."
      ),
      br(),
      rHandsontableOutput("Q4c"),
      br()
    )
  }
})

observeEvent(input$next4c, {
  show_modal_spinner(spin = "orbit",
                     color = "purple",
                     text = "Checking your responses...")
  
  matsValues$Q4c[] <- lapply(matsValues$Q4c, as.character)
  matsValues$Q4c$condition <-
    if_else(is.na(matsValues$Q4c$X3) |
              is.na(matsValues$Q4c$X4),
            "incomplete",
            "na")
  
  matsValues$Q4c_incomplete <-
    ifelse("incomplete" %in% matsValues$Q4c$condition, 1, 2)
  
  # inconsistent responses
  
  matsValues$Q4c$inconsistency <-
    if_else((
      matsValues$Q4c$X3 == "Readers can never access the 'restricted' materials" &
        matsValues$Q4c$X4 != "Readers can never access the 'restricted' materials"
    ) |
      (
        matsValues$Q4c$X3!= "Readers can never access the 'restricted' materials" &
          matsValues$Q4c$X4 == "Readers can never access the 'restricted' materials"
      ),
    "inconsistent_never",
    if_else(
      matsValues$Q4c$X3 == "Request to ethics committee(s)" &
        matsValues$Q4c$X4 == "Shared unconditionally upon request to author(s)",
      "inconsistent_ethics",
      if_else(
        matsValues$Q4c$X3 == "Request or apply to external authority" &
          matsValues$Q4c$X4 == "Shared unconditionally upon request to author(s)",
        "inconsistent_external",
        "success"
      )
    )
    )
  
  matsValues$Q4c_inconsistent_never <-
    ifelse("inconsistent_never" %in% matsValues$Q4c$inconsistency, 1, 2)
  matsValues$Q4c_inconsistent_ethics <-
    ifelse("inconsistent_ethics" %in% matsValues$Q4c$inconsistency,
           1,
           2)
  matsValues$Q4c_inconsistent_external <-
    ifelse("inconsistent_external" %in% matsValues$Q4c$inconsistency,
           1,
           2)
  # 1. Incomplete section (empty table or missing responses)
  if (is.null(input$Q4c) | matsValues$Q4c_incomplete < 2) {
    matsValues$warning_incomplete_Q4c = 1
    matsValues$Q4c_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Incomplete section",
      text = "You have not completed this section (there are missing responses or unanswered questions).",
      type = "error"
    )
  } else if (!is.null(input$Q4c) & matsValues$Q4c_incomplete == 2) {
    matsValues$warning_incomplete_Q4c = 2
  }
  
  # 2. Inconsistent responses - never
  
  if (matsValues$Q4c_inconsistent_never == 1 &
      matsValues$warning_incomplete_Q4c == 2) {
    matsValues$Q4c_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that readers can never access the 'restricted' materials but your other responses do not match -
      for example, you might have selected a route for restricted access.",
      type = "error"
    )
  }
  
  # 3. Inconsistent responses - ethics
  
  if (matsValues$Q4c_inconsistent_ethics == 1 &
      matsValues$Q4c_inconsistent_never == 2 &
      matsValues$warning_incomplete_Q4c == 2) {
    matsValues$Q4c_complete = 0
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that an approval is required by the ethics committee(s) but that the 'restricted' materials can be shared *unconditionally* upon request to authors.
      Please revise your responses to ensure that a valid route for access and corresponding conditions are selected.",
      type = "error"
    )
  }
  
  # 4. Inconsistent responses - external
  
  if (matsValues$Q4c_inconsistent_external == 1 &
      matsValues$Q4c_inconsistent_ethics == 2 &
      matsValues$Q4c_inconsistent_never == 2 &
      matsValues$warning_incomplete_Q4c == 2) {
    matsValues$Q4c_complete = 0
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that an approval or application to an external authority is required but that the 'restricted' materials can be shared *unconditionally* upon request to authors.
      Please revise your responses to ensure that a valid route for access and corresponding conditions are selected.",
      type = "error"
    )
  } else if (matsValues$Q4c_inconsistent_never == 2 &
             matsValues$Q4c_inconsistent_ethics == 2 &
             matsValues$Q4c_inconsistent_never == 2 &
             matsValues$warning_incomplete_Q4c == 2) {
    matsValues$Q4c_complete = 1
    fullReport$S4_complete = 1
    
    if (isTRUE(levels(as.factor(fullReport$S4_table1[[2]]))=="NO materials")) {
      fullReport$S4_output = "E"
      
    } else {
      fullReport$S4_output = "D"
      
    }    
    fullReport$S4_table2 <- matsValues$Q4c[1:4]
    
    names(fullReport$S4_table2) <- c(
      "Type of research materials",
      "Public availability",
      "Restricted access route",
      "Restricted access conditions"
    )
    
    # sendSweetAlert(
    #   session = session,
    #   title = "Section successfully completed!",
    #   html = TRUE,
    #   text = tagList(
    #     "Download your session responses to avoid potential data loss.",
    #     downloadBttn(
    #       outputId = "downloadRDS"
    #     )
    #   ),
    #   type = "success"
    # )
    matsValues$S4c_complete = 1
    
    if (fullReport$S4_output == "E") {
      fullReport$S4_table4 <- fullReport$S4_table2
      
      fullReport$S4_table4[, 2] <- fullReport$S4_table1[, 3]
    }
    
    updateTabsetPanel(session, "sidebar", selected = "design")
  }
  remove_modal_spinner()
  
  
})
