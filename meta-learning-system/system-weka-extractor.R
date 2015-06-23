library(rJava)
# 1. Tokenize
# 2. Find rule level
# 3. Extract rule elements
#

ParseWEKATree <- function(treeText) {
  rules <- list()
  subrules <- c()
  level <- 0
  rule_counter <- 1

  for (line in strsplit(treeText, "\n", fixed = TRUE)[[1]]) {
    tokens <- strsplit(line, "[ :]", fixed = FALSE)[[1]]
    # remove empty tokens
    tokens <- tokens[tokens != ""]
    level <- length(tokens[tokens == "|"])
    if (level == 0) {
      subrules <- c()
    } else {
      subrules <- subrules[1:(level*3)]
    }
    # remove level indicators
    tokens <- tokens[tokens != "|"]
    ntokens <- length(tokens)
    if (ntokens == 3) {
      subrules <- c(subrules, tokens)
    } else if (ntokens == 5) {
      level <- level - 1
      rules[[rule_counter]] <- c(subrules, tokens[1:4])
      rule_counter <- rule_counter + 1
    } else {
      warning("Bad sub/end rule!")
    }
	}
  rules
}

ParseRWekaTree <- function(tree) {
  weka_tree <- as.matrix(scan(text = .jcall(tree$classifier, "S", "toString"), sep = "\n", what = ""))
  tree_line <- length(weka_tree)
  weka_tree <- weka_tree[-c(1, 2, tree_line, tree_line-1)]
  weka_tree <- paste(weka_tree, collapse = "\n")
  ParseWEKATree(weka_tree)
}

ExtractSubrules <- function(rule) {
  split(rule, as.integer((seq_along(rule) - 1) / 3))
}
