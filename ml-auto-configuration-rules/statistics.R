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
DatasetMetrics <- function(did, metrics, max = TRUE) {
  results <- ResultForDataset(did)
  if (max) {
    value <- max(results[, metrics]) 
  } else {
    value <- min(results[, metrics])
  }
  results <- filter_(results, paste(metrics, "==", value))
  if (nrow(results) > 0) {
    unique_names <- unique(results[, "implementation"])
    unique_names <- sapply(strsplit(unique_names, "\\("), function(x) x[1])
    return(data.frame(stringsAsFactors = F, implementation = unique_names, value = rep(value, length(unique_names))))
  } else {
    return(NA)
  }
}

DatasetBestMetricsForAlgorithm <- function(did, metrics, algorithm) {
  results <- ResultForDataset(did)
  if (nrow(results) > 0) {
    results <- results[grepl(algorithm, results$implementation), ]
    if (nrow(results) > 0) {
      return(data.frame(stringsAsFactors = F, implementation = algorithm, value = max(results[, metrics]))) 
    }    
  }
  return(NA)
}

TaskIdForDataset <- function(datasetId, tasks = globalTasks) {
  filter(tasks, did == datasetId)$task_id
}

ResultForDataset <- function(datasetId, runs = globalResults) {
  tasks <- TaskIdForDataset(datasetId)
  filter(runs, task.id %in% tasks)
}

PrepareData <- function(predictions) {
  did <- predictions$did
  values <- c()
  real_values <- c()
  min_values <- c()
  m <- NA
  for (id in did) {
    #print(DatasetBestMetricsForAlgorithm(id, "area.under.roc.curve", predictions[id, "algorithm"]))
    val <- DatasetBestMetricsForAlgorithm(id, "area.under.roc.curve", predictions[id, "algorithm"])
    rel <- DatasetMetrics(id, "area.under.roc.curve")
    m <- DatasetMetrics(id, "area.under.roc.curve", max = FALSE)
    rrel <- NA
    #print(rel)
    if (!is.na(rel) && nrow(rel) != 0) {
      rrel <- rel$value[1]
    }
    if (rrel < 0.9) {
      if (!is.na(m) && nrow(m) != 0) {
        m <- m$value[1]
      }
      if (is.data.frame(val) > 0) {
        values <- c(values, val$value)  
      } else {
        values <- c(values, NA)  
      }
      real_values <- c(real_values, rrel)
      min_values <- c(min_values, m) 
    } else {
      predictions <- predictions[predictions$did != id, ]
    }
  }
  d <- data.frame(predictions, pred = values, real = real_values, min = min_values)
  d <- d[!is.na(d$real) & !is.na(d$pred), ]
  bar <- barplot(d$real, col = "blue", pch = 20)
  points(bar, d$pred, col = "red", pch = 20)
  lines(bar, d$min, col = "yellow", pch = 20)
  abline(h = 0.9, col = "green")
  abline(h = 0.98, col = "orange")
  d
}
