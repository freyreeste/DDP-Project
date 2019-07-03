library(shiny)
library(shinydashboard)
library(DT)
library(d3heatmap)
data(mtcars)

header <- dashboardHeader(title ="DDP - Final Proyect")

## Sidebar content
sidebar<-dashboardSidebar(
    sidebarMenu(
        menuItem("Table", tabName = "Table", icon = icon("th")),
        menuItem("Clusters", tabName = "Clusters", icon = icon("dashboard"))
                )
        )

## Body content
body<-dashboardBody(
    tabItems(
        # First tab content
        tabItem(tabName = "Table",
                fluidPage(
                    title = 'Data Table',
                    h3('Enter Filter Criteria'),
                    fluidRow(
                        column(6, DT::dataTableOutput('x1')),
                        column(6, plotOutput('x2', height = 500))
                    )
                )
        ),
    # Second tab content
        tabItem(tabName = "Clusters",
                fluidPage(
                    h3("Cars Heatmap"),
                    selectInput("palette", "Palette", c("YlOrRd", "RdYlBu", "Greens", "Blues")),
                    checkboxInput("cluster", "Apply clustering"),
                    d3heatmapOutput("heatmap")
                )
               )
    )            
)

ui<-dashboardPage(header, sidebar, body)
