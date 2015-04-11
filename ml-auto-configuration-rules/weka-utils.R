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
