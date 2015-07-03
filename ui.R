library(shiny)


shinyUI(fluidPage(

    # Application title
    titlePanel("US Stocks"),

    fluidRow(
        column(2,
               wellPanel(
                   fileInput(
                       'stocklistfile', 'Upload stock list',
                       accept = c(
                           'text/csv',
                           'text/comma-separated-values',
                           'text/tab-separated-values',
                           'text/plain',
                           '.csv'
                       )
                   )
               ),
        
               conditionalPanel(
                   condition = "output.fileUploaded",
                   
                   wellPanel(
                       radioButtons("numPlot",label = "Plot",
                                    choices = c("Single","Comparison"),
                                    selected = "Single"
                       )
                   )
               ),
               
               conditionalPanel(
                   condition = "output.fileUploaded",
                   
                   wellPanel(
                       selectInput("myStock1", label = "Stock list 1", 
                                   choices = NULL),
                       
                       fluidRow(
                           column(1,actionButton("prev1", label = "Previous")),
                           column(1,actionButton("nxt1", label = "Next"),offset=4)
                       )
                   )
               ),
               
               conditionalPanel(
                   condition = "output.fileUploaded & input.numPlot=='Comparison'",
                   
                   wellPanel(
                       selectInput("myStock2", label = "Stock list 2", 
                                   choices = NULL),
                       
                       fluidRow(
                           column(1,actionButton("prev2", label = "Previous")),
                           column(1,actionButton("nxt2", label = "Next"),offset=4)
                       )
                   )
               )
        ),

        
        # TA control
        
        conditionalPanel(
            condition = "output.fileUploaded",
            column(2,
                   wellPanel(
                       radioButtons("period",label = "Selected period",
                                    choices = PERIOD[[1]],
                                    selected = 'last 3 months'),
                       
                       checkboxGroupInput("tas", label = "TAs",choices = TAS[[1]],
                                          selected = TAS[[1]])
                   )
            )
        ),

        
        # Show a plot of stock
                
        conditionalPanel(
            condition = "output.fileUploaded",
            column(8,tabsetPanel(
                tabPanel("Stock 1", plotOutput("chart1",height = "600")),
                tabPanel("Stock 2", conditionalPanel(condition = "input.numPlot=='Comparison'",
                                                         plotOutput("chart2",height = "600")))
                )
            )
        )
    
    )
))
