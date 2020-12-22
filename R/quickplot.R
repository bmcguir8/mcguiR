#' Plot Samples by their Predicted Probabilites
#'
#' only supports binary logistic regression at this time.
#'
#' @param model model to be used
#' @param data testing/training/validation data set, MUST have all the predictors in the model
#' @param ind_column independent (outcome) variable column in dataset - please use data$column syntax
#' @param title title for the plot
#'
#' @return a plot
#' @export
#'
#' @examples
#' \dontrun{
#' iris2 <- iris[stringr::str_detect(Species, "setosa", negate = T), ]
#' irismodel <- glm(Species ~ ., data = iris2, family = binomial)
#' quickplot(irismodel, iris2, iris2$Species, "Plot")}
quickplot <- function(model, data, ind_column, title) {
    pred <- data.frame(pred = stats::predict(model, data, type = "response"),
                       Success = ind_column) %>%
        dplyr::arrange(pred) %>%
        dplyr::mutate(rank = 1:nrow(data))

    ggplot2::ggplot(data = pred, ggplot2::aes(x = rank, y = pred, color = Success)) +
        ggplot2::geom_point() + ggplot2::scale_color_manual(values = c("#D53E4F", "#66C2A5")) +
        ggplot2::ylab("Probability of 'Success'") + ggplot2::xlab(ggplot2::element_blank()) +
        ggplot2::labs(title = title)
}
