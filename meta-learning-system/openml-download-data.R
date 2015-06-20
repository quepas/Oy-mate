library(OpenML)

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

DownloadOpenMLTaskResults <- function(task.id.list) {
  # Download learning results for given tasks.
  #
  # Args:
  #   task.id.list: Vector of task identificators [Vector:integer]
  #
  # Returns:
  #   Learning results [data.frame]
  task.results <- data.frame()
  for (id in task.id.list) {
    task.results <- rbind.fill(task.results, listOMLRunResults(id))
  }
  task.results
}
