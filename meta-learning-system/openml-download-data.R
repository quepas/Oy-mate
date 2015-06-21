library(OpenML)

source('data-utils.R')

DownloadOpenMLTasks <- function(type.name = "Supervised Classification") {
  # Download OpenML tasks with given type.
  #
  # Args:
  #   type.name: Name of task type (e.g. "Supervised Classification") [character]
  #
  # Returns:
  #   OpenML's tasks [data.frame]
  type.list <- listOMLTaskTypes()
  type.id <- with(type.list, id[name == type.name])
  listOMLTasks(type = type.id)
}

DownloadOpenMLMetaAttributes <- function(dataset.id.list) {
  # Download OpenML meta attributes of datasets with given IDs.
  #
  # Args:
  #   id.list: Vector of dataset identificators [vector:integer]
  #
  # Returns:
  #   Meta attributes [data.frame]
  meta.attributes <- data.frame()
  for (id in dataset.id.list) {
    qualities <- listOMLDataSetQualities(id)
    names <- c("did", qualities[[1]])
    values <- c(id, qualities[[2]])
    entry <- data.frame(matrix(dat = NA, ncol = length(names), nrow = 0))
    colnames(entry) <- names
    entry[1, ] <- values
    meta.attributes <- rbind.fill(meta.attributes, entry)
  }
  meta.attributes
}

DownloadOpenMLDatasets <- function(dataset.status = c("active")) {
  # Download all dataset with "active" status.
  #
  # Args:
  #   dataset.status: status of downloaded datasets [Vector:string(active|deactivated|in_preparation)]
  #
  # Returns:
  #   Datasets [data.frame]
  listOMLDataSets(status = dataset.status)
}

DownloadOpenMLTaskEvaluation <- function(task.id.list) {
  # Download learning evaluation for given tasks.
  #
  # Args:
  #   task.id.list: Vector of task identificators [Vector:integer]
  #
  # Returns:
  #   Learning evaluation [data.frame]
  task.evaluation <- data.frame()
  for (id in task.id.list) {
    task.evaluation <- rbind.fill(task.evaluation, listOMLRunResults(id))
  }
  task.evaluation
}

DownloadOpenMLResources <- function(username = "openml.rteam@gmail.com", password = "testpassword", only.meta.evaluations = FALSE) {
  session.hash <<- authenticateUser(username, password)
  if (!only.meta.evaluations) {
    envDatasets <<- DownloadOpenMLDatasets()
    envMetaAttributes <<- DownloadOpenMLMetaAttributes(envDatasets$did)
    envTasks <<- DownloadOpenMLTasks()
  } else {
    # uncomment needed part
    #envTaskEvaluations <<- DownloadOpenMLTaskEvaluation(task.id.list = envTasks[1:500, ]$task_id)
    #envTaskEvaluations <<- rbind(envTaskEvaluations, DownloadOpenMLTaskEvaluation(task.id.list = envTasks[501:1000, ]$task_id))
    #envTaskEvaluations <<- rbind(envTaskEvaluations, DownloadOpenMLTaskEvaluation(task.id.list = envTasks[1001:1500, ]$task_id))
    envTaskEvaluations <<- rbind(envTaskEvaluations, DownloadOpenMLTaskEvaluation(task.id.list = envTasks[1501:1729, ]$task_id))
  }
}
