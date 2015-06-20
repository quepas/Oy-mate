library(plyr)

rbind.fill.left <- function(dataset.left, dataset.right) {
  # Row binding right dataset with left dataset using 
  #   left columns, filling missing right columns with 'NA'.
  #
  # Args:
  #   dataset.a: Left, base dataset [data.frame]
  #   dataset.b: Right dataset to join [data.frame]
  #
  # Returns:
  #   Extended, filled left dataset.a [data.frame]
  result <- rbind.fill(dataset.left, dataset.right)
  result[, names(dataset.left)]
}

EvalExpression <- function(expression) {
  # Evaluate given text expression with current environment.
  #
  # Args:
  #    expression: Expression to evaluate [character]
  #
  # Returns:
  #   None
  eval(parse(text = expression))
}
