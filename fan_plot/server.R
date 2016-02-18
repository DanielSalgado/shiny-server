library(shiny)
library(RColorBrewer)
library(rootSolve)
source("make_plot2.R", encoding = 'UTF-8')

shinyServer(function(input, output) {
  
  # To test the input values.
  output$footer <- renderText({
    N <- input$N
    
    expr <- unlist( reactiveValuesToList(input))
    
  })
  
  # Reactive ui, prints input for x
  output$input_x <- renderUI({
    N <- input$N
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
  
  # Reactive ui, prints input for y
  output$input_y <- renderUI({
    N <- input$N
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
  
  # Reactive function, gets x values.
  get_x <- reactive({
    N <- input$N
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
  
  # Reactive function, gets y values.
  get_y <- reactive({
    N <- input$N
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
  
  # Gets bases and heights in a df
  modify_input <- reactive({
    df <- get_height_and_bases(get_x(), get_y())
    return(df)
  })
  
  # Orders the bases and heights in a df
  final_index <- reactive({
    df <- modify_input()
    index <- orderInput(df$bases, df$alturas, input$order)
    return(index)
  })
  
  # Draws the fan plot
  output$fanPlot <- renderPlot({
    base_plot(input$base_label, input$height_label, input$titulo)
    index <- final_index()
    df <- modify_input()
    df <- df[index, ]
    colores <- brewer.pal(length(index), input$color)[index]
    plot_triangles(df$bases, df$alturas, colores)
    plot_axes(max_base = max(get_x()), max_altura = max(get_y()), cat_max = max(df$bases) )
  })
})
