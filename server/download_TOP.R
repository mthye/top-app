observeEvent(input$sidebar, {
  if (input$sidebar == "results") {
    
    shinyjs::hide("generateReport")
    # if (fullReport$S2_complete == 1 & fullReport$S3_complete == 1 &
    #    fullReport$S4_complete == 1 & fullReport$S5_complete == 1 & fullReport$S6_complete == 1 & fullReport$S7_complete == 1) {
    #    fullReport$sections_complete = 1
    #  } else {
    #   fullReport$sections_complete = 0
    #  }
    
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
            title = HTML("<h5 style='color: white;'><b>Transparency Assessment Report</b></h5>"),
            status = "success",
            collapsed = FALSE,
            "In this section you can generate and download a report with your Transparency Assessment.",
            "Report generation requires successful completion of all app sections and the report cannot be created yet.",
            
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
            title = HTML("<h5 style='color: white;'>Transparency Assessment Report</h5>"),
            status = "purple",
            collapsed = FALSE,
            "In this section you can generate and download a report with your Transparency Assessment.",
            "You have successfully completed all app sections. ",
            "The Transparency Statement will be appended to your article, please make sure your article does not contain additional sections that will duplicate this material",
            
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
    
  }
})

output$downloadReport <- downloadHandler(
  filename = function() {
    #paste("TOP-report-", Sys.Date(), ".docx", sep = "")
    #paste('Transparency_Report-', input$ms_id, '-', Sys.Date(),'.docx', sep='')
    paste('Transparency_Report-', input$ms_id, '-', Sys.Date(),'.pdf', sep='')
    
  },
  content = function(file) {
    #print(fullReport$doc, target = file)
    
    #params <- list(fullReport, dataValues, codeValues, matsValues, preregValues)
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
      Q7_popup = input$popupQ7c
    )
    
    # Copy the report file to a temporary directory before processing it, in
    # case we don't have write permissions to the current working dir (which
    # can happen when deployed).
    tempReport <- file.path(tempdir(), "app_session.Rmd")
    file.copy("app_session.Rmd", tempReport, overwrite = TRUE)
    
    # Knit the document, passing in the `params` list, and eval it in a
    # child of the global environment (this isolates the code in the document
    # from the code in this app).
    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv()))
    
    
  },
)

