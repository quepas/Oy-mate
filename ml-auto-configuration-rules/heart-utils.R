PrepareHeader <- function() {
  ":- ensure_loaded('../heart.pl')."
}

PrepareXType <- function() {
  integerXType <- "xtype [name: integer,
       base: numeric,
       length: 9,
       scale: 0,
       desc: integer,
       domain: [-999999999 to 999999999]
      ]."
  integerXType
}

PrepareXAttr <- function() {
  
}

PrepareXStat <- function() {
  
}

PrepareXSchm <- function() {
  
}

PrepareSingleRule <- function() {
  
}

PrepareXRule <- function() {
  
}

PrepareHMR <- function() {
  paste(PrepareHeader(), 
        PrepareXType(), 
        sep="\n\n")
}
