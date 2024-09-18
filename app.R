#####
# Shiny app to asses TOP Compliance for newly accepted Cortex manuscripts
#
# library(rsconnect)
#rsconnect::setAccountInfo(name='cortex-top',
#                           token='',
#                           secret='')
# rsconnect::deployApp("P:/Editorial_Roles/Cortex/top-report/")
#
# redeploy:
# rsconnect::deployApp()
#
####


# R packages --------------------------------------------------------------

# Required for most UI and server functions
library(shiny)
library(bs4Dash)
library(rhandsontable)
library(shinyhelper)
library(shinybusy)
library(tools)
library(shinyjs)

# Required for response checks (e.g. urls)
library(RCurl)
library(sjmisc)
library(plyr)
library(dplyr)
library(httr)

# Required for compiling the TOP report
library(flextable)
library(officer)
library(rlang)

# Required for custom elements (ui & server)
library(fresh)
library(shinyWidgets)
library(emojifont)

# Required for RMarkdown session download
library(rmarkdown)
library(knitr)

# Main R files ------------------------------------------------------------

# Local (non-reactive) values
source("global/values.R")

# Other functions
source("global/other.R")

# Global server and ui
source("global/server.R")
source("global/ui.R")


# Run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server, enableBookmarking = "server") 
