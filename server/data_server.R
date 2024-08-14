observeEvent(input$next2, {
  if (input$ms_id == "") {
    sendSweetAlert(session = session,
                   title = "Incomplete section",
                   type = "error")
    fullReport$S2_complete = 0
  }
  
  if (input$ms_id != "") {
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
    dataValues$ID = input$ms_id
    updateTabsetPanel(session, "S2_box", selected = "tab2a")
    
  }
})

output$insertQ2 <- renderUI({
  fluidPage(
    h5("2. Does your manuscript report the outcomes of data analysis?"),
    h6("This includes any empirical research that generates new data, re-analysis of existing data,
          meta-analysis, systematic review, simulated data, or modelling."),
    h6("In general, this answer will only be no for narrative reviews and comment articles. If the manuscript reports data analysis and this section is not completed then the journal will be unable to progress your submission."),
    pickerInput(
      inputId = "Q2",
      label = "",
      choices = c("Yes", "No"),
      selected = isolate(dataValues$Q2),
      multiple = FALSE,
      options = list(
        title = "Response required"),
    ),
    
    uiOutput("insertQ2a"),
  )
})

observeEvent(input$Q2, {
  
  if (input$Q2 == "Yes") {
    dataValues$dataYes = 1
    dataValues$Q2 = "Yes"
    fullReport$S2_complete = 0
    
  } else if (input$Q2 == "No")  {
    dataValues$dataYes = 2
    dataValues$Q2 = "No"
    fullReport$S2_complete = 1
    fullReport$S2_output = "A"
  }
  
})

output$insertQ2a <- renderUI({
  
  if (dataValues$dataYes == 1) {
    fluidPage(
      h5(
        "2a. Select all the relevant data categories for all studies in the manuscript."
      ),
      pickerInput(
        inputId = "Q2a",
        width = "300px",
        label = "",
        choices = dataTypes,
        selected = isolate(dataValues$selectedDataTypes),
        multiple = TRUE,
        options = list(
          "live-search" = TRUE,
          "selected-text-format" = "count",
          "title" = "Data categories"
        )
      ),
      div(
        style = "display: inline-block;",
        actionButton("newData", icon("folder-plus"), style = "color: #1D89FF; background-color: white; border-color: white; font-size: 18px")
      ),
      div(style = "display: inline-block;", h6(
        "Add a data category that is not listed above. Once added, you'll be able to select it from the drop down list."
      )),
      br(),
      br()
    )
  } 
})

observeEvent(input$next2a, {
  if (input$Q2 == "" |
      (length(dataValues$selectedDataTypes) == 0 &
       dataValues$dataYes == 1)) {
    sendSweetAlert(session = session,
                   title = "Incomplete section",
                   type = "error")
    fullReport$S2_complete = 0
  }
  
  if (dataValues$dataYes == 2) {
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
    updateTabsetPanel(session, "sidebar", selected = "code")
    
  }
  
  if ((length(dataValues$selectedDataTypes) > 0 &
       dataValues$dataYes == 1)) {
    dataValues$S2a_complete = 1
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
    updateTabsetPanel(session, "S2_box", selected = "tab2b")
    
  }
  
})

output$insertQ2b <- renderUI({
  if (dataValues$dataYes == 1) {
    fluidPage(
      h5(
        "2b. Please indicate the public availability for all selected data categories and data types (raw and processed), as explained below."
      ),
      tags$div(
        HTML(
          "<dl>
             <dt>Public availability:</dt>
              <dd>- For both raw and processed data you first need to indicate whether ALL, SOME or NO data are publicly available.</dd>
             <dt>Availability barrier:</dt>
              <dd>- If ALL data are publicly available, please select the option 'N/A - ALL data are publicly available'.</dd>
              <dd>- If SOME or NO data are publicly available, you need to specify the reason(s), such as an ethical barrier.</dd>
             <dt>Public access route:</dt>
              <dd> - If SOME or ALL data are publicly available without any restrictions, please indicate how readers can access them. For repositories (e.g. OSF) we ask that you provide a valid URL.</dd>
              <dd> - If NO data are publicly available, you should select the option 'N/A - NO data are publicly available'.</dd>
              </dl>"
        )
      ),
      div(
        style = "display:table-row; float:left",
        
        h5(
          "You can copy and paste cell contents for same responses (e.g. URL). Please use the exact address from your browser when adding any URLs (e.g. https://osf.io/9f6gx/). "
        )
      ) %>%
        helper(
          type = "inline",
          colour = "DarkViolet",
          content = dataHelper1,
          size = "m",
        ),
      br(),
      rHandsontableOutput("Q2b"),
      br(),
      br()
    )
  }
})

# Observe input on Q2a and create table for Q2b with all selected data categories

observeEvent(input$Q2a, {
  fullReport$S2_complete = 0
  
  dataValues$selectedDataTypes <- input$Q2a
  
  cats <- sort(rep(input$Q2a, 2))
  cats <- as.data.frame(cats)
  cats$cats <- as.character(cats$cats)
  cats$cats <- rename_data(cats)
  
  # if outputs were previously saved
  if (!is.null(dataValues$saveQ2b)){
    dataTable1 <- data.frame(dataValues$Q2b)
    dataValues$saveQ2b = NULL # set saveQ2b to null to allow changes to be made after reloading data
    
  } else {
    dataTable1 <- data.frame(matrix(ncol = 6, nrow = 1))
    dataTable1[1:6] <- NA_character_
    dataTable1[1:nrow(cats), 1] <- as.character(cats$cats)
    dataTable1[1:nrow(cats), 2] <-
      rep(c("Raw", "Processed"), length(input$Q2a))
  }
  
  ## Table for Q2b
  output$Q2b <- renderRHandsontable({
    if (!is.null(input$Q2b)) {
      dataValues$Q2b = hot_to_r(input$Q2b)

      if (all(is.na(dataValues$Q2b[, 3:6])) == TRUE) {
        DF <- dataTable1
      } else if (all(is.na(dataValues$Q2b[, 3:6])) == FALSE &
                 length(setdiff(as.vector(cats$cats), as.vector(dataValues$Q2b$X1))) == 0) {
        DF <- dataValues$Q2b
        DF <- subset(DF, DF$X1 %in% as.vector(cats$cats))
      } else if (all(is.na(dataValues$Q2b[, 3:6])) == FALSE &
                 length(setdiff(as.vector(cats$cats), as.vector(dataValues$Q2b$X1))) > 0) {
        new_cats <-setdiff(as.vector(cats$cats), as.vector(dataValues$Q2b$X1))
        DF <- dataValues$Q2b
        
        row1 <- nrow(DF) + 1
        row2 <- nrow(DF) + (length(new_cats) * 2)
        
        DF[row1:row2, 1] <- sort(rep(new_cats, 2))
        DF[row1:row2, 2] <-
          rep(c("Raw", "Processed"), length(new_cats))
      }
    } else {
      DF <- dataTable1
    }
    
    rhandsontable(
      DF,
      useTypes = TRUE,
      stretchH = "all",
      height = 300,
      colHeaders = c(
        "Data category",
        "Data type",
        "Public availability",
        "Availability barrier",
        "Public access route",
        "URL (if applicable)"
      )
    ) %>%
      hot_context_menu(allowRowEdit = FALSE, allowColEdit = FALSE,) %>%
      hot_col(col = "Data category",
              readOnly = TRUE,
              allowInvalid = FALSE) %>%
      hot_col(col = "Data type",
              readOnly = TRUE,
              allowInvalid = FALSE) %>%
      hot_col(
        col = "Public availability",
        type = "dropdown",
        allowInvalid = FALSE,

        source = c(
          "ALL data are publicly available",
          "SOME data are publicly available",
          "NO data are publicly available"
        )
      ) %>%
      hot_col(
        col = "Availability barrier",
        type = "dropdown",
        source = dataReason,
        allowInvalid = FALSE
      ) %>%
      hot_col(
        col = "Public access route",
        type = "dropdown",
        source = dataPublic,
        allowInvalid = FALSE
      ) %>%
      hot_cols(colWidths = c(200, 80, 225, 250, 250, 120))
    
  })
  
})

# Observe input for additional data types (button click)

observeEvent(input$newData, {
  # Pop up with text input
  inputSweetAlert(
    session,
    inputId = "addCat",
    title = "Add a new unlisted data category",
    text = "Please use abbreviations (if included in the manuscript) and indicate whether you refer to controls or patients (e.g. 'Example data - controls')",
    input = "text",
    type = "info"
  )
})

# Add user's responses to the list and update it
observeEvent(input$addCat, {
  # Add user's response to dataTypes
  dataValues$dataTypes <- c(dataValues$dataTypes, input$addCat)
  
  updatePickerInput(
    session,
    inputId = "Q2a",
    label = "",
    selected = isolate(dataValues$selectedDataTypes),
    choices = dataValues$dataTypes
  )
})

observeEvent(input$next2b, {
  show_modal_spinner(spin = "orbit",
                     color = "purple",
                     text = "Checking your responses...")
  ## Convert table input into an R object
  dataValues$Q2b <- hot_to_r(input$Q2b)
  
  ## Convert all factors into characters
  dataValues$Q2b[] <- lapply(dataValues$Q2b, as.character)
  
  ## Check whether any URLs exist
  
  dataValues$Q2b$exists <-
    ifelse(is_valid_url(dataValues$Q2b[6]) == TRUE, "valid", "invalid")
  
  if ("valid" %in% dataValues$Q2b) {
    
    url_validity <- data.frame(matrix(ncol=2))
    url_validity[1] <- dataValues$Q2b$X6[dataValues$Q2b$exists == "valid"]
    url_validity[2] <- !ldply(dataValues$Q2b$X6[dataValues$Q2b$exists == "valid"], http_error)
    
    url_valid <- subset(url_validity, url_validity[2] == TRUE)
    url_invalid <- subset(url_validity, url_validity[2] == FALSE)
    
    dataValues$Q2b$exists <-
      ifelse(
        dataValues$Q2b$exists == "valid" &
          dataValues$Q2b[6] %in% url_valid,
        "TRUE",
        ifelse(
          dataValues$Q2b$exists == "valid" &
            dataValues$Q2b[6] %in% url_invalid,
          "FALSE",
          "FALSE"
        )
      )
  } else {
    dataValues$Q2b$exists <-
      ifelse(dataValues$Q2b$exists == "invalid", "FALSE", "NA")
  }
  
  ## Conditions for errors, warnings and successful completion
  
  dataValues$Q2b$condition <- if_else(
    is.na(dataValues$Q2b[3]) |
      is.na(dataValues$Q2b[4]) | is.na(dataValues$Q2b[5]),
    "incomplete",
    if_else(
      is.na(dataValues$Q2b[6]) &
        dataValues$Q2b[5] == "Data in repository (URL required)",
      "url_miss",
      if_else(
        dataValues$Q2b[5] == "Data is contained in the paper",
        "manuscript",
        if_else(
          dataValues$Q2b[4] == "Technical barrier only" |
            dataValues$Q2b[4] == "Author preference",
          "invalid_barrier",
          if_else(
            dataValues$Q2b[7] == "FALSE" &
              dataValues$Q2b[5] == "Data in repository (URL required)",
            "invalid_url",
            "success"
          )
        )
      )
    )
  )
  
  dataValues$Q2b$inconsistency <- if_else(
    dataValues$Q2b[3] == "ALL data are publicly available" &
      (
        dataValues$Q2b[4] != "N/A - ALL data are publicly available" |
          dataValues$Q2b[5] == "N/A - NO data are publicly available"
      ),
    "inconsistent_all",
    if_else(
      dataValues$Q2b[3] == "SOME data are publicly available" &
        (
          dataValues$Q2b[4] == "N/A - ALL data are publicly available" |
            dataValues$Q2b[5] == "N/A - NO data are publicly available"
        ),
      "inconsistent_some",
      if_else(
        dataValues$Q2b[3] == "NO data are publicly available" &
          (
            dataValues$Q2b[4] == "N/A - ALL data are publicly available" |
              dataValues$Q2b[5] != "N/A - NO data are publicly available"
          ),
        "inconsistent_no",
        "success"
      )
    )
  )
  
  
  dataValues$Q2b_partialData <-
    ifelse("SOME data are publicly available" %in% dataValues$Q2b$X3, 1, 2)
  dataValues$Q2b_noneData <-
    ifelse("NO data are publicly available" %in% dataValues$Q2b$X3, 1, 2)
  dataValues$Q2b_invalidrepo <-
    ifelse(TRUE %in% str_contains(
      dataValues$Q2b$X6,
      c("drive", "google", "dropbox"),
      ignore.case = TRUE
    ),
    1,
    2)
  
  ## Save URLs that don't exist to present in an alert later on when user tries to proceed
  dataValues$Q2b_urls <-
    unique(dataValues$Q2b$X6[dataValues$Q2b$condition == "invalid_url"])
  
  dataValues$Q2b_incomplete <-
    ifelse("incomplete" %in% dataValues$Q2b$condition, 1, 2)
  dataValues$Q2b_urlmiss <-
    ifelse("url_miss" %in% dataValues$Q2b$condition, 1, 2)
  dataValues$Q2b_manuscript <-
    ifelse("manuscript" %in% dataValues$Q2b$condition, 1, 2)
  dataValues$Q2b_invalid_url <-
    ifelse("invalid_url" %in% dataValues$Q2b$condition, 1, 2)
  dataValues$Q2b_invalid_barrier <-
    ifelse("invalid_barrier" %in% dataValues$Q2b$condition, 1, 2)
  
  dataValues$Q2b_inconsistent_all <-
    ifelse("inconsistent_all" %in% dataValues$Q2b$inconsistency, 1, 2)
  dataValues$Q2b_inconsistent_some <-
    ifelse("inconsistent_some" %in% dataValues$Q2b$inconsistency, 1, 2)
  dataValues$Q2b_inconsistent_no <-
    ifelse("inconsistent_no" %in% dataValues$Q2b$inconsistency, 1, 2)
  
  
  # 1. Incomplete section (empty table or missing responses)
  if (is.null(input$Q2b) | dataValues$Q2b_incomplete < 2) {
    dataValues$warning_incomplete_Q2b = 1
    dataValues$Q2b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Incomplete section",
      text = "You have not completed this section (there are missing responses or unanswered questions).",
      type = "error"
    )
  } else if (!is.null(input$Q2b) & dataValues$Q2b_incomplete == 2) {
    dataValues$warning_incomplete_Q2b = 2
  }
  
  # 2. Missed URL when repository is specified
  if (dataValues$warning_incomplete_Q2b == 2 &
      dataValues$Q2b_urlmiss == 1) {
    dataValues$Q2b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Missing URL",
      text = "A URL is required if you have indicated that publicly available data is archived in a repository.",
      type = "error"
    )
  }
  
  # 3. Data is in the manuscript and authors haven't yet confirmed the pop-up
  if (dataValues$Q2b_manuscript == 1 &
      (is.null(input$manuscriptOkQ2b) |
       isFALSE(input$manuscriptOkQ2b)) &
      dataValues$warning_incomplete_Q2b == 2 &
      dataValues$Q2b_urlmiss == 2) {
    dataValues$Q2b_complete = 0
    
    dataValues$warning_manuscript = 1
    confirmSweetAlert(
      session = session,
      inputId = "manuscriptOkQ2b",
      type = "warning",
      title = "Warning",
      text = "Do you confirm that the manuscript contains the data? If this is NOT the case, the journal will be unable to progress your submission.",
      btn_labels = c("No", "Yes")
    )
  } else if (dataValues$Q2b_manuscript == 1 &
             isTRUE(input$manuscriptOkQ2b) &
             dataValues$warning_incomplete_Q2b == 2 &
             dataValues$Q2b_urlmiss == 2) {
    dataValues$warning_manuscript = 2
  }
  
  # 4. There is an invalid barrier and they haven't confirmed they have approval from the editor
  if (dataValues$Q2b_invalid_barrier == 1 &
      (is.null(input$barrierApprovalQ2b) |
       isFALSE(input$barrierApprovalQ2b)) &
      dataValues$warning_incomplete_Q2b == 2 &
      dataValues$Q2b_urlmiss == 2 &
      (dataValues$warning_manuscript == 2 |
       dataValues$warning_manuscript == 0)) {
    dataValues$Q2b_complete = 0
    
    dataValues$warning_invalid_barrier = 1
    fullReport$editor$Note[2] <- "No"
    fullReport$S2_Editor = 0
    confirmSweetAlert(
      session = session,
      inputId = "barrierApprovalQ2b",
      title = "Warning",
      text = "If you have selected 'Technical barrier only' or 'Author preference' please note that these
      reasons are generally not an eligible basis for restricting public availability of data.
      Do you confirm that you have selected them only following editorial approval?",
      type = "warning",
      btn_labels = c("No", "Yes")
    )
  } else if (dataValues$Q2b_invalid_barrier == 1 &
             isTRUE(input$barrierApprovalQ2b) &
             dataValues$warning_incomplete_Q2b == 2 &
             dataValues$Q2b_urlmiss == 2 &
             (dataValues$warning_manuscript == 2 |
              dataValues$warning_manuscript == 0)) {
    dataValues$warning_invalid_barrier = 2
    fullReport$editor$Note[2] <- "Yes"
  }
  
  # 5. Invalid repositories
  if (dataValues$Q2b_invalidrepo == 1 &
      dataValues$warning_incomplete_Q2b == 2 &
      dataValues$Q2b_urlmiss == 2 &
      (dataValues$warning_manuscript == 2 |
       dataValues$warning_manuscript == 0) &
      (dataValues$warning_invalid_barrier == 0 |
       dataValues$warning_invalid_barrier == 2)) {
    dataValues$Q2b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Invalid repository",
      text = "Google Drive and Dropbox are not considered valid repositories for public archiving of data.",
      type = "error"
    )
  }
  
  # 6. Invalid URLs
  if (dataValues$Q2b_invalid_url == 1 &
      dataValues$Q2b_invalidrepo == 2 &
      dataValues$warning_incomplete_Q2b == 2 &
      dataValues$Q2b_urlmiss == 2 &
      (dataValues$warning_manuscript == 2 |
       dataValues$warning_manuscript == 0) &
      (dataValues$warning_invalid_barrier == 0 |
       dataValues$warning_invalid_barrier == 2)) {
    dataValues$Q2b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "The following URLs are invalid:",
      text = dataValues$Q2b_urls,
      type = "warning" 
    )
  }
  
  # 7. Inconsistent responses - ALL
  if (dataValues$Q2b_inconsistent_all == 1 &
      dataValues$Q2b_invalid_url == 2 &
      dataValues$Q2b_invalidrepo == 2 &
      dataValues$warning_incomplete_Q2b == 2 &
      dataValues$Q2b_urlmiss == 2 &
      (dataValues$warning_manuscript == 2 |
       dataValues$warning_manuscript == 0) &
      (dataValues$warning_invalid_barrier == 0 |
       dataValues$warning_invalid_barrier == 2)) {
    dataValues$Q2b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that ALL data are publicly available but your other responses do not match -
      make sure that 'N/A - ALL data are publicly available' is selected where applicable and that a valid public access route is chosen.",
      type = "error"
    )
  }
  
  # 8. Inconsistent responses - SOME
  if (dataValues$Q2b_inconsistent_some == 1 &
      dataValues$Q2b_inconsistent_all == 2 &
      dataValues$Q2b_invalid_url == 2 &
      dataValues$Q2b_invalidrepo == 2 &
      dataValues$warning_incomplete_Q2b == 2 & dataValues$Q2b_urlmiss == 2
      &
      (dataValues$warning_manuscript == 2 |
       dataValues$warning_manuscript == 0) &
      (dataValues$warning_invalid_barrier == 0 |
       dataValues$warning_invalid_barrier == 2)) {
    dataValues$Q2b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that SOME data are publicly available but your other responses do not match -
      for example, you might have selected the option 'N/A - ALL data are publicly available'.",
      type = "error"
    )
  }
  
  # 9. Inconsistent responses - NONE
  if (dataValues$Q2b_inconsistent_no == 1 &
      dataValues$Q2b_inconsistent_some == 2 &
      dataValues$Q2b_inconsistent_all == 2 &
      dataValues$Q2b_invalid_url == 2 &
      dataValues$Q2b_invalidrepo == 2 &
      dataValues$warning_incomplete_Q2b == 2 & dataValues$Q2b_urlmiss == 2
      &
      (dataValues$warning_manuscript == 2 |
       dataValues$warning_manuscript == 0) &
      (dataValues$warning_invalid_barrier == 0 |
       dataValues$warning_invalid_barrier == 2)) {
    dataValues$Q2b_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that NO data are publicly available but your other responses do not match -
      for example, you might have selected the option 'N/A - ALL data are publicly available'.",
      type = "error"
    )
  } else if (dataValues$Q2b_inconsistent_no == 2 &
             dataValues$Q2b_inconsistent_some == 2 &
             dataValues$Q2b_inconsistent_all == 2 &
             dataValues$Q2b_invalid_url == 2 &
             dataValues$Q2b_invalidrepo == 2 &
             dataValues$warning_incomplete_Q2b == 2 & dataValues$Q2b_urlmiss == 2
             &
             (dataValues$warning_manuscript == 2 |
              dataValues$warning_manuscript == 0) &
             (dataValues$warning_invalid_barrier == 0 |
              dataValues$warning_invalid_barrier == 2)) {
    dataValues$Q2b_complete = 1
    
    fullReport$S2_table1 <- dataValues$Q2b[, 1:6]
    names(fullReport$S2_table1) <- c(
      "Data category",
      "Data type",
      "Public availability",
      "Availability barrier",
      "Public access route",
      "URL"
    )
    
    fullReport$S2_table1[3] <-
      ifelse(
        fullReport$S2_table1[3] == "ALL data are publicly available",
        "ALL data",
        ifelse(
          fullReport$S2_table1[3] == "SOME data are publicly available",
          "SOME data",
          "NO data"
        )
      )
    
    fullReport$S2_table1[4]  <-
      ifelse(
        fullReport$S2_table1[4] == "N/A - ALL data are publicly available",
        "NA",
        fullReport$S2_table1$`Availability barrier`
      )
    
    fullReport$S2_table1[5]  <-
      ifelse(
        fullReport$S2_table1[5] == "N/A - NO data are publicly available",
        "NA",
        fullReport$S2_table1$`Public access route`
      )
    
  }
  remove_modal_spinner()
  
  ##Code for partial/no availability
  
  if (dataValues$Q2b_complete == 1 &
      dataValues$Q2b_partialData == 2 & dataValues$Q2b_noneData == 2) {
    
    dataValues$S2b_complete = 1
    
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
    
    fullReport$S2_table3 <- subset(fullReport$S2_table1, select = c(1:2, 5:6))
    
    if (isTRUE(levels(as.factor(fullReport$S2_table1[[3]]))=="ALL data")) {
      fullReport$S2_output = "B"
    }
    
    updateTabsetPanel(session, "sidebar", selected = "code")
    fullReport$S2_complete = 1
    
  }
  
  if (dataValues$Q2b_complete == 1 &
      (dataValues$Q2b_partialData == 1 | dataValues$Q2b_noneData == 1)) {
    dataValues$partialDataTypes <-
      subset(
        dataValues$Q2b,
        dataValues$Q2b$X3 != "ALL data are publicly available",
        select = 1:3
      )
    
    if (!is.null(dataValues$saveQ2c)){
      dataTable1 <- data.frame(dataValues$Q2c)
      dataValues$saveQ2c = NULL # set saveQ2c to null to allow changes to be made after reloading data
      
    } else {
      
    dataTable1 <- data.frame(matrix(ncol = 5, nrow = 1))
    dataTable1[1:5] <- NA_character_
    dataTable1[1:nrow(dataValues$partialDataTypes), 1] <-
      as.character(dataValues$partialDataTypes$X1)
    dataTable1[1:nrow(dataValues$partialDataTypes), 2] <-
      as.character(dataValues$partialDataTypes$X2)
    dataTable1[1:nrow(dataValues$partialDataTypes), 3] <-
      as.character(dataValues$partialDataTypes$X3)
    
    dataTable1[3] <-
      if_else(
        dataTable1[3] == "NO data are publicly available",
        "NO data",
        if_else(
          dataTable1[3] == "SOME data are publicly available",
          "SOME data",
          "NA"
        )
      )
    
    }
    
    output$Q2c <- renderRHandsontable({
      if (!is.null(input$Q2c)) {
        dataValues$Q2c = hot_to_r(input$Q2c)
        
        
        if (all(is.na(dataValues$Q2c[, 2:5])) == TRUE) {
          DF <- dataTable1
        } else if (all(is.na(dataValues$Q2c[, 2:5])) == FALSE &
                   length(setdiff(
                     dataValues$partialDataTypes$X1,
                     as.vector(dataValues$Q2c$X1)
                   )) == 0) {
          DF <- dataValues$Q2c
          DF <-
            subset(DF,
                   DF$X1 %in% as.vector(dataValues$partialDataTypes$X1))
          
        } else if (all(is.na(dataValues$Q2c[, 2:5])) == FALSE &
                   length(setdiff(
                     as.vector(dataValues$partialDataTypes$X1),
                     as.vector(dataValues$Q2c$X1)
                   )) > 0) {
          new_cats <-
            setdiff(
              as.vector(dataValues$partialDataTypes$X1),
              as.vector(dataValues$Q2c$X1)
            )
          DF <- dataValues$Q2c
          row1 <- nrow(DF) + 1
          DF[row1, 1] <- new_cats
        }
      }
      else
      {
        DF <- dataTable1
      }
      
      
      rhandsontable(
        DF,
        useTypes = TRUE,
        stretchH = "all",
        height = 200,
        colHeaders = c(
          "Data category",
          "Data type",
          "Public availability",
          "Restricted access route",
          "Restricted access conditions"
        )
      ) %>%
        hot_context_menu(allowRowEdit = FALSE, allowColEdit = FALSE) %>%
        hot_col(col = "Data category",
                readOnly = TRUE,
                allowInvalid = FALSE) %>%
        hot_col(col = "Data type",
                readOnly = TRUE,
                allowInvalid = FALSE) %>%
        hot_col(col = "Public availability",
                readOnly = TRUE,
                allowInvalid = FALSE) %>%
        
        hot_col(
          col = "Restricted access route",
          type = "dropdown",
          source = dataRestricted,
          allowInvalid = FALSE
        ) %>%
        hot_col(
          col = "Restricted access conditions",
          type = "dropdown",
          source = dataCondition,
          allowInvalid = FALSE
        ) %>%
        hot_cols(colWidths = c(200, 200, 200, 280, 350))
    })
    
    dataValues$S2b_complete = 1
    
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
    updateTabsetPanel(session, "S2_box", selected = "tab2c")
    fullReport$S2_complete = 0
    
  }
  
})

