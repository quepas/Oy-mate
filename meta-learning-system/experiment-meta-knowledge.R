source('system-meta-knowledge.R')
source('experiment-framework.R')

# Each experiment varies from each other by parameters:
# Parameters:
#   meta.attr.coverage: Meta-attributes non-NA values coverage [numeric]
#   meta.attr.fill: Flag for doing Amelia-II based filling NA values [logical]
#   meta.attr.csv.file: File name for CSV with meta-attributes values [character]
#   top.used.N: Number of top used algorithm to use [integer]
#   filter_criteria: dplyr based criteria for learning measures [unknown]
#   hmr.file: Name of HMR file with builded meta-rules [character]
#

ClassicBuild <- function() {
  meta.attributes <- GenerateMetaAttributes(meta.attr.coverage = 0.3, meta.attr = envMetaAttributes, meta.attr.fill = TRUE)
  print(ncol(meta.attributes)-1)
  print(meta.attributes[1:5, ])
  GenerateMetaAttributesCSV("meta_attributes.csv", meta.attributes)
  algorithm.list <- ListNTopUsedAlgorithms(10, task.evaluations = envTaskEvaluations)$algorithm
   
  FilterForAlgorithms(algorithm.list, task.evaluations = envTaskEvaluations) %>%
    filter(area.under.roc.curve > 0.98) -> task.evaluations
  task.to.dataset <- RetriveDatasetId(task.evaluations$task.id)
  
  meta.knowledge <- data.frame()
  
  for (algorithm in algorithm.list) {
    task.eval <- subset(task.evaluations, implementation == algorithm)
    task.id.list <- task.eval$task.id
    dataset.id <- unique(RetriveDatasetId(task.id.list)$dataset.id)
    meta.knowledge <- rbind(meta.knowledge, BuildMetaKnowledgeChunk(dataset.id, algorithm, meta.attributes))
  }
  BuildMetaRules(hmr.file = "ClassicBuild.hmr", meta.knowledge = meta.knowledge)
}

TheBuild <- function(name, coverage, N, learning_criteria, ma = envMetaAttributes) {
  # empty the file
  name <- paste("experiments", name, sep="/")
  write("", file = paste(name, "statistics.txt", sep="_"))
  meta.attributes <- GenerateMetaAttributes(meta.attr.coverage = coverage, meta.attr = ma, meta.attr.fill = TRUE)
  meta.attr.count <- ncol(meta.attributes)-1
  write(paste("Number of meta-attributes used: ", meta.attr.count), file = paste(name, "statistics.txt", sep="_"), append = T)
  GenerateMetaAttributesCSV(paste(name, "meta_attributes.csv", sep = "_"), meta.attributes)
  algorithm.list <- ListNTopUsedAlgorithms(N, task.evaluations = envTaskEvaluations)$algorithm
  evaluations <- FilterForAlgorithms(algorithm.list, task.evaluations = envTaskEvaluations)
  filter_(evaluations, learning_criteria) -> task.evaluations
  task.to.dataset <- RetriveDatasetId(task.evaluations$task.id)
  meta.knowledge <- data.frame()
  dataset.id.used <- c()
  for (algorithm in algorithm.list) {
    task.eval <- subset(task.evaluations, implementation == algorithm)
    task.id.list <- task.eval$task.id
    dataset.id <- unique(RetriveDatasetId(task.id.list)$dataset.id)
    dataset.id.used <- c(dataset.id.used, dataset.id)
    meta.knowledge <- rbind(meta.knowledge, BuildMetaKnowledgeChunk(dataset.id, algorithm, meta.attributes))
  }
  #meta.knowledge <- unique(meta.knowledge)
  dataset.used <- data.frame(did=sort(unique(dataset.id.used)));
  write.csv(dataset.used, file = paste(name, "did.csv", sep="_"), row.names = FALSE, sep = ",")
  sink(file = paste(name, "statistics.txt", sep="_"), append = T)
  print(table(meta.knowledge$class))
  sink()
  BuildMetaRules(hmr.file = paste(name, "hmr", sep = "."), meta.knowledge = meta.knowledge, hmr.directory = "", statistics = paste(name, "statistics.txt", sep="_"))
}

#crit <- "area.under.roc.curve >= 0.99 & predictive.accuracy >= 0.99"
crit <- "area.under.roc.curve >= 0.9"
name <- "AUC90"
TheBuild(paste(name, "_A_5", sep = ""), 1.0, 5, crit)
TheBuild(paste(name, "_A_15", sep = ""), 1.0, 15, crit)
TheBuild(paste(name, "_A_50", sep = ""), 1.0, 50, crit)
TheBuild(paste(name, "_B_5", sep = ""), 0.6, 5, crit)
TheBuild(paste(name, "_B_15", sep = ""), 0.6, 15, crit)
TheBuild(paste(name, "_B_50", sep = ""), 0.6, 50, crit)
MetaAttributesWithout32_36 <- envMetaAttributes[, -c(32, 36)]
TheBuild(paste(name, "_C_5", sep = ""), 0.2, 5, crit, MetaAttributesWithout32_36)
TheBuild(paste(name, "_C_15", sep = ""), 0.2, 15, crit, MetaAttributesWithout32_36)
TheBuild(paste(name, "_C_50", sep = ""), 0.2, 50, crit, MetaAttributesWithout32_36)
