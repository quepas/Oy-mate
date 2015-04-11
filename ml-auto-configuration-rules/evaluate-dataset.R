EvaluateConfDataSet <- function(dataSetQualities, confDataSetName) {
  confDataSet <- LoadARFF(confDataSetName, directory = generatedDatasetDir)
  # Extract header, leave class column
  confDataSetHeader <- confDataSet[0, ]#-ncol(confDataSet)]
  testSet <- rbind.left(confDataSetHeader, dataSetQualities)
  SaveARFF(testSet, paste(confDataSetName, "TestSet", sep=""), generatedTestSetDir)
}

GetTasksForDataset <- function(tasks, datasetID) {
  tasks[tasks$did == datasetID,]
}

GetTasksIDForDataset <- function(tasks, datasetID) {
  tasksForDataset <- GetTasksForDataset(tasks, datasetID)
  tasksForDataset$task_id
}

ListBestAlgorithms <- function(datasetID, tasks = globalTasks,
                               runs = globalResults, algorithms = c(),
                               criteria = c("predictive.accuracy"), thresholds = c(0.98))
{
  taskIDs <- GetTasksIDForDataset(tasks, datasetID)
  datasetRuns <- data.frame()
  for(i in 1:length(runs)) {
    run <- runs[[i]]
    if (all(run$task.id %in% taskIDs)) {
      datasetRuns <- rbind(datasetRuns, run)
    }
  }
  print(dim(datasetRuns))
  # filter by result criteria
  datasetRuns <- datasetRuns[datasetRuns[criteria] >= thresholds, ]
  print(dim(datasetRuns))
  # filter by algorithms
  result <- data.frame()
  if (length(algorithms) == 0) {
    result <- datasetRuns
  } else {
    for (i in 1:length(algorithms)) {
      result <- rbind(result, datasetRuns[grepl(algorithms[i], datasetRuns$implementation, fixed = TRUE), ])
    }
  }
  result
}