# Clicking on the Back button on pages id, 2B, and 2C

observeEvent(input$backid, {
  updateTabsetPanel(session, "S2_box", selected = "id")
})

observeEvent(input$back2b, {
  updateTabsetPanel(session, "S2_box", selected = "tab2a")
})

observeEvent(input$back2c, {
  updateTabsetPanel(session, "S2_box", selected = "tab2b")
})

output$insertQ2c <- renderUI({
  req(input$Q2b)
  
  if (dataValues$Q2b_complete == 1 &
      (dataValues$Q2b_partialData == 1 | dataValues$Q2b_noneData == 1)) {
    fluidPage(
      h5(
        "2c. You have indicated partial and/or no public availability for the data type(s) presented below. In this table please explain how readers
            can access the data that is not publicly available (restricted access route) and under what conditions they can do so (restricted
            access conditions)."
      ),
      # p(
      #   em(
      #     "You can copy and paste cell contents for same responses (e.g. URL)."
      #   )
      # ),
      br(),
      rHandsontableOutput("Q2c"),
      br()
    )
  }
})

observeEvent(input$next2c, {
  show_modal_spinner(spin = "orbit",
                     color = "purple",
                     text = "Checking your responses...")
  
  dataValues$Q2c[] <- lapply(dataValues$Q2c, as.character)
  dataValues$Q2c$condition <-
    if_else(is.na(dataValues$Q2c$X4) |
              is.na(dataValues$Q2c$X5),
            "incomplete",
            "na")
  
  dataValues$Q2c_incomplete <-
    ifelse("incomplete" %in% dataValues$Q2c$condition, 1, 2)
  
  # inconsistent responses
  dataValues$Q2c$inconsistency <-
    if_else((
      dataValues$Q2c$X4 == "Readers can never access the 'restricted' data" &
        dataValues$Q2c$X5 != "Readers can never access the 'restricted' data"
    ) |
      (
        dataValues$Q2c$X4 != "Readers can never access the 'restricted' data" &
          dataValues$Q2c$X5 == "Readers can never access the 'restricted' data"
      ),
    "inconsistent_never",
    if_else(
      dataValues$Q2c$X4 == "Request to ethics committee(s)" &
        dataValues$Q2c$X5 == "Shared unconditionally upon request to author(s)",
      "inconsistent_ethics",
      if_else(
        dataValues$Q2c$X4 == "Request or apply to external authority" &
          dataValues$Q2c$X5 == "Shared unconditionally upon request to author(s)",
        "inconsistent_external",
        "success"
      )
    )
    )
  
  dataValues$Q2c_inconsistent_never <-
    ifelse("inconsistent_never" %in% dataValues$Q2c$inconsistency, 1, 2)
  dataValues$Q2c_inconsistent_ethics <-
    ifelse("inconsistent_ethics" %in% dataValues$Q2c$inconsistency,
           1,
           2)
  dataValues$Q2c_inconsistent_external <-
    ifelse("inconsistent_external" %in% dataValues$Q2c$inconsistency,
           1,
           2)
  
  # 1. Incomplete section (empty table or missing responses)
  
  if (is.null(input$Q2c) | dataValues$Q2c_incomplete < 2) {
    dataValues$warning_incomplete_Q2c = 1
    dataValues$Q2c_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Incomplete section",
      text = "You have not completed this section (there are missing responses or unanswered questions).",
      type = "error"
    )
  } else if (!is.null(input$Q2c) & dataValues$Q2c_incomplete == 2) {
    dataValues$warning_incomplete_Q2c = 2
  }
  
  # 2. Inconsistent responses - never
  
  if (dataValues$Q2c_inconsistent_never == 1 &
      dataValues$warning_incomplete_Q2c == 2) {
    dataValues$Q2c_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that readers can never access the 'restricted' data but your other responses do not match -
      for example, you might have selected a route for restricted access.",
      type = "error"
    )
  }
  
  # 3. Inconsistent responses - ethics
  
  if (dataValues$Q2c_inconsistent_ethics == 1 &
      dataValues$Q2c_inconsistent_never == 2 &
      dataValues$warning_incomplete_Q2c == 2) {
    dataValues$Q2c_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that an approval is required by the ethics committee(s) but that the 'restricted' data can be shared *unconditionally* upon request to authors.
      Please revise your responses to ensure that a valid route for access and corresponding conditions are selected.",
      type = "error"
    )
  }
  
  # 4. Inconsistent responses - external
  
  if (dataValues$Q2c_inconsistent_external == 1 &
      dataValues$Q2c_inconsistent_ethics == 2 &
      dataValues$Q2c_inconsistent_never == 2 &
      dataValues$warning_incomplete_Q2c == 2) {
    dataValues$Q2c_complete = 0
    
    sendSweetAlert(
      session = session,
      title = "Inconsistent responses",
      text = "You have selected that an approval or application to an external authority is required but that the 'restricted' data can be shared *unconditionally* upon request to authors.
      Please revise your responses to ensure that a valid route for access and corresponding conditions are selected.",
      type = "error"
    )
  } else if (dataValues$Q2c_inconsistent_never == 2 &
             dataValues$Q2c_inconsistent_ethics == 2 &
             dataValues$Q2c_inconsistent_never == 2 &
             dataValues$warning_incomplete_Q2c == 2) {
    dataValues$Q2c_complete = 1
    fullReport$S2_complete = 1
    
    if (isTRUE(levels(as.factor(fullReport$S2_table1[[3]]))=="NO data")) {
      fullReport$S2_output = "D"
    } else {
      fullReport$S2_output = "C"
      
    }
    
    
    fullReport$S2_table2 <- dataValues$Q2c[1:5]
    names(fullReport$S2_table2) <- c(
      "Data category",
      "Data type",
      "Public availability",
      "Restricted access route",
      "Restricted access conditions"
    )
    
    # sendSweetAlert(
    #   session = session,
    #   title = "Section successfully completed!",
    #   # text = "All your responses are valid. You will now proceed to the next section.",
    #   html = TRUE,
    #   text = tagList(
    #     "Download your session responses to avoid potential data loss.",
    #     downloadBttn(
    #       outputId = "downloadRDS"
    #     )
    #   ),
    #   type = "success"
    # )
    dataValues$S2c_complete = 1
    
    if (fullReport$S2_output == "D") {
      fullReport$S2_table4 <- fullReport$S2_table2
      fullReport$S2_table4[, 3] <- fullReport$S2_table1[, 4]
    }
    updateTabsetPanel(session, "sidebar", selected = "code")
    
  }
  remove_modal_spinner()
  
})
