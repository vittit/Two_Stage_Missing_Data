library(shiny)
library(bslib)

# Define UI for application that draws a histogram
fluidPage( 
  # Theme
  theme = bs_theme(version = 5, preset = "flatly"),
    
  # Application title
  titlePanel(
    tags$div(
      tags$h1("Effect Sizes and Relative Importance with Item Level Missing Data"),
      style = "background-color: #2C3E50; color: white; padding: 10px;"
    )
  ),
            
  # Inputs 
  fluidRow(
    column(3,
      style = "margin-top: 25px;", 
  
  ## Data with missingness
  fileInput("Upload", label = tags$span(style = "font-weight: bold; font-size: 20px;", "Upload File with Missing Data", accept = ".csv")
        ),
  
          
  ## Items for Outcome Variable
  uiOutput("outcome_var"),
  
  ## Predictors 
  uiOutput("predictor_var"), 
  
    ),

  column(9,
    h5("Data Preview", style = "font-size: 20px"),
    tableOutput("Head"),
    )
  )
 )



