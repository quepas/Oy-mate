library("foreign")
library("proxy")

iris <- read.arff("data/iris.arff")
iris2d <- read.arff("data/iris.2D.arff")

compare_datasets <- function(ds1, ds2) {
  ds1_numeric <- filter_for_numeric(ds1)
  ds2_numeric <- filter_for_numeric(ds2)

  cat(sprintf("ds1 ncol: %i\n", ncol(ds1)))
  cat(sprintf("ds1 numeric ncol: %i\n", ncol(ds1_numeric)))
  cat(sprintf("ds2 ncol: %i\n", ncol(ds2)))
  cat(sprintf("ds2 numeric ncol: %i\n", ncol(ds2_numeric)))

  for (i in 1:ncol(ds1_numeric)) {
    for (j in 1:ncol(ds2_numeric)) {
      cat(sprintf("%i x %i = %f\n", i, j, calculate_simil(ds1_numeric[,i], ds2_numeric[,j])))
    }
  }
}

filter_for_numeric <- function(ds) {
  ds[, sapply(ds, is.numeric)]
}

calculate_simil <- function(col1, col2, method="eJaccard") {
  simil_matrix <- simil(c(summary(col1), sd(col1), var(col1)), c(summary(col2), sd(col2), var(col2)), method)
  #print(simil_matrix)
  num_summary = 8
  sum(simil_matrix*diag(1, num_summary))/num_summary
}
