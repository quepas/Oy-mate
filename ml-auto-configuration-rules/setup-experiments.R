# Setup experiments global configuration
SetupExperimentGlobalEnv <- function() {
  algorithmsCriteria <<- list(
    c("weka.OneR", "^weka.OneR\\(.*\\)$"),
    c("weka.ZeroR", "^weka.ZeroR\\(.*\\)$"),
    c("weka.J48", "^weka.J48\\(.*\\)$"),
    c("weka.NaiveBayes", "^weka.NaiveBayes\\(.*\\)$"),
    c("weka.Logistic", "^weka.Logistic\\(.*\\)$"))
}

CreateRunsCriteriaA <- function() {
  criteria <- list(
    list("area.under.roc.curve", 0.98, 1))
  criteria
}

CreateRunsCriteriaB <- function() {
  criteria <- list(
    list("area.under.roc.curve", 0.99, 1),
    list("predictive.accuracy", 0.98, 1),
    list("precision", 0.95, 1))
  criteria
}
