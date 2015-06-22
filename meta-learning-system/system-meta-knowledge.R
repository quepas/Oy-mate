library(FastImputation)
library(dplyr)

GenerateMetaAttributes <- function(meta.attr.coverage,
                                   meta.attr = envMetaAttributes,
                                   meta.attr.fill = TRUE) {
  # Filter meta-attributes with more than given non-missing value coverage.
  # Optional filling missing values with Amelia-II impuration algorithm.
  #   [Oy-mate]: Implementation of meta-attributes generator.
  #
  # Args:
  #   meta.attr.coverage: Percentage threshold for non-missing value coverage [numeric]
  #   meta.attr: Meta-attributes to filter [data.frame]
  #   meta.attr.fill: Fill missing values [logical]
  #
  # Returns:
  #   Generated meta-attributes
  meta.attr.count = nrow(meta.attr)
  meta.attr.covered <- sapply(meta.attr, function(x) {
    sum(!is.na(x))/meta.attr.count > meta.attr.coverage
  })
  meta.attr <- meta.attr[, meta.attr.covered]
  if (meta.attr.fill) {
    meta.attr <- FastImputation(meta.attr, TrainFastImputation(meta.attr))
  }
  meta.attr
}

ListNTopUsedAlgorithms <- function(N, task.evaluations = envTaskEvaluation, algorithm.regexp = "^weka.*$") {
  # Listing top N used algorithms
  #
  # Args:
  #   N: Number of algorithms to return [integer]
  #   task.evaluations: Task results [data.frame]
  #   algorithm.regexp: Algorithm name signature [character]
  #
  # Returns:
  #   Sorted (desc) algorithms with usage counter [data.frame]
  impl <- task.evaluations$implementation
  impl <- impl[grepl(algorithm.regexp, impl)]
  impl <- sub("\\(.*\\)", "", impl)
  impl <- sort(table(impl), decreasing = TRUE)
  head(data.frame(algorithm = names(impl), count = impl, row.names = c()), N)
}

FilterForAlgorithms <- function(algorithm.list, task.evaluations = envTaskEvaluation) {
  # Filtering task evaluations done by given algorithms
  #
  # Args:
  #  algorithm.list: Algorithm names [vector:character]
  #  task.evaluations: Task evaluations data [data.frame]
  #
  # Returns:
  #   Filtered task evaluations [data.frame]
  task.evaluations$implementation <- sub("\\(.*\\)", "", task.evaluations$implementation)
  filter(task.evaluations, implementation %in% algorithm.list)
}

RetriveDatasetId <- function(task.id.list, task.list = envTasks) {
  # Mapping tasks id to dataset used within it
  #
  # Args:
  #   task.id.list: Task IDs to map [vector:integer]
  #   task.list: OpenML's tasks [data.frame]
  #
  # Returns:
  #   Mappings beetwen corresponding tasks and datasets [data.frame]
  dataset.id.list <- c()
  for (id in task.id.list) {
    dataset.id.list <- c(dataset.id.list, filter(task.list, task_id == id)$did)
  }
  data.frame(task.id = task.id.list, dataset.id = dataset.id.list)
}

BuildMetaKnowledgeChunk <- function(dataset.id.list, class, meta.attributes) {
  # Combine meta-attributes for given datasets with class
  #
  # Args:
  #   dataset.id.list
  #   class: 
  #   meta.attributes: Meta-attributes
  #
  # Returns:
  #   None
  meta.attributes <- filter(meta.attributes, did %in% dataset.id.list)
  data.frame(meta.attributes[, -1], class = rep(class, nrow(meta.attributes)))
}
