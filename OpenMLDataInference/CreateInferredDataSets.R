library(OpenML)
library(foreign)
library(plyr)

InitDataSetQualities <- function() {
  dataSetQualities <<- list()
  allDataSet <<- listOMLDataSets()
  for (i in allDataSet[, 1]) {
    dataSetQualities[[i]] <<- PrepareDataSetQualities(listOMLDataSetQualities(i))
  }
}

init <- function() {
  max_tasks <<- 200
  only_max_tasks <- FALSE
  session.hash = authenticateUser(username = "openml.rteam@gmail.com", password = "testpassword")
  tasks <<- GetTasks("Supervised Classification")
  runs_results <<- list()
  counter <- 1
  runs_so_far <- 0
  for (task_id in tasks[,1]) {
    runs_results[[counter]] <<- listOMLRunResults(task_id)
    rows <- nrow(runs_results[[counter]])
    print(rows)
    print("Runs so far: ")
    runs_so_far <- runs_so_far + rows
    print(runs_so_far)
    counter <- counter + 1
    if (counter > max_tasks && only_max_tasks) {
      break
    }
  }
  roc_threshold <<- 0.98
}

init_thresholds <- function() {
  roc_threshold <<- 0.98
}

go <- function() {
  dataSet <- data.frame()
  unique_idxs <- c()
  print("---- weka.OneR ----")
  idxs <- GetResultsWithCriteria(runs_results, "^weka.OneR\\(.*\\)$")
  unique_idxs <- idxs
  dataSet <- rbind.fill(dataSet, PrepareDataSetChunk(tasks, unique_idxs, "OneR"))
  print("---- weka.ZeroR ----")
  idxs <- GetResultsWithCriteria(runs_results, "^weka.ZeroR\\(.*\\)$")
  dataSet <- rbind.fill(dataSet, PrepareDataSetChunk(tasks, setdiff(idxs, unique_idxs), "ZeroR"))
  unique_idxs <- c(unique_idxs, setdiff(idxs, unique_idxs))
  print("---- weka.J48 ----")
  idxs <- GetResultsWithCriteria(runs_results, "^weka.J48\\(.*\\)$")
  dataSet <- rbind.fill(dataSet, PrepareDataSetChunk(tasks, setdiff(idxs, unique_idxs), "J48"))
  unique_idxs <- c(unique_idxs, setdiff(idxs, unique_idxs))
  print("---- weka.NaiveBayes ----")
  idxs <- GetResultsWithCriteria(runs_results, "^weka.NaiveBayes\\(.*\\)$")
  dataSet <- rbind.fill(dataSet, PrepareDataSetChunk(tasks, setdiff(idxs, unique_idxs), "NaiveBayes"))
  unique_idxs <- c(unique_idxs, setdiff(idxs, unique_idxs))
  print("---- weka.Logistic ----")
  idxs <- GetResultsWithCriteria(runs_results, "^weka.Logistic\\(.*\\)$")
  dataSet <- rbind.fill(dataSet, PrepareDataSetChunk(tasks, setdiff(idxs, unique_idxs), "Logistic"))
  unique_idxs <- c(unique_idxs, setdiff(idxs, unique_idxs))
  write.arff(dataSet, "DataSet.arff")
}

# in:
#     results - array of runs results
#     name - name of algorithm (as regexp)
GetResultsWithCriteria <- function(runs, name) {
  idxs <- list()
  for (i in 1:length(runs)) {
    result <- FilterResult(runs[[i]], name)
    percent <- result[1]
    if (!is.nan(percent) && percent > 0.0) {
      cat(sprintf("Task_id: %d [%f%% (%d/%d)], data set: %s\n", tasks[i, 1], percent, result[2], result[3], tasks[i, 5]))
      idxs <- c(idxs, i)
    }
  }
  idxs
}

PrepareDataSetChunk <- function(tasks, idxs, class) {
  dataSetIndxs <- tasks[unlist(idxs), 3]
  result <- data.frame()
  for (i in dataSetIndxs) {
    result <- rbind.fill(result, dataSetQualities[[i]])
  }
  classes <- data.frame(class=rep(class, nrow(result)))
  data.frame(result, classes)
}

FilterResult <- function(result, name) {
  percent <- NaN
  numAllRuns <- 0
  numGoodRuns <- 0
  if (nrow(result) != 0) {
    filtered_runs <- FilterResultsByName(result, name)
    numAllRuns <- nrow(filtered_runs)
    filtered_runs <- FilterResultsByEvaluation(filtered_runs, "area.under.roc.curve", 0.99, 1)
    filtered_runs <- FilterResultsByEvaluation(filtered_runs, "predictive.accuracy", 0.99, 1)
    filtered_runs <- FilterResultsByEvaluation(filtered_runs, "precision", 0.99, 1)
    numGoodRuns <- nrow(filtered_runs)
    percent <- (numGoodRuns / numAllRuns) * 100
  } 
  c(percent, numGoodRuns, numAllRuns)
}

GetTasks <- function(taskTypeName) {
  taskTypes <- listOMLTaskTypes()
  type.id <- with(taskTypes, id[name == taskTypeName])
  tasks <- listOMLTasks(type = type.id)
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
