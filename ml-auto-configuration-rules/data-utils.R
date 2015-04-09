library(plyr)

rbind.left <- function(dataSet1, dataSet2) {
  result <- rbind.fill(dataSet1, dataSet2)
  result[, names(dataSet1)]
}

rbind.right <- function(dataSet1, dataSet2) {
  rbind.left(dataSet2, dataSet1)
}
