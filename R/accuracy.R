#' Calculate the Accuracy of the Model at Each Probability Cutoff
#'
#' only supports binary logistic regression at this time
#'
#' @param model regression model to be used
#' @param data training/testing data to use with model, MUST include all predictors in model
#' @param ind_column independent (outcome) variable column in data - please use data$column syntax
#' @param success character vector; how 'success' is coded in data
#' @param failure character vector; how 'failure' is coded in data
#' @param na.rm when T, only returns Probability Thresholds that have both 'correct' and 'incorrect' values
#'
#' @return data frame with % correct calls ('correct'), % incorrect calls ('incorrect') and the probability threshold
#' @export
#'
#' @examples
accuracy <- function(model, data, ind_column, success, failure, na.rm = T) {
    correct <- vector()
    incorrect <- vector()
    len <- seq(0, 1, by = 0.01)
    for(val in len) {
        probs <- stats::predict(model, data, type = "response")
        count <- data.frame(call = ifelse(probs > val, success, failure),
                            our_success = ind_column)
        TP <- count[stringr::str_detect(count$our_success, success) &
                        stringr::str_detect(count$call, success), ] %>%
            nrow()
        TN <- count[stringr::str_detect(count$our_success, failure) &
                        stringr::str_detect(count$call, failure), ] %>%
            nrow()
        corr <- ((TP + TN)/nrow(data)) * 100
        incorr <- 100 - corr
        correct <- c(correct, corr)
        incorrect <- c(incorrect, incorr)
    }
    final <- data.frame(correct = correct, incorrect = incorrect,
                        threshold = len)
    final
}
