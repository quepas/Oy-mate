CreateAlgorithmsFrame <- function() {
  name <- c("weka.OneR",
            "weka.ZeroR",
            "weka.J48",
            "weka.NaiveBayes",
            "weka.Logistic",
            "weka.RandomTree",
            "weka.JRip",
            "weka.A1DE",
            "weka.Bagging_REPTree",
            "weka.FilteredClassifier_Discretize_J48",
            "weka.BayesNet_K2",
            "weka.LibSVM",
            "weka.ADTree",
            "weka.AdaBoostM1_DecisionStump",
            "weka.NBTree")
  openmlName <- c("^weka.OneR\\(.*\\)$",
                  "^weka.ZeroR\\(.*\\)$",
                  "^weka.J48\\(.*\\)$",
                  "^weka.NaiveBayes\\(.*\\)$",
                  "^weka.Logistic\\(.*\\)$",
                  "^weka.RandomTree\\(.*\\)$",
                  "^weka.JRip\\(.*\\)$",
                  "^weka.A1DE\\(.*\\)$",
                  "^weka.Bagging_REPTree\\(.*\\)",
                  "^weka.FilteredClassifier_Discretize_J48\\(.*\\)",
                  "^weka.BayesNet_K2\\(.*\\)",
                  "^weka.LibSVM\\(.*\\)",
                  "^weka.ADTree\\(.*\\)",
                  "^weka.AdaBoostM1_DecisionStump\\(.*\\)")
  data.frame(name, openmlName)
}

GetTopNAlgorithms <- function(N) {
  impl <- globalResults$implementation
  # contingency table
  impl <- sort(table(impl), decreasing =  T)
  # get only WEKA's algorithms
  impl <- impl[grepl("^weka.*$", names(impl))]
  # get only top N algorithms
  impl <- names(head(impl, N))
  name <- c()
  openmlName <- c()
  for (impl_name in impl) {
    base_name <- sub("\\(.*\\)", "", impl_name)
    name <- c(name, base_name)
    base_name_regexp <- paste(base_name, "\\(.*\\)", sep = "")
    openmlName <- c(openmlName, base_name_regexp)
  }
  df <- data.frame(name, openmlName)
  df[unique(df$name), ]
}

CreateAlgorithmsFrameAll <- function() {
  flows <- FilterWEKAFlowsName(globalFlows)
  name <- flows
  openmlName <- paste("^", flows, "\\(.*\\)$", sep="")
  data.frame(name, openmlName)
}

CreateAlgorithmsCriteria <- function() {
  criteria <- list(
    c("weka.OneR", "^weka.OneR\\(.*\\)$"),
    c("weka.ZeroR", "^weka.ZeroR\\(.*\\)$"),
    c("weka.J48", "^weka.J48\\(.*\\)$"),
    c("weka.NaiveBayes", "^weka.NaiveBayes\\(.*\\)$"),
    c("weka.Logistic", "^weka.Logistic\\(.*\\)$"))
  criteria
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
