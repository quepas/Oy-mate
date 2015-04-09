library(OpenML)
library(foreign)
library(plyr)
library(tools)

# Loading all needed OML data into global env.
LoadOMLDataIntoGlobalEnv <- function() {
  session.hash <<- authenticateUser(username = "openml.rteam@gmail.com", password = "testpassword")

  globalTasks <<- LoadOMLTasks("Supervised Classification")
  globalDataSets <<- listOMLDataSets()
  globalQualities <<- LoadOMLDataSetsQualities(globalDataSets)
  globalResults <<- LoadOMLTaskResults(globalTasks)
}

# Loading all tasks with given type (ex. "Supervised Classification")
LoadOMLTasks <- function(taskTypeName) {
  taskTypes <- listOMLTaskTypes()
  type.id <- with(taskTypes, id[name == taskTypeName])
  tasks <- listOMLTasks(type = type.id)
  tasks
}

# Loading qualities for given data sets
LoadOMLDataSetsQualities <- function(dataSets) {
  qualities <- list()
  for (dataSetID in dataSets[, 1]) {
    qualities[[dataSetID]] <- PrepareDataSetQualities(listOMLDataSetQualities(dataSetID))
  }
  qualities
}

# Loading all run results for given tasks
LoadOMLTaskResults <- function(tasks) {
  results <- list()
  index <- 1
  for (taskID in tasks[, 1]) {
    results[[index]] <- listOMLRunResults(taskID)
    index <- index + 1
  }
  results
}

# Loading run results for given tasks range
LoadOMLTaskResults <- function(tasks, from, to) {
  results <- list()
  index <- 1
  for (i in from:to) {
    if (i > nrow(tasks)) break
    results[[index]] <- listOMLRunResults(tasks[i, 1]);
    index <- index + 1
  }
  results
}

# Setup algorithm criteria for experiment (algorithm set)
SetupExperimentGlobalEnv <- function() {
  algorithmsCriteria <<- list(
    c("weka.OneR", "^weka.OneR\\(.*\\)$"),
    c("weka.ZeroR", "^weka.ZeroR\\(.*\\)$"),
    c("weka.J48", "^weka.J48\\(.*\\)$"),
    c("weka.NaiveBayes", "^weka.NaiveBayes\\(.*\\)$"),
    c("weka.Logistic", "^weka.Logistic\\(.*\\)$"))

  wekaJarPath <<- "D:/Programy2/Weka-3-6/weka.jar"
  generatedModelDir <<- "./generated-model/"
  generatedDatasetDir <<- "./generated-dataset/"
}

