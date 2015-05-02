# 1. Tokenize
# 2. Find rule level
# 3. Extract rule elements
#

ParseWEKATree <- function(treeText) {
  rules <- list()
  subrules <- c()
  level <- 0

  for (line in strsplit(treeText, "\n", fixed = TRUE)[[1]]) {
    tokens <- strsplit(line, "[ :]", fixed = FALSE)[[1]]
    # remove empty tokens
    tokens <- tokens[tokens != ""]
    level <- length(tokens[tokens == "|"])
    if (level == 0) {
      subrules <- c()
    } else {
      subrules <- subrules[1:level*3]
    }
    # remove level indicators
    tokens <- tokens[tokens != "|"]
    ntokens <- length(tokens)
    if (ntokens == 3) {
      subrules <- c(subrules, tokens)
    } else if (ntokens == 5) {
      level <- level - 1
      rules <- list(rules, c(subrules, tokens[1:4]))
    } else {
      warning("Bad sub/end rule!")
    }
	}
  rules
}
