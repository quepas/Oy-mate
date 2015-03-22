library("foreign")
library("proxy")

iris <- read.arff("data/iris.arff")
#iris2d <- read.arff("data/iris.2D.arff")

find_similiar_dataset <- function(base_ds, directory) {
  file_names <- list.files(directory, pattern="\\.arff$")

  file_names <- file_names[file_names != base_ds]
  base <- read.arff(paste(directory, base_ds, sep="\\"))
  max_simil <- 0
  winner <- "NA"
  for (name in file_names) {
    print(name)
    tryCatch({
      ds <- read.arff(paste(directory, name, sep="\\"))
      simil_metrics <- compare_datasets(base, ds)
      if (simil_metrics > max_simil) {
        max_simil <- simil_metrics
        winner <- name
      }
      cat(sprintf("Comparing with %s: %f\n", toString(name), simil_metrics))
    },
    error = function(err) {
      file.remove(paste(directory, name, sep="\\"))
    },
    finally = {})    
  }
  cat("\nWinner is", winner, "with", toString(max_simil))
}

compare_datasets <- function(ds1, ds2) {
  ds1_numeric <- filter_for_numeric(ds1)
  ds2_numeric <- filter_for_numeric(ds2)

  ds1_ncol_n <- ncol(ds1_numeric)
  ds2_ncol_n <- ncol(ds2_numeric)

  if (ds1_ncol_n == 0 || ds2_ncol_n == 0) {
    return(-1)
  }

#   cat(sprintf("ds1 ncol: %i\n", ncol(ds1)))
#   cat(sprintf("ds1 numeric ncol: %i\n", ds1_ncol_n))
#   cat(sprintf("ds2 ncol: %i\n", ncol(ds2)))
#   cat(sprintf("ds2 numeric ncol: %i\n", ds2_ncol_n))

  if (ds2_ncol_n > ds1_ncol_n) {
    temp <- ds1_numeric
    ds1_numeric <- ds2_numeric
    ds2_numeric <- temp
  
    ds1_ncol_n <- ncol(ds1_numeric)
    ds2_ncol_n <- ncol(ds2_numeric)
  }

  column_matching <- 0
#   cat("----------------- Column matching -------------------\n")
  for (i in 1:ds1_ncol_n) {
    max_simil <- 0
    counter <- 0
    for (j in 1:ds2_ncol_n) {
      col_simil <- calculate_simil(ds1_numeric[,i], ds2_numeric[,j])
#       cat(sprintf("%i x %i = %f\n", i, j, col_simil))

      if (col_simil > max_simil) {
        max_simil <- col_simil
        counter <- j
      }
    }
#     cat(sprintf("Matched columnds: %i x %i\n", i, counter))
    column_matching <- column_matching + max_simil
  }
#   cat("-----------------------------------------------------\n")
  column_matching/ds1_ncol_n
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
