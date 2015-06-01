source("WekaExtractor.R")

library(RWeka)

WEKA2HMR <- function() {
  
}

"xattr [name: class_attr,
       abbrev: class_attr,
       class: simple,
       type: class_type,
       comm: in,
       desc: 'class type'
      ]." -> class_xattr

"xtype [name: numeric,
       base: numeric,
       desc: float,
       domain: [-2147483647 to 2147483647]
      ]." -> numeric_xtype

GenerateHMR <- function(rules, dataset) {
  hmr <- numeric_xtype
  # generate class xtype
  hmr <- paste(hmr, GenerateHMRClassType(dataset$class), sep = "\n")
  # generate class xattr
  hmr <- paste(hmr, class_xattr, sep = "\n")
  # generate meta xattr
  attributes <- names(dataset)
  attributes <- attributes[-length(attributes)]
  for (attr in attributes) {
    attr <- paste("'", attr, "'", sep = "");
    hmr <- paste(hmr, GenerateHMRAttr(attr), sep = "\n")
  }
  # generate xschm
  hmr <- paste(hmr, GenerateHMRSchm(attributes), sep = "\n")
  # generate rules
  rule_counter <- 1
  for (rule in rules) {
    hmr <- paste(hmr, GenerateHMRRule(rule, rule_counter), sep = "\n");
    rule_counter <- rule_counter + 1
  }
  hmr
}

GenerateHMRRule <- function(rule, id) {
  text <- paste("\nxrule meta/", id, ":\n\t\t[", sep="")
  all <- c()
  class <- ""
  lapply(ExtractSubrules(rule), function(subrule) {
    if (length(subrule) == 3) {
      subrule[1] <- paste("'", subrule[1], "'", sep = "")
      subrule[2] <- ConvertOperator(subrule[2])
      all <<- c(all, paste(paste(subrule, collapse=' '), sep=""))
    } else {
      class <<- subrule
    }
  })
  paste(text, paste(all, collapse=",\n\t\t "), "]\n\t==>\n\t\t[class_attr set '", class, "'].", sep="")
}

GenerateHMRAttr <- function(attribute) {
  paste("xattr [name: ", attribute, ",",
         "\n\t\t\t abbrev: ", attribute, ",",
         "\n\t\t\t class: simple,",
         "\n\t\t\t type: numeric,",
         "\n\t\t\t comm: in,",
         "\n\t\t\t desc: 'meta attribute'",
         "\n\t\t\t].", sep = "")
}

GenerateHMRClassType <- function(classes) {
  str_classes <- paste("'", unique(classes), "'", sep = "", collapse = ",")
  paste("xtype [name: class_type,",
        "\n\t\t\t base: symbolic,",
        "\n\t\t\t domain: [",
        str_classes, "]",
        "\n\t\t\t].", sep = "")
}

GenerateHMRSchm <- function(attributes) {
  paste("xschm meta: [", paste("'", attributes, "'", sep = "", collapse = ", "), "] ==> [class_attr].", sep = "")
}

ConvertOperator <- function(operator) {
  switch(operator, 
         "=" = "eq",
         "<=" = "lte",
         ">=" = "gte",
         "<" = "lt",
         ">" = "gt")
}
