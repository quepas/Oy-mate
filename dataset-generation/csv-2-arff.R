library(foreign)

csv2arff <- function(csvName, arffName, sep=",") {
  data <- read.csv(csvName, sep = sep)
  write.arff(data, arffName)
}
