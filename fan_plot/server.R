
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
  
  output$input_x <- renderUI({
    if(is.null(input$N) | is.na(input$N))
      return()
    
    N <- as.integer(input$N)
    lapply(1:N, function(i) {
      numericInput(paste0("x_", i),
                   paste0("X_", i),
                   value = 75,
                   min = 1,
                   max = 100,
                   step = 1
                   )
    })
  })
  
  output$input_y <- renderUI({
    if(is.null(input$N) | is.na(input$N))
      return()
    
    N <- as.integer(input$N)
    lapply(1:N, function(i) {
      numericInput(paste0("y_", i),
                   paste0("Y_", i),
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
  
  output$fanPlot <- renderPlot({
    if(is.null(input$N) | is.na(input$N))
      return()
    
    source("make_plot.R", encoding = 'UTF-8')
    
    N <- input$N
    # Necesitamos x, y, target,
    # Orden, Y_label, X_label, colores
    input_values <- reactiveValuesToList(input)
    x_index <- grep("x+", names(input_values), perl=TRUE)
    y_index <- grep("y+", names(input_values), perl=TRUE)
    x <- c()
    for (i in 1:length(x_index)){
      x <- c(x, input_values[[x_index[i]]])
    }
    y <- c()
    for (j in 1:length(y_index)){
      y <- c(y, input_values[[y_index[j]]])
    }
     
#     x <- c(0.98861, 0.952992, 0.894802, 0.604266, 0.598053, 0.535929, 0.39387, 0.225305)#Penetración
#     y <- c(100, 100, 138, 115, 99, 147, 101, 106)#Afinidad
     colores <- brewer.pal(max(length(x),3), input$color)
     titulo <- input$titulo
     orden <- input$order

     print_plot(titulo = titulo, x=x, y=y, orden = orden, colores=colores)

  })

})
