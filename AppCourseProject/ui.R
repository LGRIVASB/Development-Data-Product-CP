
library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Simple Linear Regression App"),
    navbarPage("Section",
               tabPanel("App Description",
                        mainPanel(
                            includeHTML("App.html"),
                        )
               ), 
               #First Tab    
               tabPanel("Data Exploration",
                        sidebarPanel(
                            selectInput("dataset", "Choose a dataset:",
                                        choices = c("iris", "swiss", "mtcars")),
                            numericInput("obs", "Number of observations to view:", 10),
                            actionButton("update", "View data")),
                        mainPanel(
                            h4("Information"),
                            htmlOutput("htmlFile"),
                            h4("Summary"),
                            verbatimTextOutput("summary"),
                            h4("Observations"),
                            tableOutput("view")
                        )
               ),
               #Second Tab
               tabPanel("Model Visualization",
                        sidebarPanel(
                            selectInput("Modeldataset", "Choose a dataset:",
                                        choices = c("iris", "swiss", "mtcars")),
                            uiOutput("predVariable"),
                            uiOutput("outComeVariable")
                        ),
                        mainPanel(
                            h4("Model Summary"),
                            verbatimTextOutput("model"),
                            h4("Model Coefficient"),
                            tableOutput("coeff"),
                            h4("Model Plot"),
                            plotOutput("modelPlot")
                        )
               )
    )
))
