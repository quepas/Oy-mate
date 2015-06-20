library(FastImputation)

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
