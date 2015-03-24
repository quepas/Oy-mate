library(OpenML)
library(foreign)

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
  print("---- weka.OneR ----")
  idxs <- GetResultsWithCriteria(runs_results, "^weka.OneR\\(.*\\)$")
  dataSet <- rbind(dataSet, PrepareDataSetChunk(tasks, idxs, "OneR"))
  print("---- weka.ZeroR ----")
  idxs <- GetResultsWithCriteria(runs_results, "^weka.ZeroR\\(.*\\)$")
  dataSet <- rbind(dataSet, PrepareDataSetChunk(tasks, idxs, "ZeroR"))
  print("---- weka.J48 ----")
  idxs <- GetResultsWithCriteria(runs_results, "^weka.J48\\(.*\\)$")
  dataSet <- rbind(dataSet, PrepareDataSetChunk(tasks, idxs, "J48"))
  print("---- weka.NaiveBayes ----")
  idxs <- GetResultsWithCriteria(runs_results, "^weka.NaiveBayes\\(.*\\)$")
  dataSet <- rbind(dataSet, PrepareDataSetChunk(tasks, idxs, "NaiveBayes"))
  print("---- weka.Logistic ----")
  idxs <- GetResultsWithCriteria(runs_results, "^weka.Logistic\\(.*\\)$")
  dataSet <- rbind(dataSet, PrepareDataSetChunk(tasks, idxs, "Logistic"))
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
  columns <- c(8:14)
  data_to_write <- tasks[unlist(idxs), columns]
  classes <- data.frame(class=rep(class, nrow(data_to_write)))
  data.frame(data_to_write, classes)
}

FilterResult <- function(result, name) {
  percent <- NaN
  numAllRuns <- 0
  numGoodRuns <- 0
  if (nrow(result) != 0) {
    filtered_runs <- FilterResultsByName(result, name)
    numAllRuns <- nrow(filtered_runs)
    filtered_runs <- FilterResultsByEvaluation(filtered_runs, "area.under.roc.curve", 0.98, 1)
    #filtered_runs <- FilterResultsByEvaluation(filtered_runs, "predictive.accuracy", 0.98, 1)
    #filtered_runs <- FilterResultsByEvaluation(filtered_runs, "precision", 0.95, 1)
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