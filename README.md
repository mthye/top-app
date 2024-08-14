# Transparency and Openness Promotion App

The initial version of this app was developed by Loukia Tzavella.

## app.R

The main file for running the shiny app with required R packages, sourced main files and command for running the app.

All the other files with the shiny code and relevant R code are included in three folders, which include primary files for the shiny app server and ui as well as server and ui files that correspond to specific transparency standards (i.e., app sections):

### global 

server. R and ui.R: main files that are read by app.R file to compile the shiny app
other.R: other independent custom R functions that are saved here to save space 
values.R: editable content for interactive tables (dropdowns) and other elements in the app

### server 

The server code for the transparency standards has been split into different files. These are sourced in the 
main server file; example command from the script:   
source(file.path("server", "data_server.R"), local = TRUE)$value

data_server.R
code_server.R
materials_server.R
design_server.R
prereg_server.R
download_TOP.R

### ui

Consistent with the R code for the server functions, the ui code for the transparency standards is also split 
into separate files and we also have a ui file for the Home section and the FAQ section.

home_ui.R
data_ui.R
code_ui.R
materials_ui.R
design_ui.R
prereg_ui.R
faq_ui.R

## rsconnect

This folder is automatically generated when the app is deployed using the rsconnect package.

## app_session.Rmd

Markdown document used to generate the transparency report.
