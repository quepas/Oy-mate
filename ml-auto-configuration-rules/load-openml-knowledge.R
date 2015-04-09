library(OpenML)

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
