#' ---
#' title: Functional programming
#' author: "Mark Blackmore"
#' date: "`r format(Sys.Date())`"
#' output: 
#'   github_document:
#'     toc: true
#'     
#' ---
#'
#' ### Using a for loop to remove duplication  

df <- data.frame(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10))



# Initialize output vector
output <- vector("double", ncol(df))  

# Fill in the body of the for loop
for (i in seq_along(df)) {            
  output[[i]] = median(df[[i]])
}

# View the result
output

#' ### Turning the for loop into a function  

# Turn this code into col_median()
col_median <- function(df){
  output <- vector("double", ncol(df))  
  for (i in seq_along(df)) {            
    output[[i]] <- median(df[[i]])      
  }
  output
}

col_median(df)
