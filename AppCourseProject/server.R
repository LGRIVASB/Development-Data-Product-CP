
library(shiny)
library(tidyverse)

shinyServer(function(input, output) {
    #Data Frame Exploration
    #Load Data selected dataset
    datasetInput <- eventReactive(input$update, {
        switch(input$dataset,
               "iris" = iris,
               "swiss" = swiss,
               "mtcars" = mtcars)
    }, ignoreNULL = FALSE)
    
    # Select HTML file
    datasetDesc <- eventReactive(input$update, {
        if(input$dataset == "iris"){
            includeHTML("iris.html")
        }else if(input$dataset == "swiss"){
            includeHTML("swiss.html")
        }else{
            includeHTML("mtcars.html")
        }
    }, ignoreNULL = FALSE)
    
    # HTML file
    output$htmlFile <- renderUI({datasetDesc()})
    
    # Generate a summary of the dataset
    output$summary <- renderPrint({
        dataset <- datasetInput()
        summary(dataset)
    })
    
    #Render the dataset table
    output$view <- renderTable({
        head(datasetInput(), n = isolate(input$obs))
    })
    #Plot Section
    
    #Predictive Variable
    output$predVariable <- reactiveUI(function() {
        # Get the data set with the appropriate name
        modelSet <- get(input$Modeldataset)
        colnames <- names(modelSet)
        selectInput("predColumns", "Select Predictive Variable",
                    choices = colnames,
                    selected = colnames[2])
    }) 
    
    #Outcome Variable
    output$outComeVariable <- reactiveUI(function() {
        # Get the data set with the appropriate name
        modelSet <- get(input$Modeldataset)
        colnames <- names(modelSet)
        selectInput("outColumns", "Select Outcome Variable",
                    choices = colnames)
    }) 
    
    
    #Regression outPut
    
    runRegression <- reactive({
        modelSet <- get(input$Modeldataset)
        
        lm(as.formula(paste0(input$outColumns,"~", input$predColumns)),data = modelSet)
    })
    
    output$model <- renderPrint({
        modelSet <- get(input$Modeldataset)
        modelSet <- as.data.frame(modelSet)
        if(is.factor(modelSet[, input$outColumns])){
            "The outcome variable is a factor, they cannot be entered into regression equation unless you transform it. Choice other variable"
        } else if(input$outColumns == input$predColumns){
            "The Independet variable and the dependet variable are the same. Try different variables."
        }else{
            summary(runRegression())
        }
    })
    
    #Coefficient
    output$coeff <- renderTable({
        modelSet <- get(input$Modeldataset)
        modelSet <- as.data.frame(modelSet)
        if(is.factor(modelSet[, input$outColumns])|input$outColumns == input$predColumns){
            print(data.frame(Oops = "Please select new Parameters."))
        }else{
            summary(runRegression())$coefficients
        }
    })
    #Plot
    output$modelPlot <- renderPlot({
        modelSet <- get(input$Modeldataset)
        modelSet <- as.data.frame(modelSet)
        ggplot(modelSet, aes(x = modelSet[, input$predColumns], y = modelSet[, input$outColumns])) +
            geom_point() +
            geom_smooth(method = "lm", col = "red") +
            labs(x = input$predColumns,
                 y = input$outColumns) +
            theme_bw()
    })
    
})
