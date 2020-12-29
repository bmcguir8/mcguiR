#' Find Problem Samples within Training Dataset
#'
#' only supports binary logistic regression at this time.
#' doesn't work when dfbeta(model) is included - recommend still looking at
#' these values outside of this function
#'
#' @param model the model to be used
#' @param data TRAINING data set
#' @param k number of predictors in model
#' @param standard cut-off for standardized residuals- samples with values above
#' abs(standard) will be returned
#' @param student cut-off for studentized residuals - samples with values above
#' abs(standard) will be returned
#' @param df_fits cut-off for DFFITS - samples with values above
#' abs(standard) will be returned
#' @param cooks cut-off for cook's distance - samples with values above
#' abs(standard) will be returned
#'
#' @return a data frame
#' @export
#'
#' @examples
#' \dontrun{
#' iris2 <- iris[stringr::str_detect(Species, "setosa", negate = T), ]
#' irismodel <- glm(Species ~ ., data = iris2, family = binomial)
#' problem_samples(irismodel, iris2, k = 4)}
problem_samples.log <- function(model, data, k, standard = 2.0,
                            student = 2.0, df_fits = 1.0,
                            cooks = 1.0) {
    dat <- dplyr::mutate(data, prob = predict(model, data, type = "response"),
                         standard_residuals = stats::rstandard(model),
                         student_residuals = stats::rstudent(model),
                         df_fits = stats::dffits(model),
                         leverage = stats::hatvalues(model),
                         expected_levarage = ((k + 1)/nrow(data)),
                         cooks_distance = stats::cooks.distance(model))
    std_r <- abs(dat$standard_residuals) >= standard
    stud_r <- abs(dat$student_residuals) >= student
    fits <- abs(dat$df_fits) >= df_fits
    cook <- dat$cooks_distance >= cooks
    simple <- (std_r + stud_r + fits + cook) > 0
    dat[simple, ]
}

problem_samples.lm <- function(model, data, k, standard = 2.0,
                                student = 2.0, df_fits = 1.0,
                                cooks = 1.0) {
    dat <- dplyr::mutate(data, prob = predict(model, data),
                         standard_residuals = stats::rstandard(model),
                         student_residuals = stats::rstudent(model),
                         df_fits = stats::dffits(model),
                         leverage = stats::hatvalues(model),
                         expected_levarage = ((k + 1)/nrow(data)),
                         cooks_distance = stats::cooks.distance(model))
    std_r <- abs(dat$standard_residuals) >= standard
    stud_r <- abs(dat$student_residuals) >= student
    fits <- abs(dat$df_fits) >= df_fits
    cook <- dat$cooks_distance >= cooks
    simple <- (std_r + stud_r + fits + cook) > 0
    dat[simple, ]
}

