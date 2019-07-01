#' A user interface for interaction with model parameters and slider or tab options
#'
#' @param slider input data for responsive dashboard
#' @return a 'lm' object representing the linear model with the corresponding prediction for hp
#' @return a 'plot' object representing the two predictions for the different models
#' @return a 'plot' object highlighting the car model selected
#' @return a 'table' object with hp and mpg for the models shown in the rows.
#' @author Esteban R. Freyre
#' @details
#' Uses two regression models for horsepower (hp) prediction and interactive table for variable graphics.
#' In the sidebar panel there is a slider to choose the mpg of the car and then the graphic models will be updated accordingly.
#' #' The UI develops a dashboard interface screening two tabs:
#' One for model prediction comparisons and the other one for interactive table.
#' The second tab allows choosing the number of rows shown and there is a search space for filtering cars' models which
#' will be highlighted in the graph window.
#' @seealso \code{lm}
#' @export

library(shiny)
library(shinydashboard)
library(DT)
data(mtcars)

header <- dashboardHeader(title ="DDP - Cars Proyect")

## Sidebar content
sidebar<-dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "Dashboard", icon = icon("dashboard")),
    menuItem("Table", tabName = "Table", icon = icon("th")),
    sliderInput("sliderMPG", "Select the MPG of the car?", 10, 35, value = 20),
    checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
    checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE)
  )
)

## Body content
body<-dashboardBody(
  tabItems(
    # First tab content
    tabItem(tabName = "Dashboard",
            fluidRow(
              column(width = 11,
                     box(title = "HP vs MPG Models Forecasts",width = NULL, status = "primary",
                         plotOutput("plot1"),collapsible = TRUE)))
    ),

    # Second tab content
    tabItem(tabName = "Table",
            fluidPage(
              title = 'Data Table',
              h3('Enter Filter Criteria'),
              fluidRow(
                column(6, DT::dataTableOutput('x1')),
                column(6, plotOutput('x2', height = 500))
              )
            )
    )
  ))

ui<-dashboardPage(header, sidebar, body)
