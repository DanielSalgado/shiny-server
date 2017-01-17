library(shiny)
library(shinythemes)

shinyUI(fluidPage( theme = shinytheme("cerulean"),                   
                   titlePanel("Fan Plot"),
                   wellPanel(fluidRow(
                     column(3,
                            h4("Input Size"),
                            sliderInput("N",
                                        label = "",
                                        value = NA,
                                        min = 3,
                                        max = 9,
                                        step = 1)
                     ),
                     column(3,
                            h4("Plot Title"),
                            textInput("titulo",
                                      label = "",
                                      value = "Plot Title")
                     ),
                     column(3,
                            h4("Color Scheme"),
                            selectInput("color",
                                        label = "",
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
                            h4("Order"),
                            radioButtons("order", 
                                         label = "",
                                         choices = list("None" = "No",
                                                        "bases" = "bases",
                                                        "heights" = "alturas"),
                                         selected = "No")
                     )
                   )),
                   wellPanel(fluidRow(
                     
                     column(2, align = "center",
                            h4("Triangle base"),
                            textInput("base_label",
                                      label = "",
                                      value  = "Variable name"),
                            wellPanel(
                              uiOutput("input_x"))),
                     column(2, align = "center",
                            h4("Triangle height"),
                            textInput("height_label",
                                      label = "",
                                      value  = "Variable name"),
                            wellPanel(
                              uiOutput("input_y"))),
                     column(8, align = "center",
                            plotOutput("fanPlot"))
                     
                   ))
                   ,
                   
                   fluidRow(
                     wellPanel(
                       column(12,
                              textOutput("footer")))
                   )
                   
))