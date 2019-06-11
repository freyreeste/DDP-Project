library(shiny)
library(flexdashboard)
library(dygraphs)

shinyUI(fluidPage(
  titlePanel("Predict Horsepower from MPG"),
  sidebarLayout(
    sidebarPanel(
      # br() element to introduce extra vertical spacing ----
      br(),
      sliderInput("sliderMPG", "What is the MPG of the car?", 10, 35, value = 20),
      checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
      checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE),
      
      numericInput("months", label = "Months to Predict", 
                   value = 72, min = 12, max = 144, step = 12),
      selectInput("interval", label = "Prediction Interval",
                  choices = c("0.80", "0.90", "0.95", "0.99"),
                  selected = "0.95"),
      checkboxInput("showgrid", label = "Show Grid", value = TRUE)
    ),
    mainPanel(
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("plot")),
                  tabPanel("Heatmap", verbatimTextOutput("heatmap")),
                  tabPanel("Table", tableOutput("table"))
      ),
      
      plotOutput("plot1"),
      h3("Predicted Horsepower from Model 1:"),
      textOutput("pred1"),
      h3("Predicted Horsepower from Model 2:"),
      textOutput("pred2"),
      
      dygraphOutput("dygraph"),
      
      highchartOutput("highchart"),
      
      title = 'DataTables Information',
      h1('Interactive Table'),
      fluidRow(
        column(6, DT::dataTableOutput('x1')),
        column(6, plotOutput('x2', height = 500))
      )
    )
  )
))