library(RWeka)

source('system-hmr-generator.R')
source('system-weka-extractor.R')

BuildMetaRules <- function(hmr.file, meta.knowledge, hmr.directory = "meta-rules/", statistics) {
  tree <- BuildRuleBase(meta.knowledge, statistics)
  rules <- ParseRWekaTree(tree)
  hmr <- GenerateHMR(rules, meta.knowledge)
  write(hmr, paste(hmr.directory, hmr.file, sep = ""))
}

BuildRuleBase <- function(build, statistics) {
  classifier <- J48(class ~ ., data = build, control = Weka_control(U = TRUE))
  sink(file = statistics, append = TRUE)
  print(classifier)
  print(evaluate_Weka_classifier(classifier, numFolds = 10, complexity = F))
  sink()
  classifier
}

GenerateMetaAttributesCSV <- function(file.name, meta.attributes = envMetaAttributes) {
  write.csv(meta.attributes, file.name, row.names = FALSE)
}
