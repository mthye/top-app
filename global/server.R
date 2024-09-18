server <- function(input, output, session) {
  
  # Increase the limit for file uploads
  options(shiny.maxRequestSize = 10000 * 1024 ^ 2)
  
# Reactive values ---------------------------------------------------------
  
  dataValues <- reactiveValues(
    ID = "",
    Q1 = "",
    Q2 = "",
    S2a_complete = 0,
    S2b_complete = 0,
    S2c_complete = 0,
    dataYes = 0,
    dataTypes = dataTypes,
    saveQ2b = NULL,
    saveQ2c = NULL,
    selectedDataTypes = NULL,
    Q2b_incomplete = 0,
    Q2b_urlmiss = 0,
    Q2b_manuscript = 0,
    Q2b_invalid_url = 0,
    Q2b_urls = "",
    Q2b_invalid_barrier = 0,
    Q2b_inconsistent_all = 0,
    Q2b_inconsistent_no = 0,
    Q2b_inconsistent_some = 0,
    Q2b_complete = 0,
    Q2b_partialData = 0,
    Q2b_noneData = 0,
    Q2c_incomplete = 0,
    Q2d_incomplete = 0,
    Q2c_complete = 0,
    Q2d_complete = 0,
    warning_incomplete_Q2b = 0,
    warning_incomplete_Q2c = 0,
    warning_manuscript = 0,
    warning_invalid_barrier = 0,
    section_complete = 0
  )
  
  # Reactive values used in analytic standard
  
  codeValues <- reactiveValues(
    Q3 = "",
    S3a_complete = 0,
    S3b_complete = 0,
    S3c_complete = 0,
    
    codeYes = 0,
    selectedCodeTypes = NULL,
    Q3b = NULL,
    codeTypes = codeTypes,
    saveQ3b = NULL,
    saveQ3c = NULL,
    Q3b_incomplete = 0,
    Q3b_urlmiss = 0,
    Q3b_manuscript = 0,
    Q3b_invalid_url = 0,
    Q3b_urls = "",
    Q3b_invalid_barrier = 0,
    Q3b_inconsistent_all = 0,
    Q3b_inconsistent_no = 0,
    Q3b_inconsistent_some = 0,
    Q3b_complete = 0,
    Q3b_partialCode = 0,
    Q3b_noneCode = 0,
    Q3c_incomplete = 0,
    Q3c_complete = 0,
    warning_incomplete_Q3b = 0,
    warning_incomplete_Q3c = 0,
    warning_manuscript = 0,
    warning_invalid_barrier = 0,
    section_complete = 0
  )
  
  # Reactive values used in methods standard
  
  matsValues <- reactiveValues(
    Q4 = "",
    S4a_complete = 0,
    S4b_complete = 0,
    S4c_complete = 0,
    matsYes = 0,
    selectedMatsTypes = NULL,
    Q4b = NULL,
    saveQ4b = NULL,
    saveQ4c = NULL,
    matsTypes = matsTypes,
    Q4b_incomplete = 0,
    Q4b_urlmiss = 0,
    Q4b_manuscript = 0,
    Q4b_invalid_url = 0,
    Q4b_urls = "",
    Q4b_invalid_barrier = 0,
    Q4b_inconsistent_all = 0,
    Q4b_inconsistent_no = 0,
    Q4b_inconsistent_some = 0,
    Q4b_complete = 0,
    Q4b_partialMats = 0,
    Q4b_noneMats = 0,
    Q4c_incomplete = 0, 
    Q4c_complete = 0,
    warning_incomplete_Q4b = 0,
    warning_incomplete_Q4c = 0,
    warning_manuscript = 0,
    warning_invalid_barrier = 0,
    section_complete = 0
  )
  
  # Reactive values used in design standard
  
  desValues <- reactiveValues(
    Q5 = "",
    Q5a = "",
    Q5a2 = "",
    Q5b = "",
    Q5b2 = "",
    Q5c = "",
    Q5c2 = "",
    Q5d = "",
    Q5d2 = "",
    Q5e = "",
    Q5e2 = "",
    Q5e3 = "",
    Q5f = "",
    Q5f2 = "",
    Q5f3 = "",
    Q5f4 = "",
    Q5f5 = "",
    
    desYes = 0,
    no1 = "",
    no2 = "",
    no3 = "",
    no4 = "",
    
    Q5_complete = 0,
    Q5a_complete = 0,
    Q5a2_complete = 0,
    
    Q5b_complete = 0,
    Q5b2_complete = 0,
    Q5c_complete = 0,
    Q5c2_complete = 0,
    
    Q5d_complete = 0,
    Q5d2_complete = 0,
    
    Q5e_complete = 0,
    Q5e2_complete = 0,
    Q5e3_complete = 0,
    
    Q5f_complete = 0,
    Q5f2_complete = 0,
    Q5f3_complete = 0,
    Q5f4_complete = 0,
    Q5f5_complete = 0,
    
    sampleSizeStatus = 0,
    manipulationStatus = 0,
    measureStatus = 0,
    inclusionCriteriaStatus = 0,
    inclusionPriorStatus = 0,
    exclusionCriteriaStatus = 0,
    dataExclusions = 0,
    exclusionCriteriaStatus = 0,
    exclusionPriorStatus = 0,
    
    YesQ5 = 0,
    YesQ5a = 0,
    YesQ5a2 = 0,
    
    YesQ5b = 0,
    YesQ5b2 = 0,
    
    YesQ5c = 0,
    YesQ5c2 = 0,
    
    YesQ5d = 0,
    YesQ5d2 = 0,
    
    YesQ5e = 0,
    YesQ5e2 = 0,
    YesQ5e3 = 0,
    
    YesQ5f = 0,
    YesQ5f2 = 0,
    YesQ5f3 = 0,
    YesQ5f4 = 0,
    YesQ5f5 = 0
  )
  
  # Reactive values used in prereg standard
  
  preregValues <- reactiveValues(
    studyYes = 0,
    analysisYes = 0,
    Q6a = NULL,
    Q7a = NULL,
    studyDevs = 0,
    analysisDevs = 0,
    studyRep = 0,
    analysisRep = 0,
    
    Q6_complete = 0,
    Q6b_complete = 0,
    Q6c_complete = 0,
    
    Q6 = "",
    Q6b = "",
    Q7_complete = 0,
    Q7b_complete = 0,
    Q7c_complete = 0,
    Q7 = "",
    Q7b = "",
    Q7c = ""
  )
  
  # Reactive values for TOP report compilation
  
  doc <- reactiveValues()
  
  # report <- read_docx("TOP-report.docx") 
  # new_styles <- read.csv("new_styles.csv")
  # report$styles <- new_styles
  
  notes <- data.frame(matrix(ncol=2, nrow=7))
  names(notes) <- c("Standard", "Note")
  notes$Standard <- 1:nrow(notes)
  
  fullReport <- reactiveValues(
    #template = read_docx("TOP-report.docx"),
    #doc = report, 
    editor = notes,
    S1_complete = 0,
    S2_complete = 0,
    S3_complete = 0,
    S4_complete = 0,
    S5_complete = 0,
    S6_complete = 0,
    S7_complete = 0,
    sections_complete = 0,
    
    S2_table1 = NULL,
    S2_table2 = NULL,
    S2_table3 = NULL,
    S2_table4 = NULL,
    
    S3_table1 = NULL,
    S3_table2 = NULL,
    S3_table3 = NULL,
    S3_table4 = NULL,
    
    S4_table1 = NULL,
    S4_table2 = NULL,
    S4_table3 = NULL,
    S4_table4 = NULL, 
    
    S1_output = "",
    S2_output = "",
    S3_output = "",
    S4_output = "",
    
    S5_output = "",
    
    S6_output = "",
    S6_url = "",
    S6_explain = "",
    
    S7_output = "",
    S7_url = "",
    S7_explain = "",
    
    standard5A = "This section has not been completed.",
    standard5B = " ",
    standard5C = " ",
    standard5D = " ",
    standard5E = " ",
    standard5F1 = " ",
    standard5F2 = " ",
    standard5F3 = " ",
    
    standard6A = "This section has not been completed.",
    standard6B = " ",
    
    standard7A = "This section has not been completed.",
    standard7B = " "
  )
  
  # Source all server files -------------------------------------------------
  
  # Server script for data standard
  source(file.path("server", "data_server.R"), local = TRUE)$value
  
  # Server script for code standard
  source(file.path("server", "code_server.R"), local = TRUE)$value
  
  # Server script for methods standard
  source(file.path("server", "materials_server.R"), local = TRUE)$value
  
  # Server script for design standard
  source(file.path("server", "design_server.R"), local = TRUE)$value 
  
  # Server script for prereg standard
  source(file.path("server", "prereg_server.R"), local = TRUE)$value

  # Server script for TOP report
  source(file.path("server", "download_TOP.R"), local = TRUE)$value
  
  # Redirecting links -------------------------------------------------------
  
  observeEvent(input$goFAQ, {
    updateTabsetPanel(session, "sidebar", selected = "resources")
  })
  
  observeEvent(input$goData, {
    updateTabsetPanel(session, "sidebar", selected = "data")
  })
  
  # Data download function --------------------------------------------------
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste('Transparency_Session-', input$ms_id, '-', Sys.Date(),'.rds', sep='')
    },
    content = function(file) {
      
      # Set up parameters to pass to Rmd document
      params <- list(
        ms_id = input$ms_id,
        Q2 = input$Q2,
        Q2a = input$Q2a,
        Q2b_eval = dataValues$dataYes,
        Q2b_input = dataValues$Q2b,
        Q2b_complete = dataValues$Q2b_complete,
        Q2b_partial = dataValues$Q2b_partialData,
        Q2b_none = dataValues$Q2b_noneData,
        Q2c_input = dataValues$Q2c,
        selectedDataTypes = dataValues$selectedDataTypes,
        
        Q3 = input$Q3,
        Q3a = input$Q3a,
        Q3b_eval = codeValues$codeYes,
        Q3b_input = codeValues$Q3b,
        Q3b_complete = codeValues$Q3b_complete,
        Q3b_partial = codeValues$Q3b_partialCode,
        Q3b_none = codeValues$Q3b_noneCode,
        Q3c_input = codeValues$Q3c,
        selectedCodeTypes = codeValues$selectedCodeTypes,
        
        Q4 = input$Q4,
        Q4a = input$Q4a,
        Q4b_eval = matsValues$matsYes,
        Q4b_input = matsValues$Q4b,
        Q4b_complete = matsValues$Q4b_complete,
        Q4b_partial = matsValues$Q4b_partialMats,
        Q4b_none = matsValues$Q4b_noneMats,
        Q4c_input = matsValues$Q4c,
        selectedMatsTypes = matsValues$selectedMatsTypes,
        
        Q5 = input$Q5,
        Q5_text = input$popupQ5,
        Q5_eval = desValues$Yes,
        
        Q6 = preregValues$Q6,
        Q7 = preregValues$Q7,
        Q7b = preregValues$Q7b,
        Q7c = preregValues$Q7c
      )
      
      #saveRDS(reactiveValuesToList(input), file)
      saveRDS(params, file)
    }
  )
  
  observeEvent(input$loadData, {
    
    params <- readRDS(input$loadData$datapath)
    
    observe({
      # data
      dataValues$ID <- params$ms_id
      dataValues$Q1 <- params$Q1
      dataValues$Q2 <- params$Q2
      dataValues$dataTypes <- params$dataTypes
      dataValues$selectedDataTypes <- params$selectedDataTypes
      dataValues$Q2b <- params$Q2b_input
      dataValues$Q2c <- params$Q2c_input
      dataValues$saveQ2b <- 1
      dataValues$saveQ2c <- 1
      
      # code
      codeValues$Q3 <- params$Q3
      codeValues$Q3a <- params$Q3a # code types
      codeValues$selectedCodeTypes <- params$selectedCodeTypes
      codeValues$Q3b <- params$Q3b_input
      codeValues$Q3c <- params$Q3c_input
      codeValues$saveQ3b <- 1
      codeValues$saveQ3c <- 1
      
      # materials
      matsValues$Q4 <- params$Q4
      #matsValues$Q4a <- input$Q4a # material types
      matsValues$selectedMatsTypes <- params$selectedMatsTypes
      matsValues$Q4b <- params$Q4b_input
      matsValues$Q4c <- params$Q4c_input
      matsValues$saveQ4b <- 1
      matsValues$saveQ4c <- 1
      
      # design
      desValues$Q5 <- params$Q5
      
      # prereg
      preregValues$Q6 <- params$Q6
      preregValues$Q7 <- params$Q7
      preregValues$Q7b <- params$Q7b
      preregValues$Q7c <- params$Q7c
      
    })
    
    observe({
      req(params)
      updateTextAreaInput(session, "ms_id",
                          value = paste(isolate(dataValues$ID))
      )
    })
    
    # observe({
    #   req(params)
    #   updatePickerInput(session, "Q6", selected = paste(isolate(preregValues$Q6))
    #   )
    # })
    
    updateTabsetPanel(session, "sidebar", selected = "data")
  })
  
}

actionBttn(
  inputId = "Id109",
  label = NULL,
  style = "simple", 
  color = "primary",
  icon = icon("bars")
) 