observeEvent(input$generateReport, {
  show_modal_spinner(spin = "orbit",
                     color = "purple",
                     text = "Checking your responses...")
  
  #doc <- read_docx("TOP-report.docx")
  
  #Note to Editor
  #editor <- isolate(fullReport$editor)
  
  # Try to put in reverse order so that when you add to statement we add standard 2 last and it appears first
  
  # #Standard 7
  # if (fullReport$S7_output == "A") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(
  #       "• No part of the analysis plans was pre-registered in a time-stamped, institutional registry prior to the research being conducted."
  #     )
  # }
  # 
  # if (fullReport$S7_output == "B") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(
  #       paste0(
  #         "• At least part of the analysis plans was pre-registered in a time-stamped, institutional registry prior to the research being conducted. ",
  #         "Analysis plans were preregistered at: ",
  #        trimws(fullReport$S7_url), ". There were no deviations from the preregistered analyses."
  #       ) 
  #     )
  # }
  # 
  # if (fullReport$S7_output == "C") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(
  #       paste0(
  #         "• At least part of the analysis plans was pre-registered in a time-stamped, institutional registry prior to the research being conducted. ",
  #         "Analysis plans were preregistered at: ",
  #         trimws(fullReport$S7_url),
  #         ". The analyses that were undertaken deviated from the preregistered analysis plans. All such deviations are fully disclosed in the manuscript."
  #       )
  #     ) 
  # }
  # 
  # if (fullReport$S7_output == "D") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(
  #       paste0(
  #         "At least part of the analysis plans was pre-registered in a time-stamped, institutional registry prior to the research being conducted. ",
  #         "Analysis plans were preregistered at: ",
  #         trimws(fullReport$S7_url),
  #         ". The analyses that were undertaken deviated from the preregistered analysis plans. These deviations are not fully disclosed in the manuscript."
  #       )
  #     ) 
  # }
  # 
  # #Standard 6
  # if (fullReport$S6_output == "A") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(
  #       "• No part of the study procedures was pre-registered in a time-stamped, institutional registry prior to the research being conducted."
  #     )
  # }
  # 
  # # if (fullReport$S6_output == "B") {
  # #   doc %>% cursor_reach(keyword = "Statement") %>%
  # #     body_add_par(
  # #       paste0(
  # #         "• At least part of the study procedures was pre-registered in a time-stamped, institutional registry prior to the research being conducted. ",
  # #         "Study procedures were preregistered at: ",
  # #         trimws(fullReport$S6_url), ". There were no deviations from the preregistered study procedures."
  # #       ) 
  # #     )
  # # }
  # # 
  # # if (fullReport$S6_output == "C") {
  # #   doc %>% cursor_reach(keyword = "Statement") %>%
  # #     body_add_par(
  # #       paste0(
  # #         "• At least part of the study procedures was pre-registered in a time-stamped, institutional registry prior to the research being conducted. ",
  # #         "Study procedures were preregistered at: ",
  # #         trimws(fullReport$S6_url),
  # #         ". The actual study procedures deviated from the preregistered protocol. All such deviations are fully disclosed in the manuscript."
  # #       )
  # #     ) 
  # # }
  # # 
  # # 
  # # if (fullReport$S6_output == "D") {
  # #   doc %>% cursor_reach(keyword = "Statement") %>%
  # #     body_add_par(
  # #       paste0(
  # #         "• At least part of the study procedures was pre-registered in a time-stamped, institutional registry prior to the research being conducted. ",
  # #         "Study procedures were preregistered at: ",
  # #         trimws(fullReport$S6_url),
  # #         ". The actual study procedures deviated from the preregistered protocol. These deviations are not fully disclosed in the manuscript."
  # #       )
  # #     )
  # # }
  # 
  # #Standard 5
  # if (desValues$Q5==1) {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(paste0("• This article reports, for all studies, how the author(s) determined all sample sizes, ",
  #                         "all data exclusions, all data inclusion/exclusion criteria, whether inclusion/exclusion criteria were established prior to data analysis, ",
  #                         "all manipulations, and all measures."))
  # } else if (fullReport$S5_output == "A") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par("• The manuscript does not report any data presentation or analysis of any kind.")
  # } else {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(fullReport$Standard5)
  # }
  #   
  # #Standard 4
  # if (fullReport$S4_output == "A" | fullReport$S4_output == "B") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par("• This research did not make use of any materials to generate or acquire data." )
  # }
  # 
  # if (fullReport$S4_output == "C") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par("• All study materials supporting this research are publicly available. See TOP Guidelines Assessment in Supplementary Information for details." )
  # }  
  # 
  # if (fullReport$S4_output == "D") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(paste0("• Some study materials supporting this research are publicly available, while some are subject to TOP-compliant restrictions. ",
  #                         "See TOP Guidelines Assessment in Supplementary Information for full details and conditions of access.") )
  # }  
  # 
  # if (fullReport$S4_output == "E") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(paste0("• No study materials supporting this research are publicly available. ",
  #                         "See TOP Guidelines Assessment in Supplementary Information for full details and conditions of access.") )
  # }  
  # 
  # #Standard 3
  # if (fullReport$S3_output == "A") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par("• This research did not make use of any analysis code." )
  # }
  # 
  # if (fullReport$S3_output == "B") {
  #   dput("read")
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par("• All analysis code supporting this research is publicly available. See TOP Guidelines Assessment in Supplementary Information for details." )
  # }  
  # 
  # if (fullReport$S3_output == "C") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(paste0("• Some analysis code supporting this research is publicly available, while some is subject to TOP-compliant restrictions. ",
  #                         "See TOP Guidelines Assessment in Supplementary Information for full details and conditions of access.") )
  # }  
  # 
  # if (fullReport$S3_output == "D") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(paste0("• No analysis code supporting this research is publicly available. ",
  #                         "See TOP Guidelines Assessment in Supplementary Information for full details and conditions of access.") )
  # }  
  # 
  # #Standard 2
  # if (fullReport$S2_output == "A") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par("• This research did not involve collection or analysis of data." )
  # }
  # 
  # if (fullReport$S2_output == "B") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(paste0("• All raw and processed data supporting this research are publicly available. ",
  #                         "See TOP Guidelines Assessment in Supplementary Information for details.") )
  # }  
  # 
  # if (fullReport$S2_output == "C") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(paste0("• Some raw and processed data supporting this research are publicly available, while some are subject to TOP-compliant restrictions. ",
  #                         "See TOP Guidelines Assessment in Supplementary Information for full details and conditions of access.") )
  # }  
  # 
  # if (fullReport$S2_output == "D") {
  #   doc %>% cursor_reach(keyword = "Statement") %>%
  #     body_add_par(paste0("• No raw or processed data supporting this research are publicly available.", 
  #                         "See TOP Guidelines Assessment in Supplementary Information for full details and conditions of access.") )
  # }  
  # 
  # # Full report
  # if ("Yes" %in% editor$Note) {
  #   standards <- subset(editor, editor$Note == "Yes")
  #   
  #   if (nrow(standards) < 2) {
  #     note = paste("Responses in Standard",
  #                  standards$Standard,
  #                  "are not yet compliant with Level 2 TOP guidelines.")
  #   } else {
  #     note = paste(
  #       "Responses in Standards",
  #       paste0(as.character(standards$Standard), collapse = ", "),
  #       "are not yet compliant with Level 2 TOP guidelines."
  #     )
  #   }
  #   doc %>% cursor_reach(keyword = "Standard #1") %>%
  #     cursor_backward() %>%
  #     body_add_par("Note to Author(s): Please do not delete or alter any red text appearing below.") %>%
  #     body_add_par("Responses require additional editorial assessment.",
  #                  style = "Quote") %>%
  #     body_add_par(note, style = "Quote")
  # }
  # 
  # # #Standard 1
  # # if (fullReport$S1_output == "A") {
  # #   doc %>% cursor_reach(keyword = "Citations") %>%
  # #     body_add_par(
  # #       "In addition to meeting conventional citation standards for published articles, where applicable, any references to published data sets, program code, or other methods are cited in the manuscript."
  # #     )
  # # }
  # # 
  # # if (fullReport$S1_output == "B") {
  # #   doc %>% cursor_reach(keyword = "Citations") %>%
  # #     body_add_par(
  # #       "In addition to meeting conventional citation standards for published articles, the manuscript does not require citations for any other methods (e.g. published data sets, program code)."
  # #     )
  # # }
  # 
  # #Standard 2
  # if (fullReport$S2_output == "A") {
  #   doc %>% cursor_reach(keyword = "Data Transparency") %>%
  #     body_add_par("The manuscript does not report any data analyses.")
  # }
  # 
  # if (fullReport$S2_output == "B") {
  #   doc %>% cursor_reach(keyword = "Data Transparency") %>%
  #     body_add_par(
  #       "In this table authors indicate the access route(s) for all data categories that will be fully shared. All data will be publicly available and no barriers have been reported."
  #     ) %>%
  #     #  If you want to add a line break between the text and the table you can just add
  #     #  an empty paragraph (see removed code line below); same will need to be copied across the script
  #     # body_add_par("") %>%
  #     body_add_table(
  #       fullReport$S2_table3,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     )
  # }
  # 
  # if (fullReport$S2_output == "C") {
  #   doc %>% cursor_reach(keyword = "Data Transparency") %>%
  #     body_add_par(
  #       "In this table authors indicate the public availability and access route(s) for all selected data categories as well as any barriers for data that cannot be fully shared."
  #     ) %>%
  #     body_add_table(
  #       fullReport$S2_table1,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     ) %>%
  #     body_add_par(
  #       "In this table authors explain how readers can access the data that are not publicly available and under what conditions."
  #     ) %>%
  #     body_add_table(
  #       fullReport$S2_table2,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     )
  # }
  # 
  # 
  # if (fullReport$S2_output == "D") {
  #   doc %>% cursor_reach(keyword = "Data Transparency") %>%
  #     body_add_par(
  #       "In this table authors explain how readers can access the data that are not publicly available and under what conditions. No data will be publicly available."
  #     ) %>%
  #     body_add_table(
  #       fullReport$S2_table4,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     )
  # }
  # 
  # #Standard 3
  # if (fullReport$S3_output == "A") {
  #   doc %>% cursor_reach(keyword = "Methods Transparency") %>%
  #     body_add_par("The manuscript does not report any data analyses undertaken using code or scripts.")
  # }
  # 
  # if (fullReport$S3_output == "B") {
  #   doc %>% cursor_reach(keyword = "Methods Transparency") %>%
  #     body_add_par(
  #       "In this table authors indicate the access route(s) for all types of analysis code that will be fully shared. All code will be publicly available and no barriers have been reported."
  #     ) %>%
  #     body_add_table(
  #       fullReport$S3_table3,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     )
  # }
  # 
  # if (fullReport$S3_output == "C") {
  #   doc %>% cursor_reach(keyword = "Methods Transparency") %>%
  #     body_add_par(
  #       "In this table authors indicate the public availability and access route(s) for all selected analysis code types as well as any barriers for code that cannot be fully shared."
  #     ) %>%
  #     body_add_table(
  #       fullReport$S3_table1,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     ) %>%
  #     body_add_par(
  #       "In this table authors explain how readers can access the analysis code that is not publicly available and under what conditions."
  #     ) %>%
  #     body_add_table(
  #       fullReport$S3_table2,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     )
  # }
  # 
  # if (fullReport$S3_output == "D") {
  #   doc %>% cursor_reach(keyword = "Methods Transparency") %>%
  #     body_add_par(
  #       "In this table authors explain how readers can access the analysis code that is not publicly available and under what conditions. No code will be publicly available."
  #     ) %>%
  #     body_add_table(
  #       fullReport$S3_table4,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     )
  # }
  # 
  # #Standard 4
  # if (fullReport$S4_output == "A") {
  #   doc %>% cursor_reach(keyword = "Materials Transparency") %>%
  #     body_add_par("The manuscript does not report data analysis of any kind.")
  # }
  # 
  # if (fullReport$S4_output == "B") {
  #   doc %>% cursor_reach(keyword = "Materials Transparency") %>%
  #     body_add_par(
  #       "The manuscript only reports analysis of data that already existed prior to the research being undertaken."
  #     )
  # }
  # 
  # if (fullReport$S4_output == "C") {
  #   doc %>% cursor_reach(keyword = "Materials Transparency") %>%
  #     body_add_par(
  #       "In this table authors indicate the access route(s) for all types of research materials that will be fully shared. All materials will be publicly available and no barriers have been reported."
  #     ) %>%
  #     body_add_table(
  #       fullReport$S4_table3,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     )
  # }
  # 
  # if (fullReport$S4_output == "D") {
  #   doc %>% cursor_reach(keyword = "Materials Transparency") %>%
  #     body_add_par(
  #       "In this table authors indicate the public availability and access route(s) for all selected types of research materials as well as any barriers for materials that cannot be fully shared."
  #     ) %>%
  #     body_add_table(
  #       fullReport$S4_table1,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     ) %>%
  #     body_add_par(
  #       "In this table authors explain how readers can access the research materials that are not publicly available and under what conditions."
  #     ) %>%
  #     body_add_table(
  #       fullReport$S4_table2,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     )
  # }
  # 
  # if (fullReport$S4_output == "E") {
  #   doc %>% cursor_reach(keyword = "Materials Transparency") %>%
  #     body_add_par(
  #       "In this table authors explain how readers can access the research materials that are not publicly available and under what conditions. No materials will be publicly available."
  #     ) %>%
  #     body_add_table(
  #       fullReport$S4_table4,
  #       style = "List Table 3",
  #       alignment = "l",
  #       align_table = "left"
  #     )
  # }
  # 
  # #Standard 5
  # 
  # if (fullReport$S5_output == "A") {
  #   doc %>% cursor_reach(keyword = "Analysis Transparency") %>%
  #     body_add_par("The manuscript does not report any data presentation or analysis of any kind.")
  # }
  # 
  # if (fullReport$S5_output == "B") {
  #   doc %>% cursor_reach(keyword = "Analysis Transparency") %>%
  #     body_add_par(fullReport$Standard5B) %>%
  #     body_add_par(fullReport$Standard5C) %>%
  #     body_add_par(fullReport$Standard5D) %>%
  #     body_add_par(fullReport$Standard5E) %>%
  #     body_add_par(fullReport$Standard5F1) %>%
  #     body_add_par(fullReport$Standard5F2) %>%
  #     body_add_par(fullReport$Standard5F3)
  # }
  # 
  # #Standard 6
  # if (fullReport$S6_output == "A") {
  #   doc %>% cursor_reach(keyword = "Study Preregistration") %>%
  #     body_add_par(
  #       "No part of the study procedures was pre-registered in a time-stamped, institutional registry prior to the research being conducted."
  #     )
  # }
  # 
  # # if (fullReport$S6_output == "B") {
  # #   doc %>% cursor_reach(keyword = "Study Preregistration") %>%
  # #     body_add_par(
  # #       paste0(
  # #         "At least part of the study procedures was pre-registered in a time-stamped, institutional registry prior to the research being conducted. ",
  # #         "Study procedures were preregistered at: ",
  # #         trimws(fullReport$S6_url),
  # #         ". There were no deviations from the preregistered study procedures."
  # #       )
  # #     )
  # # }
  # # 
  # # if (fullReport$S6_output == "C") {
  # #   doc %>% cursor_reach(keyword = "Study Preregistration") %>%
  # #     body_add_par(
  # #       paste0(
  # #         "At least part of the study procedures was pre-registered in a time-stamped, institutional registry prior to the research being conducted. ",
  # #         "Study procedures were preregistered at: ",
  # #         trimws(fullReport$S6_url),
  # #         ". The actual study procedures deviated from the preregistered protocol. All such deviations are fully disclosed in the manuscript."
  # #       )
  # #     )
  # # }
  # # 
  # # if (fullReport$S6_output == "D") {
  # #   doc %>% cursor_reach(keyword = "Study Preregistration") %>%
  # #     body_add_par(
  # #       paste0(
  # #         "At least part of the study procedures was pre-registered in a time-stamped, institutional registry prior to the research being conducted. ",
  # #         "Study procedures were preregistered at: ",
  # #         trimws(fullReport$S6_url),
  # #         ". The actual study procedures deviated from the preregistered protocol. These deviations are not fully disclosed. The authors have provided the following explanation: ",
  # #         fullReport$S6_explain
  # #         
  # #       )
  # #     )
  # # }
  # 
  # #Standard 7
  # if (fullReport$S7_output == "A") {
  #   doc %>% cursor_reach(keyword = "Study Preregistration") %>%
  #     body_add_par(
  #       "No part of the analysis plans was pre-registered in a time-stamped, institutional registry prior to the research being conducted."
  #     )
  # }
  # 
  # if (fullReport$S7_output == "B") {
  #   doc %>% cursor_reach(keyword = "Study Preregistration") %>%
  #     body_add_par(
  #       paste(
  #         "At least part of the analysis plans was pre-registered in a time-stamped, institutional registry prior to the research being conducted.",
  #         "Analysis plans were preregistered at:",
  #         fullReport$S7_url
  #       )
  #     ) %>%
  #     body_add_par("There were no deviations from the preregistered analyses.")
  # }
  # 
  # if (fullReport$S7_output == "C") {
  #   doc %>% cursor_reach(keyword = "Study Preregistration") %>%
  #     body_add_par(
  #       paste(
  #         "At least part of the analysis plans was pre-registered in a time-stamped, institutional registry prior to the research being conducted.",
  #         "Analysis plans were preregistered at:",
  #         fullReport$S7_url
  #       )
  #     ) %>%
  #     body_add_par(
  #       "The analyses that were undertaken deviated from the preregistered analysis plans. All such deviations are fully disclosed in the manuscript."
  #     )
  # }
  # 
  # if (fullReport$S7_output == "D") {
  #   doc %>% cursor_reach(keyword = "Study Preregistration") %>%
  #     body_add_par(
  #       paste(
  #         "At least part of the analysis plans was pre-registered in a time-stamped, institutional registry prior to the research being conducted.",
  #         "Analysis plans were preregistered at:",
  #         fullReport$S7_url
  #       )
  #     ) %>%
  #     body_add_par(
  #       paste(
  #         "The analyses that were undertaken deviated from the preregistered analysis plans. These deviations are not fully disclosed. The authors have provided the following explanation:",
  #         fullReport$S7_explain
  #       )
  #     )
  # }
  # 
  # #Save file in the reactive value for downloadHandler
  # fullReport$doc <- doc
  
  remove_modal_spinner()
  
  sendSweetAlert(
    session = session,
    title = "Success!",
    text = tagList(
      "The report has been created successfully.
      Please download the report file and save the current session to your computer. 
      Upload the Transparency Report PDF with your resubmission. 
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
