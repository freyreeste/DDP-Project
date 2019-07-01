#' A server function for input and output of user interface interaction
#'
#' @importFrom stats lm
#' @importFrom stats predict
#' @param mpg a numeric vector x as predicor of hp
#' @param mpgsp a numeric vector x as predictor of hp
#' @param hp representing the response y
#' @export
#' @param input info for object rendering
#' @param output for responsive rendering

server <- function(input, output) {
  mtcars$mpgsp <- ifelse(mtcars$mpg - 20 > 0, mtcars$mpg - 20, 0)
  model1 <- lm(hp ~ mpg, data = mtcars)
  model2 <- lm(hp ~ mpgsp + mpg, data = mtcars)

  model1pred <- reactive({
    mpgInput <- input$sliderMPG
    predict(model1, newdata = data.frame(mpg = mpgInput))
  })

  model2pred <- reactive({
    mpgInput <- input$sliderMPG
    predict(model2, newdata =
              data.frame(mpg = mpgInput,
                         mpgsp = ifelse(mpgInput - 20 > 0,
                                        mpgInput - 20, 0)))
  })

  output$plot1 <- renderPlot({
    mpgInput <- input$sliderMPG

    plot(mtcars$mpg, mtcars$hp, xlab = "Miles Per Gallon",
         ylab = "Horsepower", bty = "n", pch = 16,
         xlim = c(10, 35), ylim = c(50, 350))
    if(input$showModel1){
      abline(model1, col = "green", lwd = 2)
    }
    if(input$showModel2){
      model2lines <- predict(model2, newdata = data.frame(
        mpg = 10:35, mpgsp = ifelse(10:35 - 20 > 0, 10:35 - 20, 0)
      ))
      lines(10:35, model2lines, col = "orange", lwd = 2)
    }
    legend(25, 250, c("Model 1 Prediction", "Model 2 Prediction"), pch = 16,
           col = c("green", "orange"), bty = "n", cex = 1.2)
    points(mpgInput, model1pred(), col = "green", pch = 16, cex = 2)
    points(mpgInput, model2pred(), col = "orange", pch = 16, cex = 2)
  })

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
}
