MetaAttributesValuesCoverage <- function(meta_attributes = globalQualities) {
  sapply(meta_attributes, function(col) sum(!is.na(col)))/nrow(meta_attributes)
}
