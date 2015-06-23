BuildMetaRules <- function(hmr.file, meta.knowledge, hmr.directory = "meta-rules/") {
  tree <- CheckBuild(meta.knowledge)
  rules <- ParseRWekaTree(tree)
  hmr <- GenerateHMR(rules, meta.knowledge)
  write(hmr, paste(hmr.directory, hmr.file, sep = ""))
}
