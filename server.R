library(vroom)

shinyServer(function(input, output, session) {
  
  # Data upload and checks 
  data <- reactive({
    req(input$Upload)
    
    ext <- tools::file_ext(input$Upload$name)
    switch(ext,
           csv = vroom::vroom(input$Upload$datapath, delim = ","),
           validate("Invalid file; Please upload a .csv file")
    )
    
  })
  
  # Data Preview
  output$Head <- renderTable({
    head(data(), 5)
  })
  
  ## User input to select outcome variable
  output$outcome_var <- renderUI({
  req(data())
    selectInput(
      inputId = "outcome_variable",
      label = "Select Outcome Variable", 
      choices = names(data())
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

# Run the application 
shinyApp(ui = ui, server = server)