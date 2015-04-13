library(tools)
library(RWeka)

# Generate java-based classificator model from given data set in *.arff file
GenerateWEKAModel <- function(dataSetFile) {
  wekaPathInQuotes <- paste("\"", wekaJarPath, "\"", sep="")
  modelFile <- paste(generatedModelDir, file_path_sans_ext(dataSetFile), ".model", sep="")
  runCommand <- paste("java", "-classpath", wekaPathInQuotes,
                      "weka.classifiers.trees.J48", "-t", paste(generatedDatasetDir, dataSetFile, sep=""),
                      "-d", modelFile)
  system(runCommand)
}

TestWEKAModel <- function(modelName, testSet) {
  wekaPathInQuotes <- paste("\"", wekaJarPath, "\"", sep="")
  runCommand <- paste("java", "-classpath", wekaPathInQuotes,
                      "weka.classifiers.trees.J48", "-l", paste(generatedModelDir, modelName, ".model", sep=""),
                      "-T", paste(generatedTestSetDir, testSet, ".arff", sep=""))
  system(runCommand)
}

BuildConfClassifier <- function(trainSet) {
  J48(class ~ ., data = trainSet, na.action=NULL)
}

# Test instances on classifier
# in:
#   * classifier
#   * instances : data.frame
#
TestInstances <- function(classifier, instances) {
 predict(classifier, instances)
}

RankInstance <- function(classifier, instance) {
  rank <- predict(classifier, instance, type = c("probability"))
  rank <- rank[, order(rank, decreasing = TRUE)]
  data.frame(row.names = 1:length(rank), name=names(rank), value=rank)
}
