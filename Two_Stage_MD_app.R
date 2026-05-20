library(shiny)
library(bslib)
library(vroom)
library(shinydashboard)
library(DT)

# Define UI
ui <-  dashboardPage( 
    
  # Application title
    dashboardHeader(title = "Missing Data"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("File Input", tabName = "start", icon = icon("folder")),
        menuItem("Results", tabName = "start", icon = icon("folder"))
      )
    ),
    
dashboardBody(
  tabItems(
    
  # Inputs
    tabItem(tabName = "start",
      fluidRow(
            box(
              width = 4, status = "primary",
              title = "1. Upload Data", solidHeader = TRUE,
              column(12,

       ## Data with missingness
       fileInput("Upload", label = tags$span(style = "font-weight: bold; font-size: 20px;", "Upload File with Missing Data", accept = ".csv")
       )
      )
    ),
       
       ## Items for Outcome Variable
       box(
           width = 4, status = "primary",
           title = "2. Select Variables", solidHeader = TRUE,
           uiOutput("outcome_var"),
           uiOutput("predictor_var"),
           actionButton("submit", "Submit Selections")
       ),
      
     ## Missing Data Indicator
      box(
        width = 4, status = "primary",
        title = "3. Missing Data Indicator", solidHeader = TRUE,
        radioButtons("miss_ind", "Select Missing Data Indicator",
          choices = c("NA", "NULL", "(Blank)", "-999"),
          selected = "NA"),
        actionButton("submit", "Submit Selection")
    ),
       
      ## Data Preview
      box(
        width = 12, status = "primary",
        title = "Data Preview", solidHeader = TRUE,
        column(12,
                dataTableOutput("Head"), style = "overflow-x: scroll;"
               )
      )
     )
    )
   )
  )
 )

  



server <- shinyServer(function(input, output, session) {
  
  # Data upload and checks 
  data <- reactive({
    req(input$Upload)
    ext <- tools::file_ext(input$Upload$name)
    switch(ext,
           csv = vroom::vroom(input$Upload$datapath, delim = ","),
           validate("Invalid file; Please upload a .csv file")
    )
    read.csv(input$Upload$datapath)  
    
  })
  
  # Data Preview
  output$Head <- DT::renderDataTable({
  data()
  })
  
  ## User input to select outcome variable
  output$outcome_var <- renderUI({
    req(data())
    selectInput(
      inputId = "outcome_variable",
      label = "Select Outcome Variable", 
      choices = names(data()),
      selected = NULL
    )
  })
  
  ## User input to select predictor variables
  output$predictor_var <- renderUI({
    req(input$outcome_variable)
    selectInput(
      inputId = "predictor_variables",
      label = "Select Predictor Variables", 
      
      ### Do not allow outcome to be selected as a predictor
      choices = setdiff(names(data()), input$outcome_variable),
      multiple = TRUE
    )
  })
}

)

# Run
shinyApp(ui = ui, server = server)

