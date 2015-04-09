library(plyr)

# Create list of unique data set names
CreateUniqueDataSetNames <- function() {
  unique(globalDataSets[[3]])
}

# List not used data set in meta-data set #3
ListNotUsedDataSet <- function() {
  usedDataSets <- SecondExperiment(algorithmsCriteria, CreateRunsCriteriaA(), "DataSet3")
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

PrepareDataSetChunk <- function(tasks, idxs, class) {
  dataSetIndxs <- tasks[unlist(idxs), 3]
  result <- data.frame()
  for (i in dataSetIndxs) {
    result <- rbind.fill(result, globalQualities[[i]])
  }
  classes <- data.frame(class=rep(class, nrow(result)))
  data.frame(result, classes)
}

PrepareTaskDataSetChunk <- function(tasks, idxs, class) {
  dataSet <- tasks[unlist(idxs), 8:14]
  classes <- data.frame(class=rep(class, nrow(dataSet)))
  data.frame(dataSet, classes)
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
