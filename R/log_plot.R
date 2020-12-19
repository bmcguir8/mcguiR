#' Plot continuous predictors against the logit
#'
#' @param model the model to use
#' @param data the data to use, MUST include all the predictors found in model
#' @return plot of predictors vs. logit
#' @export
#'
#' @examples
log_plot <- function(model, data) {
    pred <- stats::predict(model, data, type = "response")
    data <- dplyr::select_if(data, is.numeric)
    data <- dplyr::mutate(data, logit = log(pred/(1 - pred))) %>%
        tidyr::pivot_longer(!logit, names_to = "variables")

        ggplot2::ggplot(data, ggplot2::aes(logit, value)) +
            ggplot2::geom_point(size = 0.5, alpha = 0.5, color = "#9E0142") +
            facet_wrap(~variables, scales = "free_y") +
            ggplot2::labs(title = "Predictor Vs. Logit of Outcome") +
            ggplot2::ylab("Value") +
            ggplot2::xlab("Logit")
}

