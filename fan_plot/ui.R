library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("readable"), 

  # Application title
  titlePanel("Fan Plot"),
  
  fluidRow(
    column(3,
           numericInput("N",
                        label = h3("Total de elementos"),
                        value = NA,
                        min = 1,
                        max = 12,
                        step = 1)
    ),
    column(3,
           textInput("titulo",
                     label = h3("Plot Title"),
                     value = "Plot Title")
    ),
    column(3,
           selectInput("color",
                       label = h3("Colors set"),
                       choices = list("Greens" = "Greens",
                                      "Blues" = "Blues",
                                      "Oranges" = "Oranges",
                                      "Reds" = "Reds",
                                      "Purples" = "Purples",
                                      "Blue-Green" = "BuGn",
                                      "Blue-Purple" = "BuPu",
                                      "Yellow-Orange-Red" = "YlOrRd",
                                      "Yellow-Green-Blue" = "YlGnBu",
                                      "Red-Purple" = "RdPu",
                                      "Purple-Red" = "PuRd",
                                      "Purple-Blue-Green" = "PuBuGn"
                       ),
                       selected = "Greens")
           
    ),
    column(3,
           radioButtons("order", label = h3("Order"),
                        choices = list("None" = "No",
                                       "X variable" = "X",
                                       "Y variable" = "Y"),
                        selected = "No")
    )
  ),
  
  
  
  fluidRow(
    column(12,
           textOutput("footer")))
  
))
