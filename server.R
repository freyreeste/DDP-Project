server <- function(input, output) {
    # two columns of the mtcars data
    mtcars2 = mtcars[, c('hp', 'mpg')]
    
    # render the table (with row names)
    output$x1 = DT::renderDataTable(mtcars2, server = FALSE)
    
    # a scatterplot with certain points highlighted
    output$x2 = renderPlot({
        
        s1 = input$x1_rows_current  # rows on the current page
        s2 = input$x1_rows_all      # rows on all pages (after being filtered)
        
        par(mar = c(4, 4, 1, .1))
        plot(mtcars2, pch = 21)
        
        # solid dots (pch = 19) for current page
        if (length(s1)) {
            points(mtcars2[s1, , drop = FALSE], pch = 19, cex = 2)
        }
        
        # show red circles when performing searching
        if (length(s2) > 0 && length(s2) < nrow(mtcars2)) {
            points(mtcars2[s2, , drop = FALSE], pch = 21, cex = 3, col = 'red')
        }
        
        # dynamically change the legend text
        s = input$x1_search
        txt = if (is.null(s) || s == '') 'Filtered data' else {
            sprintf('Data matching "%s"', s)
        }
        
        legend(
            'topright', c('Original data', 'Data on current page', txt),
            pch = c(21, 19, 21), pt.cex = c(1, 2, 3), col = c(1, 1, 2),
            y.intersp = 2, bty = 'n'
              )
        })
    output$heatmap <- renderD3heatmap({
        d3heatmap(
            scale(mtcars),
            colors = input$palette,
            dendrogram = if (input$cluster) "both" else "none"
                )
            })        
            
}
        
shinyApp(ui,server)
