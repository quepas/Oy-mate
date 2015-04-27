library(foreign)

csv2arff <- function(csvName, arffName, sep = ",", na.strings = "") {
  data <- read.csv(csvName, sep = sep, na.strings = na.strings)
  write.arff(data, arffName)
}
