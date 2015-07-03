library(shiny)
suppressPackageStartupMessages(library('quantmod'))

stock.env <- new.env()

#attachSymbols(prefix = "T.")

today = as.Date(Sys.Date())

stk_plot = function(ticker,period,tas){
    if(!exists(ticker,envir = stock.env)){
        try_imp <- try(getSymbols(ticker,src="yahoo",env = stock.env))
        if(is(try_imp,"try-error")){
            cust_err <<- 1
            return(1)
        }
    }
    
    #period
    subset = paste0(as.character(today-PERIOD[PERIOD$show==period,2]),'/')
    if(subset == 'all') subset=NULL
    
    #TAs
    ta_cmd = TAS[match(tas,TAS[[1]]),2]
    ta_cmd = paste(ta_cmd,collapse = ";")
    
    chartSeries(stock.env[[ticker]],subset = subset,theme='white',multi.col = T,name=ticker,
                TA = ta_cmd)
}


#=== server code ===#

shinyServer(function(input, output,session) {
    curr_choice_1 <- c()    #record the string of the current stock for panel 1
    curr_choice_2 <- c()    #record the string of the current stock for panel 2
    
    #file upload
    getData <- reactive({
        infile = input$stocklistfile
        if(is.null(infile)) return(NULL)
        tmp <- read.csv(infile$datapath,header = F,stringsAsFactors=F)
        tmp <- as.list(unique(sort(unlist(tmp))))
        names(tmp) = NULL
        tmp
    })
    
    output$fileUploaded <- reactive({
        return(!is.null(getData()))
    })
    
    outputOptions(output, 'fileUploaded', suspendWhenHidden=FALSE)
    
    
    #control panel 1
    observe({
        watch = getData()
        curr_choice_1 <<- watch[[1]]
        updateSelectInput(session, "myStock1",choices = watch, selected = watch[[1]])
    })
    
    observe({
        watch = getData()
        if(input$prev1!=0){    #action button dependency
            idx_curr_choice_1 = which(curr_choice_1==watch)    #the index of the current choice
            if(idx_curr_choice_1>1){
                curr_choice_1 <<- watch[[idx_curr_choice_1-1]]
                updateSelectInput(session, "myStock1",selected=curr_choice_1)
            }
        }
    })
    
    observe({
        watch = getData()
        if(input$nxt1!=0){    #action button dependency
            idx_curr_choice_1 = which(curr_choice_1==watch)    #the index of the current choice
            if(idx_curr_choice_1<length(watch)){
                curr_choice_1 <<- watch[[idx_curr_choice_1+1]]
                updateSelectInput(session, "myStock1",selected=curr_choice_1)
            }
        }
    })
  
    
    #control panel 2
    observe({
        watch = getData()
        curr_choice_2 <<- watch[[1]]
        updateSelectInput(session, "myStock2",choices = watch, selected = watch[[1]])
    })
    
    observe({
        watch = getData()
        if(input$prev2!=0){    #action button dependency
            idx_curr_choice_2 = which(curr_choice_2==watch)    #the index of the current choice
            if(idx_curr_choice_2>1){
                curr_choice_2 <<- watch[[idx_curr_choice_2-1]]
                updateSelectInput(session, "myStock2",selected=curr_choice_2)
            }
        }
    })
    
    observe({
        watch = getData()
        if(input$nxt2!=0){    #action button dependency
            idx_curr_choice_2 = which(curr_choice_2==watch)    #the index of the current choice
            if(idx_curr_choice_2<length(watch)){
                curr_choice_2 <<- watch[[idx_curr_choice_2+1]]
                updateSelectInput(session, "myStock2",selected=curr_choice_2)
            }
        }
    })


    #plots    
    output$chart1 <- renderPlot({
        if(!is.null(getData())){
            curr_choice_1 <<- input$myStock1
            stk_plot(input$myStock1,input$period,input$tas)
        }
    })

    output$chart2 <- renderPlot({
        if(!is.null(getData())){
            curr_choice_2 <<- input$myStock2
            stk_plot(input$myStock2,input$period,input$tas)
        }
    })

#     output$chart2 <- renderPlot({
#         if(input$submit > 0){
#             isolate(plot_err <- myplot(input$custStock,"custom"))
#             if(plot_err==1){
#                 output$custMsg <- renderText({"No such stock!"})
#             }else{
#                 output$custMsg <- renderText({"Click button to submit"})
#             }
#         }else{
#             output$custMsg <- renderText({"Click button to submit"})
#         }
#     })
# 
# #     output$custMsg <- renderText({
# #         if(cust_err == 0){
# #             "Click button to submit"
# #         }else{
# #             "No such stock!"
# #         }
# #     })
#     

})