# Create list of unique data set names
CreateUniqueDataSetNames <- function() {
  unique(globalDataSets[[3]])
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

# Create DataSet #3... (unique data sets among all algorithms, using description statistics metrics)
GoSecondExperiments <- function() {
  SecondExperiment(algorithmsCriteria, CreateRunsCriteriaA(), "DataSet3")
  GenerateWEKAModel("DataSet3.arff");  
  SecondExperiment(algorithmsCriteria, CreateRunsCriteriaB(), "DataSet4")
  GenerateWEKAModel("DataSet4.arff")
}

# List not used data set in meta-data set #3
ListNotUsedDataSet <- function() {
  usedDataSets <- SecondExperiment(algorithmsCriteria, CreateRunsCriteriaA(), "DataSet3")
}

SecondExperiment <- function(algorithmCriteria, runsCriteria, outputFile) {
  dataSet <- data.frame()
  unique_idxs <- c()
  usedDataSetNames <<- c()
  for (i in 1:length(algorithmsCriteria)) {
    algorithmName <- algorithmsCriteria[[i]][1]
    cat("---- ", algorithmName, " ----\n")
    idxs <- GetResultsWithCriteria(globalResults, algorithmsCriteria[[i]][2], runsCriteria)
    if (i == 1) {
      prepare_idxs <- idxs
    } else {
      prepare_idxs <- setdiff(idxs, unique_idxs)
    }
    dataSet <- rbind.fill(dataSet, PrepareDataSetChunk(globalTasks, prepare_idxs, algorithmName))
    unique_idxs <- c(unique_idxs, setdiff(idxs, unique_idxs)) 
  }
  write.arff(dataSet, paste(generatedDatasetDir, outputFile, ".arff", sep=""))
  usedDataSetNames
}

FilterForNotUsedDataSets <- function(allDataSet) {
  filteredDataSet <- data.frame()
  usedDataSet <- unique(usedDataSetNames)
  for (i in 1:nrow(allDataSet)) {
    if (!(allDataSet[i, 3] %in% usedDataSet)) {
      filteredDataSet <- rbind.fill(filteredDataSet, globalQualities[[allDataSet[i, 1]]])
    }
  }
  notUsedDataSet <- unique(filteredDataSet)
  write.arff(notUsedDataSet, "NotUsed.arff")
  notUsedDataSet
}

# Create DataSet #1 & #2.
GoFirstExperiment <- function() {
  
}

# in:
#     results - array of runs results
#     name - name of algorithm (as regexp)
GetResultsWithCriteria <- function(runs, algorithmName, runsCriteria) {
  idxs <- list()
  for (i in 1:length(runs)) {
    result <- FilterResult(runs[[i]], algorithmName, runsCriteria)
    percent <- result[1]
    if (!is.nan(percent) && percent > 0.0) {
      cat(sprintf("Task_id: %d [%f%% (%d/%d)], data set: %s\n", globalTasks[i, 1], percent, result[2], result[3], globalTasks[i, 5]))
      usedDataSetNames <<- c(usedDataSetNames, globalTasks[i, 5])
      idxs <- c(idxs, i)
    }
  }
  idxs
}

# Generate java-based classificator model from given data set in *.arff file
GenerateWEKAModel <- function(dataSetFile) {
  wekaPathInQuotes <- paste("\"", wekaJarPath, "\"", sep="")
  modelFile <- paste(generatedModelDir, file_path_sans_ext(dataSetFile), ".model", sep="")
  runCommand <- paste("java", "-classpath", wekaPathInQuotes,
                      "weka.classifiers.trees.J48", "-t", paste(generatedDatasetDir, dataSetFile, sep=""),
                      "-d", modelFile)
  system(runCommand)
}

PrepareDataSetChunk <- function(tasks, idxs, class) {
  dataSetIndxs <- tasks[unlist(idxs), 3]
  result <- data.frame()
  for (i in dataSetIndxs) {
    result <- rbind.fill(result, globalQualities[[i]])
  }
  classes <- data.frame(class=rep(class, nrow(result)))
  data.frame(result, classes)
}

FilterResult <- function(result, algorithmName, runsCriteria) {
  percent <- NaN
  numAllRuns <- 0
  numGoodRuns <- 0
  if (nrow(result) != 0) {
    filtered_runs <- FilterResultsByName(result, algorithmName)
    numAllRuns <- nrow(filtered_runs)
    # Apply runs criteria
    for (i in 1:length(runsCriteria)) {
      criteria <- runsCriteria[[i]]
      filtered_runs <- FilterResultsByEvaluation(filtered_runs, criteria[[1]], criteria[[2]], criteria[[3]])
    }
    numGoodRuns <- nrow(filtered_runs)
    percent <- (numGoodRuns / numAllRuns) * 100
  } 
  c(percent, numGoodRuns, numAllRuns)
}

FilterResultsByName <- function(results, name) {
  subset(results, grepl(name, implementation))
}

FilterResultsByEvaluation <- function(results, metrics, min, max) {
  subset(results, eval(parse(text=metrics)) >= min & eval(parse(text=metrics)) <= max)
}

PrepareDataSetQualities <- function(qvals) {
  qnames <- qvals[[1]]
  data <- data.frame(matrix(dat=NA, ncol = length(qnames), nrow = 0))
  colnames(data) <- qnames
  data[1, ] <- qvals[[2]]
  data
}
