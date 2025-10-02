#############################
## Two Stage Missing Data ###
#############################

library(shiny)
library(bslib)

# Define UI for application that draws a histogram
ui <- navbarPage( 
  # Theme
  theme = bs_theme(version = 5, bootswatch = "cerulean"),
 
  # Application title
  title = ("Computing Effect Sizes and Relative Importance with Item Level Missing Data"),
  
  # Inputs 
  sidebarLayout(
    sidebarPanel(
      style = "margin-top: 25px;", 
  
  ## Data with missingness
  fileInput("Upload", label = tags$span(style = "font-weight: bold;", "Upload File with Missing Data", accept = ".csv"))
    ),
  
  
  ## Outcome Variables

  ## Items for Outcome Variable

  ## Predictors 

  mainPanel(
    h5("Data Preview"),
    tableOutput("Head"),
    )
  )
 )


# Define server logic 
server <- function(input, output, session) {
  data <- reactive({
    req(input$Upload)
    
    ext <- tools::file_ext(input$Upload$name)
    switch(ext,
           csv = vroom::vroom(input$Upload$datapath, delim = ","),
           validate("Invalid file; Please upload a .csv file")
    )
  })
  
  output$Head <- renderTable({
    head(data(), 5)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
