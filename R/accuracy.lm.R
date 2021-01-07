#' Determine Accuracy of Linear Models (via differences between actual and
#' predicted values)
#'
#' Returns either a data frame of the actual value, the predicted value from the model,
#' and the difference between the two OR a plot showing the distribution of differences
#'
#' @param model model to be examined
#' @param data data to be used in model - MUST include all predictors found in model
#' @param ind_column independent (outcome) variable column in data - please use data$column syntax
#' @param round number of digits the predicted value to be rounded to
#' @param output default is output = "data", which returns a data frame.  setting this
#' to "plot" will plot the distribution of differences
#'
#' @return data frame or plot
#' @export
#'
#' @examples
#' \dontrun{
#' model <- lm(Petal.Length ~ ., data = iris)
#' accuracy.lm(model, iris, iris$Petal.Length, round = 2, output = "plot")}
accuracy.lm <- function(model, data, ind_column, round = 2, output = "data") {
    pred <- stats::predict(model, data) %>% round(digits = round)
    dat <- data.frame(ind_column, pred) %>% dplyr::mutate(diff = ind_column - pred)
    g <- ggplot2::ggplot(data = dat, ggplot2::aes(x = dat[,3])) +
            ggplot2::geom_bar(stat = "bin", fill = "light blue", bins = 30,
                              color = "black") +
            ggplot2::xlab("Actual Value - Predicted Value") +
            ggplot2::ylab("Count") +
            ggplot2::labs(title = "Distribution of Differences between Actual and Predicted Values")
    if(output == "data") {
    return(dat)
        }
    if(output == "plot") {
    return(g)
        }
}
