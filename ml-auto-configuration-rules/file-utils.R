library(foreign)

# Saving data frame as ARFF file, fileName without extension
SaveARFF <- function(dataFrame, fileName, directory = "", extension = "arff") {
  write.arff(dataFrame, paste(directory, fileName, ".", extension, sep=""))
}

# Loading ARFF file as data frame, fileName without extension
LoadARFF <- function(fileName, directory = "", extension = "arff") {
  read.arff(paste(directory, fileName, ".", extension, sep=""))
}

# Saving data frame as XARRF ranking file
SaveXARFF <- function(dataFrame, fileName, directory = "", ranks) {
  # Save as normal ARFF
  SaveARFF(dataFrame, fileName, directory, extension = "xarff")
  # replace combined ranks with single ranks
  # - load file
  file <- scan(sep = "\n", paste(directory, fileName, ".arff", sep=""), character(0))
  #print(file)
  # - find '@attribute ranks ...' occurence
  counter <- 1
  for (line in file) {
    if (grepl("@attribute rank", line)) {
      replacement <- paste("@attribute ranks RANKING {", paste(ranks, collapse = ","), "}")
      file[counter] <- replacement
      break;
    }
    counter <- counter + 1
  }
  # - rewrite file
  cat(file,file=paste(directory, fileName, ".arff", sep=""),sep="\n")
}
