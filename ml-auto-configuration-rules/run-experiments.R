# Loading external scripts
source("setup-environment.R")
source("setup-experiments.R")
source("load-openml-knowledge.R")
source("generate-dataset.R")
source("weka-utils.R")

SetupExperiments <- function() {
  SetupGlobalEnv()
  SetupExperimentGlobalEnv()
  
}

# Prepare and run first experiment
RunFirstExperiment <- function() {
  algorithmCriteria <- CreateAlgorithmsCriteria()
  FirstExperiment(algorithmCriteria, CreateRunsCriteriaA(), "DataSet1")
  FirstExperiment(algorithmCriteria, CreateRunsCriteriaB(), "DataSet2")
}

FirstExperiment <- function(algoCriteria, runsCriteria, outputFile) {
  dataSet <- data.frame()
  for (i in 1:length(algoCriteria)) {
    algorithmName <- algoCriteria[[i]][1]
    cat("---- ", algorithmName, " ----\n")
    idxs <- GetResultsWithCriteria(globalResults, algoCriteria[[i]][2], runsCriteria)
    dataSet <- rbind(dataSet, PrepareTaskDataSetChunk(globalTasks, idxs, algorithmName))
  }
  SaveARFF(dataSet, outputFile, generatedDatasetDir)
  dataSet
}

# Prepare and run second 
RunSecondExperiment <- function() {
  algorithmsCriteria <- CreateAlgorithmsCriteria()
  dataSet <- SecondExperiment(algorithmsCriteria, CreateRunsCriteriaA(), "DataSet3")
  GenerateWEKAModel("DataSet3.arff");
  SaveARFF(unique(dataSet), "DataSet3Unique", generatedDatasetDir)
  dataSet <- SecondExperiment(algorithmsCriteria, CreateRunsCriteriaB(), "DataSet4")
  GenerateWEKAModel("DataSet4.arff")
  SaveARFF(unique(dataSet), "DataSet4Unique", generatedDatasetDir)
}

SecondExperiment <- function(algoCriteria, runsCriteria, outputFile) {
  dataSet <- data.frame()
  unique_idxs <- c()
  usedDataSetNames <<- c()
  for (i in 1:length(algoCriteria)) {
    algorithmName <- algoCriteria[[i]][1]
    cat("---- ", algorithmName, " ----\n")
    idxs <- GetResultsWithCriteria(globalResults, algoCriteria[[i]][2], runsCriteria)
    if (i == 1) {
      prepare_idxs <- idxs
    } else {
      prepare_idxs <- setdiff(idxs, unique_idxs)
    }
    dataSet <- rbind.fill(dataSet, PrepareDataSetChunk(globalTasks, prepare_idxs, algorithmName))
    unique_idxs <- c(unique_idxs, setdiff(idxs, unique_idxs)) 
  }
  SaveARFF(dataSet, outputFile, generatedDatasetDir)
  dataSet
}