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

DownloadOpenMLMetaAttributes <- function(id.list) {
  # Download OpenML meta attributes of datasets with given IDs.
  #
  # Args:
  #   id.list: Vector of dataset identificators [vector:integer]
  #
  # Returns:
  #   Meta attributes [data.frame]
  qualities <- data.frame()
  for (id in id.list) {
    row <- PrepareDataSetQualities(id, listOMLDataSetQualities(id))
    qualities <- rbind.fill(qualities, row)
  }
  qualities
}
