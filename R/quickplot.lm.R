#' Plot the True Values vs. the Predicted Values
#'
#' @param model the model to be used
#' @param data the data to be fed into the model - MUST include all the predictors
#' in the model
#' @param ind_column independent (outcome) variable column in dataset - please use data$column syntax
#'
#' @return plot
#' @export
#'
#' @examples
#' \dontrun{
#' model <- lm(Petal.Length ~ ., data = iris)
#' quickplot.lm(model, iris, iris$Petal.Length)}
quickplot.lm <- function(model, data, ind_column) {
    pred <- stats::predict(model, data)
    dat <- data.frame(n = 1:nrow(data), ind_column, pred) %>%
        tidyr::pivot_longer(-n)

    ggplot2::ggplot(data = dat, ggplot2::aes(x = n, y = value, color = name)) +
        ggplot2::geom_line() +
        ggplot2::xlab(ggplot2::element_blank()) +
        ggplot2::ylab("Value") +
        ggplot2::labs(title = "True Vs. Predicted Values") +
        ggplot2::scale_color_discrete(name = "Value",
                                      labels = c("True", "Predicted"))
}
