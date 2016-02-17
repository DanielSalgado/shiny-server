
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(RColorBrewer)
library(rootSolve)
source("make_plot.R", encoding = 'UTF-8')

shinyServer(function(input, output) {
  
  output$input_x <- renderUI({
    N <- get_N()
    lapply(1:N, function(i) {
      numericInput(paste0("x_", i),
                   i,
                   value = 75,
                   min = 1,
                   max = 100,
                   step = 1
                   )
    })
  })
  
  output$input_y <- renderUI({
    N <- get_N()
    lapply(1:N, function(i) {
      numericInput(paste0("y_", i),
                   i,
                   value = 100,
                   min = 1,
                   max = 120,
                   step = 1
      )
    })
  })

  output$footer <- renderText({
    N <- input$N
    
    expr <- unlist( reactiveValuesToList(input))
    
  })
  
  get_x <- reactive({
    N <- get_N()
    input_values <- reactiveValuesToList(input)
    x_index <- grep("x+", names(input_values), perl = TRUE)
    if(length(x_index) > 0){
      x <- c()
      for (i in 1:N){
        x <- c(x, input_values[[x_index[i]]])
      }
      return(x)
    } else {
      return(c(.90, .90, .90))
    }
  })
  
  get_y <- reactive({
    N <- get_N()
    input_values <- reactiveValuesToList(input)
    y_index <- grep("y+", names(input_values), perl = TRUE)
    if(length(y_index) > 0){
      y <- c()
      for(j in 1:N){
        y <- c(y, input_values[[y_index[j]]])
      }
      return(y)
    } else {
      return(c(100, 100, 100))
    }
  })
  
  get_colors <- reactive({
    return(brewer.pal(input$N, input$color))
  })
  
  get_N <- reactive({
    if(is.null(input$N) | is.na(input$N)){
      return(3)
    } else {
      return(input$N)
    }
  })
  
  get_title <- reactive({
    return(input$titulo)
  })
  
  get_base <- reactive({
    return(input$X_label)
  })
  
  get_height <- reactive({
    return(input$Y_label)
  })
  
  get_orden <- reactive({
    return(input$order)
  })
  
  output$fanPlot <- renderPlot({
    print_plot(titulo = get_title(), 
               x=get_x(),
               y=get_y(),
               orden = get_orden(),
               colores = get_colors(),
               Y_label = get_height(),
               X_label = get_base())
    
  })
})
