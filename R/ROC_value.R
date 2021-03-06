#' Calculate TPR and FPR at Each Probability Threshold
#'
#' Only supports binary logistic regression at this time
#'
#' @param model regression model to be used
#' @param data training/testing data to use with model, MUST include all predictors in model
#' @param ind_column independent (outcome) variable column in dataset - please use data$column syntax
#' @param success character vector; how 'success' is coded in data
#' @param failure character vector; how 'failure' is coded in data
#' @param na.rm when T, only returns probability thresholds that have values for both 'TPR' and 'FPR' values
#'
#' @importFrom stats predict
#' @return data frame with TPR, FPR and Probability Threshold columns
#' @export
#'
#' @examples
#' \dontrun{
#' iris2 <- iris[stringr::str_detect(Species, "setosa", negate = T), ]
#' irismodel <- glm(Species ~ ., data = iris2, family = binomial)
#' roc_value <- ROC_value(irismodel, iris2, iris2$Species, "virginica",
#' "versicolor")}
ROC_value <- function(model, data, ind_column, success, failure, na.rm = T) {
    true <- vector()
    false <- vector()
    len <- seq(from = 0, to = 1, by = 0.01)
    for(val in len) {
        prob <- stats::predict(model, data, type = "response")
        count <- data.frame(call = ifelse(prob > val, success, failure),
                            our_success = ind_column)
        TP <- count[stringr::str_detect(count$our_success, success) &
                        stringr::str_detect(count$call, success), ] %>%
            nrow()
        FP <- count[stringr::str_detect(count$our_success, failure) &
                        stringr::str_detect(count$call, success), ] %>%
            nrow()
        TN <- count[stringr::str_detect(count$our_success, failure) &
                        stringr::str_detect(count$call, failure), ] %>%
            nrow()
        FN <- count[stringr::str_detect(count$our_success, success) &
                        stringr::str_detect(count$call, failure), ] %>%
            nrow()

        TPR <- TP/(TP + FN)
        true <- c(true, TPR)
        FPR <- FP/(FP + TN)
        false <- c(false, FPR)
    }
    final <- data.frame(TPR = true, FPR = false,
                        Prob_Threshold = seq(from = 0, to = 1, by = 0.01))
    if(na.rm == T) {
        final <- final[stats::complete.cases(final), ]
    }
    final
}
