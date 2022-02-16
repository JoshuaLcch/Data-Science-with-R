#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
shinyUI(fluidPage(theme = "my_style.css",
                  
                  tags$br(),
                  sidebarPanel(
                      width = 6,
                      tags$h1("University Admission", align="center"),
                      tags$h5("Input -1 to disable the attribute", align="center", style="font-weight:bold; color:red"),
                      numericInput("uni_rate", label = "University Rating (Range: 1~5)", value = -1, min = -1, max = 5, step = 1),
                      numericInput("GRE", label="GRE Score (Range: 0~340)", value = -1, min = -1, max = 340, step = 1),
                      numericInput("TOEFL", label="TOEFL Score (Range: 0~120)", value = -1, min = -1, max = 120, step = 1),
                      numericInput("SOP", label="Statement of Purpose (Range: 1~5)", value = -1, min = -1, max = 5, step = 0.5), 
                      numericInput("LOR", label="Letter of Recommendation (Range: 1~5)", value = -1, min = -1, max = 5, step = 0.5), 
                      numericInput("CGPA", label="CGPA (Range: 1~10)", value = -1, min = -1, max = 10, step = 0.01), 
                      sliderInput("research", label="Research Experience (0 or 1)", value = -1, min = -1, max = 1, step = 1),
                      tags$div(actionButton(inputId = "predict_btn", label = "Predict!"), align="right"),
                      ),
                  mainPanel(
                      width = 6,
                      uiOutput("result")
                  )
))