observeEvent(input$sidebar, {
  if (input$sidebar == "results") {
    
    shinyjs::hide("generateReport")
    
    if (fullReport$S2_complete == 1) {
      fullReport$sections_complete = 1
    } else {
      fullReport$sections_complete = 0
    }
    
    if (fullReport$S2_complete == 1) {
      fullReport$S2_emoji = paste(emojifont::emoji("heavy_check_mark"), "Data Transparency")
    } else {
      fullReport$S2_emoji = paste(emojifont::emoji("x"), "Data Transparency")
    }
    
    if (fullReport$S3_complete == 1) {
      fullReport$S3_emoji = paste(emojifont::emoji("heavy_check_mark"), "Analytic Methods (Code) Transparency")
    } else {
      fullReport$S3_emoji = paste(emojifont::emoji("x"), "Analytic Methods (Code) Transparency")
    }
    
    if (fullReport$S4_complete == 1) {
      fullReport$S4_emoji = paste(emojifont::emoji("heavy_check_mark"), "Research Materials Transparency")
    } else {
      fullReport$S4_emoji = paste(emojifont::emoji("x"), "Research Materials Transparency")
    }
    
    if (fullReport$S5_complete == 1) {
      fullReport$S5_emoji = paste(emojifont::emoji("heavy_check_mark"), "Design and Analysis Transparency")
    } else {
      fullReport$S5_emoji = paste(emojifont::emoji("x"), "Design and Analysis Transparency")
    }
    
    if (fullReport$S6_complete == 1 & fullReport$S7_complete == 1) {
      fullReport$S6_emoji = paste(emojifont::emoji("heavy_check_mark"), "Preregistration")
    } else {
      fullReport$S6_emoji = paste(emojifont::emoji("x"), "Preregistration")
    }
    
    # If not completed send an error alert and present an empty UI
    if (fullReport$sections_complete == 0) {
      sendSweetAlert(
        session = session,
        title = "Incomplete sections",
        text = "It appears that you have not completed all the app sections.
                The report can only be generated when all TOP Standards have been assessed.",
        type = "error"
      )
      
      output$generateTOP <- renderUI({
        fluidPage(accordion(
          id = "TOPresults1",
          accordionItem(
            title = HTML("<h5 style='color: white;'><b>Scientific Transparency Report Files</b></h5>"),
            status = "success",
            collapsed = FALSE,
            HTML("<h5 style>Report generation requires successful completion of all app sections and the report cannot be created yet.<br><br>
            In this section, you can download a zipped file with your Scientific Transparency Statement and Report. Both of these files should be uploaded alongside your manuscript files.<br></h5>"),
            br(),
            br(),
            
            h6(fullReport$S1_emoji),
            h6(fullReport$S2_emoji),
            h6(fullReport$S3_emoji),
            h6(fullReport$S4_emoji),
            h6(fullReport$S5_emoji),
            h6(fullReport$S6_emoji),
            h6(fullReport$S7_emoji)
          )
        ))
      })
      
    } else {
      output$generateTOP <- renderUI({
        fluidPage(accordion(
          id = "TOPresults1",
          accordionItem(
            title = HTML("<h5 style='color: white;'>Scientific Transparency Report Files</h5>"),
            status = "purple",
            collapsed = FALSE,
            HTML("<h5 style>You have successfully completed all app sections.<br><br>
            In this section, you can download a zipped file with your Scientific Transparency Statement and Report. Both of these files should be uploaded alongside your manuscript files.<br></h5>"),
            br(),
            br(),
            
            h6(fullReport$S1_emoji),
            h6(fullReport$S2_emoji),
            h6(fullReport$S3_emoji),
            h6(fullReport$S4_emoji),
            h6(fullReport$S5_emoji),
            h6(fullReport$S6_emoji),
            h6(fullReport$S7_emoji),
            
            br(),
            br(),
            
            "Click below to generate the report based on your most recent responses.",
            br(),
            br(),
            actionButton(
              "generateReport",
              status = "danger",
              icon = shiny::icon("file-arrow-down"),
              label = "Create report",
              style = "color: #fff; background-color: #fe9923; border-color: #f3f6f4;font-size: 20px"
            )
          )
          
        ))
        
      })
    }
    
    if ("Yes" %in% isolate(fullReport$editor$Note)) {
      standards <- subset(isolate(fullReport$editor), Note == "Yes") %>% 
        mutate(Standard = case_when(Standard == "2" ~ "Data",
                                    Standard == "3" ~ "Analytic Methods (Code)",
                                    Standard == "4" ~ "Research Materials",
                                    Standard == "5" ~ "Design Transparency",
                                    Standard == "6" ~ "Pre-registration of Study Procedures",
                                    Standard == "7" ~ "Pre-registration of Analysis Plans"))
      sendSweetAlert(
        session = session,
        title = "Noncompliance",
        text = paste("The responses provided regarding", paste0(as.character(standards$Standard), collapse = " and ") ,"may not yet be compliant with the transparency guidelines. This is likely to result in delays and additional inquiries unless changes are made to the manuscript and/or the responses provided in the transparency assessment."),
        type = "warning"
      )
    }
    
    
  }
})

output$downloadReport <- downloadHandler(
  filename = function() {
    paste('Transparency_Report_Files-', input$ms_id, '-', Sys.Date(),'.zip', sep='')
    
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
      S2_output = fullReport$S2_output,
      
      Q3 = input$Q3,
      Q3a = input$Q3a,
      Q3b_eval = codeValues$codeYes,
      Q3b_input = codeValues$Q3b,
      Q3b_complete = codeValues$Q3b_complete,
      Q3b_partial = codeValues$Q3b_partialCode,
      Q3b_none = codeValues$Q3b_noneCode,
      Q3c_input = codeValues$Q3c,
      S3_output = fullReport$S3_output,
      
      Q4 = input$Q4,
      Q4a = input$Q4a,
      Q4b_eval = matsValues$matsYes,
      Q4b_input = matsValues$Q4b,
      Q4b_complete = matsValues$Q4b_complete,
      Q4b_partial = matsValues$Q4b_partialMats,
      Q4b_none = matsValues$Q4b_noneMats,
      Q4c_input = matsValues$Q4c,
      S4_output = fullReport$S4_output,
      
      Q5 = input$Q5,
      Q5_text = input$popupQ5,
      Q5_eval = desValues$Yes,
      S5_output = fullReport$S5_output,
      Q5_popup = input$popupQ5,
      
      Q6 = preregValues$Q6,
      Q6a =  preregValues$Q6a$URL,
      S6_output = fullReport$S6_output,
      S6_url = input$S6_url,
      Q7 = preregValues$Q7,
      Q7a =  preregValues$Q7a$URL,
      Q7b = preregValues$Q7b,
      Q7c = preregValues$Q7c,
      S7_url = input$S7_url,
      S7_output = fullReport$S7_output,
      Q7_popup = input$popupQ7c,
      
      editor = isolate(fullReport$editor)
    )
    
    # Copy the report file to a temporary directory before processing it, in
    # case we don't have write permissions to the current working dir (which
    # can happen when deployed).
    tempSupplement <- file.path(tempdir(), "generate_supplement.Rmd")
    tempStatement <- file.path(tempdir(), "generate_statement.Rmd")
    file.copy("generate_supplement.Rmd", tempSupplement, overwrite = TRUE)
    file.copy("generate_statement.Rmd", tempStatement, overwrite = TRUE)
    
    # Knit the document, passing in the `params` list, and eval it in a
    # child of the global environment (this isolates the code in the document
    # from the code in this app).
    pdf_file <- rmarkdown::render(tempSupplement, output_file = paste(input$ms_id, '-', Sys.Date(), '_Transparency_Report.pdf', sep=''),
                      params = params,
                      envir = new.env(parent = globalenv()))
    
    word_file <- rmarkdown::render(tempStatement, output_file = paste(input$ms_id, '-', Sys.Date(),'_Transparency_Statement.docx', sep=''),
                      params = params,
                      envir = new.env(parent = globalenv()))
    
    # zip the generated files
    zip(zipfile = file, files = c(pdf_file, word_file), flags = "-j", extras = NULL)
    
  },
  contentType="application/zip"
)

observeEvent(input$generateReport, {
  show_modal_spinner(spin = "orbit",
                     color = "purple",
                     text = "Checking your responses...")
  
  remove_modal_spinner()
  
  sendSweetAlert(
    session = session,
    title = "Success!",
    text = tagList(
      "Please download the zipped report file and save the current session to your computer.
      Upload both the Transparency Statement (docx file) and Transparency Report (pdf file) with your resubmission.
      You can restore and modify the current session using the session file in the event edits to the report are requested.",
      br(),
      br(),
      downloadBttn(outputId = "downloadReport",
                   label = "Download report",
                   color = "royal", icon = shiny::icon("file-arrow-down")),
      downloadBttn(outputId = "downloadData",
                   label = "Save session",
                   color = "warning", icon = shiny::icon("download"))
    ),
    type = "success"
  )
})
