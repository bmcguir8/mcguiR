#' Plot continuous predictors against the logit
#'
#' only supports binary logistic regression at this time
#'
#' @param model the model to use
#' @param data the data to use, MUST include all the predictors found in model
#' @return plot of predictors vs. logit
#' @export
#'
#' @importFrom ggplot2 facet_wrap
#' @examples
#' \dontrun{
#' iris2 <- iris[stringr::str_detect(Species, "setosa", negate = T), ]
#' irismodel <- glm(Species ~ ., data = iris2, family = binomial)
#' log_plot(irismodel, iris2)}
log_plot <- function(model, data) {
    pred <- stats::predict(model, data, type = "response")
    data <- dplyr::select_if(data, is.numeric)
    data <- dplyr::mutate(data, logit = log(pred/(1 - pred))) %>%
        tidyr::pivot_longer(!logit, names_to = "variables")

        ggplot2::ggplot(data, ggplot2::aes(logit, value)) +
            ggplot2::geom_point(size = 0.5, alpha = 0.5, color = "#9E0142") +
            ggplot2::facet_wrap(~variables, scales = "free_y") +
            ggplot2::labs(title = "Predictor Vs. Logit of Outcome") +
            ggplot2::ylab("Value") +
            ggplot2::xlab("Logit")
}

