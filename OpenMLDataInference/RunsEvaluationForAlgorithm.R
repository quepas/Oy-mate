library(OpenML)

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
  name <- "^weka.J48.*$"
  idxs <- c()
  for (idx in 1:length(runs_results)) {
    evaluation <- FilterResult(runs_results[[idx]], name)
    percent <- evaluation[1]
    if (!is.nan(percent) && percent > 0.0) {
      cat(sprintf("Task_id: %d [%f%% (%d/%d)], data set: %s\n", tasks[idx,1], percent, evaluation[2], evaluation[3], tasks[idx,5]))
      idxs <- c(idxs, idx)
    }
  }
  print(idxs)
  #print(tasks[idxs, c(6, 8, 9, 10, 11, 12, 13, 14)]) # write this to arff file
}

FilterResult <- function(result, name) {
  percent <- NaN
  numAllRuns <- 0
  numGoodRuns <- 0
  if (nrow(result) != 0) {
    filtered_runs <- FilterResultsByName(result, name)
    numAllRuns <- nrow(filtered_runs)
    filtered_runs <- FilterResultsByEvaluation(filtered_runs, "area.under.roc.curve", 0.98, 1)
    #filtered_runs <- FilterResultsByEvaluation(filtered_runs, "predictive.accuracy", 0.99, 1)
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