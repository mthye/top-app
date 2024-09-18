
fluidPage(
  
  accordion(
    id = "startBox",
    accordionItem(
      title = HTML("<h5 style='color: white; '><b>Overview of Transparency Assessment</b></h5>"),
      status = "success",
      collapsed = FALSE,
      HTML("<h5 style>This app will guide you through a detailed assessment of your manuscript to ensure that it meets the Transparency and Openness criteria adopted by Cortex. 
          You can use the sidebar to navigate through the criteria but we highly recommend completing the sections in the designated order.<br><br>
          The app includes response checks in all sections so that potential errors and issues with your manuscript submission are prevented.
          <b>Please follow all instructions and warnings carefully</b> to ensure successful completion of your assessment.<br><br>
          After all sections are successfully completed, you can download your Transparency report in the <b>Generate Report</b> section.</h5>"),
      br(),
      HTML("<h5 style>You will need the following information to get started:<br>
           <li>List of all types of data used in the study</li> 
           <li>List of all types of research materials used in the study</li> 
           <li>Links to all publicly available resources (data, materials, code)</li> 
           <li>Study design details as they are presented in the manuscript</li> 
           </h5>"),
      br(),
      h5("Check out our ", actionLink("goFAQ", "FAQ & Tips", status = "primary", style="color: #fe9923"), "section for more information on the criteria."),
    )
  ),
  
  br(),
  
  # infoBox(
  #   title = HTML("<h5 style='color: white;'><b>Begin Assessment</b></h5>"),
  #   color = "primary", width = 12, elevation = 2, 
  #   value = HTML("<h5 style>Please read the overview information above before you begin.<br><br>
  #                 The session will time out after an hour, so remember to save your work periodically by clicking the <b>Save Progress</b> button at the top of the page.<br><br>
  #                 To start a new session and clear all responses, refresh your browser.<br>
  #                <br></h5>"),
  #   subtitle = actionButton("goData", "Start here", status = "primary", style="color: #fff; background-color: #fe9923; border-color: #f3f6f4;font-size: 20px"),
  # 
  #   icon = icon("circle-play", style="color: #fff"),
  #   tabName = "homeBox"
  # ),
  # 
  # br(),
  # 
  # infoBox(
  #   title = HTML("<h5 style='color: white;'><b>Restore Prior Session</b></h5>"),
  #   color = "fuchsia", width = 12, elevation = 2,
  #   #subtitle = fileInput("upload", "Upload an rds file"),
  #   subtitle = fileInput("loadData", "Upload an rds file", multiple = FALSE, accept = ".rds"),
  # 
  #   icon = icon("file-import", style="color: #fff"),
  #   tabName = "homeBox"
  # ),
  
  # Using fluidRow to arrange boxes side by side
  fluidRow(
    column(width = 6,
           infoBox(
             title = HTML("<h5 style='color: white;'><b>Begin Assessment</b></h5>"),
             color = "primary", width = NULL, elevation = 2, 
             value = HTML("<h5 style>Please read the overview information above before you begin.<br><br>
                        The session will time out after an hour, so remember to save your work periodically by clicking the <b>Save Progress</b> button at the top of the page.<br><br>
                        To start a new session and clear all responses, refresh your browser.<br>
                       <br></h5>"),
             subtitle = actionButton("goData", "Start Here", status = "primary", 
                                     style = "color: #fff; background-color: #fe9923; border-color: #f3f6f4; font-size: 20px"),
             icon = icon("circle-play", style = "color: #fff"),
             tabName = "homeBox"
           )
    ),
    column(width = 6,
           infoBox(
             title = HTML("<h5 style='color: white;'><b>Restore Prior Session</b></h5>"),
             color = "fuchsia", width = NULL, elevation = 2,
             subtitle = fileInput("loadData", "Upload an rds file", multiple = FALSE, accept = ".rds"),
             icon = icon("file-import", style = "color: #fff"),
             tabName = "homeBox"
           )
    )
  )
  
)
