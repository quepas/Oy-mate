library(OpenML)
library(plyr)

# Loading all needed OML data into global env.
LoadOMLDataIntoGlobalEnv <- function() {
  session.hash <<- authenticateUser(username = "openml.rteam@gmail.com", password = "testpassword")

  globalTasks <<- LoadOMLTasks("Supervised Classification")
  globalDataSets <<- listOMLDataSets(status = c("active"))
  globalQualities <<- LoadOMLDataSetsQualities(globalDataSets[globalDataSets$did != 1415, 1])
  globalResults <<- LoadOMLTaskResults(globalTasks[, 1])
}

# Loading all tasks with given type (ex. "Supervised Classification")
LoadOMLTasks <- function(taskTypeName) {
  taskTypes <- listOMLTaskTypes()
  type.id <- with(taskTypes, id[name == taskTypeName])
  tasks <- listOMLTasks(type = type.id)
  tasks
}

# Loading qualities for given data sets ids
LoadOMLDataSetsQualities <- function(dataSetID) {
  qualities <- data.frame()
  for (dataSetID in dataSetID) {
    row <- PrepareDataSetQualities(dataSetID, listOMLDataSetQualities(dataSetID))
    qualities <- rbind.fill(qualities, row)
  }
  qualities
}

# Loading all run results for given tasks
LoadOMLTaskResults <- function(taskIDs) {
  runs <- data.frame()
  for (id in taskIDs) {
    runs <- rbind.fill(runs, listOMLRunResults(id))
  }
  runs
}

# Loading run results for given tasks range
LoadOMLTaskResultsFromTo <- function(tasks, from, to) {
  results <- list()
  index <- 1
  for (i in from:to) {
    if (i > nrow(tasks)) break
    results[[index]] <- listOMLRunResults(tasks[i, 1]);
    index <- index + 1
  }
  results
}

PrepareDataSetQualities <- function(did, quality) {
  names <- quality[[1]]
  data <- data.frame(matrix(dat = NA, ncol = length(names)+ 1, nrow = 0))
  colnames(data) <- c("did", names)
  data[1, ] <- c(did, quality[[2]])
  data
}

QualitiesListToDataFrame <- function(qualities) {
  result <- data.frame()
  for (i in 1:length(qualities)) {
    result <- rbind.fill(result, qualities[[i]])
  }
  result
}
