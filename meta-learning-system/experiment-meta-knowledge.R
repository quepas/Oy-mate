source('system-meta-knowledge.R')

ClassicBuild <- function() {
  meta.attributes <- GenerateMetaAttributes(meta.attr.coverage = 0.3, meta.attr = envMetaAttributes, meta.attr.fill = TRUE)
  algorithm.list <- ListNTopUsedAlgorithms(2, task.evaluations = envTaskEvaluations)$algorithm
  
  FilterForAlgorithms(algorithm.list, task.evaluations = envTaskEvaluations) %>%
    filter(area.under.roc.curve > 0.99) -> task.evaluations
  task.to.dataset <- RetriveDatasetId(task.evaluations$task.id)
  
  meta.knowledge <- data.frame()
  
  for (algorithm in algorithm.list) {
    task.eval <- subset(task.evaluations, implementation == algorithm)
    task.id.list <- task.eval$task.id
    dataset.id <- unique(RetriveDatasetId(task.id.list)$dataset.id)
    meta.knowledge <- rbind(meta.knowledge, BuildMetaKnowledgeChunk(dataset.id, algorithm, meta.attributes))
  }
  CheckBuild(meta.knowledge)
}

CheckBuild <- function(build) {
  classifier <- J48(class ~ ., data = build, control = Weka_control(U = TRUE))
  print(classifier)
  print(evaluate_Weka_classifier(classifier, numFolds = 10))
}
