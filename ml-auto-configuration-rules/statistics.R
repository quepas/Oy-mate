library(dplyr)

PlotAllDatasetBestMetrics <- function(metrics) {
  did <- globalDataSets$did
  all_best <- c()
  for (id in did) {
    all_best <- c(all_best, DatasetBestMetrics(id, metrics))
  }
  all_best
}

# ------------------------- helper functions -------------------------
DatasetBestMetrics <- function(did, metrics) {
  results <- ResultForDataset(did)
  results <- sort(results[, metrics], decreasing = TRUE)
  if (length(results) > 0) {
    return(results[1])
  } else {
    return(NA)
  }
}

TaskIdForDataset <- function(datasetId) {
  filter(globalTasks, did == datasetId)$task_id
}

ResultForDataset <- function(datasetId) {
  tasks <- TaskIdForDataset(datasetId)
  filter(globalResults, task.id %in% tasks)
}
