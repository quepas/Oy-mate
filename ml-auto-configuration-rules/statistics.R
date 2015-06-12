library(dplyr)

PlotAllDatasetBestMetrics <- function(metrics, datasets = globalDataSets) {
  did <- datasets$did
  all_best <- c()
  for (id in did) {
    all_best <- c(all_best, DatasetBestMetrics(id, metrics))
  }
  all_best
}

MetaAttributesMissingValuesCoverage <- function(meta_attributes = globalQualities) {
  sapply(meta_attributes, function(col) sum(is.na(col)))/nrow(meta_attributes)
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

TaskIdForDataset <- function(datasetId, tasks = globalTasks) {
  filter(tasks, did == datasetId)$task_id
}

ResultForDataset <- function(datasetId, runs = globalResults) {
  tasks <- TaskIdForDataset(datasetId)
  filter(runs, task.id %in% tasks)
}
