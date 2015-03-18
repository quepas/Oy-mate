library(OpenML)

init <- function() {
  max_tasks <<- 200
  session.hash = authenticateUser(username = "openml.rteam@gmail.com", password = "testpassword")
  tasks <<- listOMLTasks(1)
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
    if (counter > max_tasks) {
      break
    }
  }
  roc_threshold <<- 0.98
}

go <- function() {
  impl <- "^weka.J48.*$"
  for (idx in 1:max_tasks) {
    evaluation <- list_tasks_with_good_runs(runs_results[[idx]], impl)
    percent <- evaluation[1]
    if (!is.nan(percent) && percent > 0.0) {
      cat(sprintf("Task_id: %d [%f%% (%d)]\n", tasks[idx,1], percent, evaluation[2]))
    }
  }
}

list_tasks_with_good_runs <- function(run_result, implementation_regexp) {
  good_percent <- NaN
  filtered_runs <- list()
  all_runs <- list()
  if (ncol(run_result) > 5) {
    all_runs <- run_result[grepl(implementation_regexp, run_result[,4]),]
    filtered_runs <- run_result[grepl(implementation_regexp, run_result[,4]) & run_result[,8] > roc_threshold, ]
    good_percent <- (nrow(filtered_runs) / nrow(all_runs)) * 100
  }
  c(good_percent, nrow(all_runs))
}

