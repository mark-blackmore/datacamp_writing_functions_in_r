#' ---
#' title: Quick refresher
#' author: "Mark Blackmore"
#' date: "`r format(Sys.Date())`"
#' output: 
#'   github_document:
#'     toc: true
#'     
#' ---
#'
#' ### Writing a function

# Define ratio() function
ratio <- function(x, y) {
  x/y
}

# Call ratio() with arguments 3 and 4
ratio(3, 4)

# Rewrite the call to follow best practices
mean(c(1:9, NA), trim = 0.1, na.rm = TRUE)

# Function output
f <- function(x) {
  if (TRUE) {
    return(x + 1)
  }
  x
}

f(2)

#' ### Testing your understanding of scoping (1)

y <- 10
f <- function(x) {
  x + y
}

f(10)


#' ### Testing your understanding of scoping (2)

y <- 10
f <- function(x) {
  y <- 5
  x + y
}

f(10)

#' ### Testing your understanding of scoping (3)

rm(list = ls())
f <- function(x) {
  y <- 5
  x + y
}
f(5)

# now, calling y returns an error

#' ### Subsetting lists  

rm(list = ls())

# Create a list
tricky_list = list(
  nums = c(-1.13171455, -0.90888158, -0.86307629, -0.48236520, -0.46887554,
         -0.67455525, 0.06206395, 0.16914475, 0.84829313, -0.14515730),
  y    = c(FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE),
  x    = list("hello!", "hi!", "goodbye!", "bye!"),
  model = lm(mpg ~ wt, data = mtcars))

# 2nd element in tricky_list
typeof(tricky_list[[2]])

# Element called x in tricky_list
typeof(tricky_list[["x"]])

# 2nd element inside the element called x in tricky_list
typeof(tricky_list[["x"]][[2]])

#' ### Exploring lists  

# Guess where the regression model is stored
names(tricky_list)

# Use names() and str() on the model element
names(tricky_list[["model"]])
str(tricky_list[["model"]])

# Subset the coefficients element
tricky_list[["model"]][["coefficients"]]

# Subset the wt element
tricky_list[["model"]][["coefficients"]][["wt"]]

#' ### A safr way to create the sequence

df <- data.frame(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
) 

# Replace the 1:ncol(df) sequence
for (i in seq_along(df)) {
  print(median(df[[i]]))
}

# Change the value of df
df <- data.frame()

# Repeat for loop to verify there is no error
for (i in seq_along(df)) {
  print(median(df[[i]]))
}

#' ### Keeping output

df <- data.frame(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# Create new double vector: output
output <- vector("double", ncol(df))

# Alter the loop
for (i in seq_along(df)) {
  # Change code to store result in output
  output[[i]] = median(df[[i]])
}

# Print output
output

#' -------------
#'  
#' ## Session info
#+ show-sessionInfo
sessionInfo()   




