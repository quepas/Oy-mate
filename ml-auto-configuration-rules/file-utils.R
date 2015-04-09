library(foreign)

# Saving data frame as ARFF file, fileName without extension
SaveARFF <- function(dataFrame, fileName, directory = "") {
  write.arff(dataFrame, paste(directory, fileName, ".arff", sep=""))
}

# Loading ARFF file as data frame, fileName without extension
LoadARFF <- function(fileName, directory = "") {
  read.arff(paste(directory, fileName, ".arff", sep=""))
}
