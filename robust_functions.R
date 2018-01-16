#' ---
#' title: Robust Functions
#' author: "Mark Blackmore"
#' date: "`r format(Sys.Date())`"
#' output: 
#'   github_document:
#'     toc: true
#'     
#' ---

suppressWarnings(
  suppressPackageStartupMessages(
    library(tidyverse)
  )
)

#' ### An error is better than a surprise

# Define troublesome x and y
x <- c(NA, NA, NA)
y <- c( 1, NA, NA, NA)

both_na <- function(x, y) {
  # Add stopifnot() to check length of x and y
  stopifnot(length(x) == length(y))
  sum(is.na(x) & is.na(y))
}

# Call both_na() on x and y
# both_na(x, y)

#' ### An informative error is even better

# Define troublesome x and y
x <- c(NA, NA, NA)
y <- c( 1, NA, NA, NA)

both_na <- function(x, y) {
  # Replace condition with logical
  if (length(x) != length(y)) {
    # Replace "Error" with better message
    stop("x and y must have the same length", call. = FALSE)
  }  
  sum(is.na(x) & is.na(y))
}

# Call both_na() 
# both_na(x, y)

#' ### Using purrr solves the "type-consistent" problem  

df <- data.frame(
  a = 1L,
  b = 1.5,
  y = Sys.time(),
  z = ordered(1)
)

# sapply calls
A <- sapply(df[1:4], class) 
B <- sapply(df[3:4], class)
C <- sapply(df[1:2], class) 

# Demonstrate type inconsistency
str(A)
str(B)
str(C)

# Use map() to define X, Y and Z
X <- map(df[1:4], class)
Y <- map(df[3:4], class)
Z <- map(df[1:2], class)

# Use str() to check type consistency
str(X)
str(Y)
str(Z)

#' ### A type consistent solution  

col_classes <- function(df) {
  # Assign list output to class_list
  class_list <- map(df, class)
  
  # Use map_chr() to extract first element in class_list
  map_chr(class_list, 1)
}

# Check that our new function is type consistent
df %>% col_classes() %>% str()
df[3:4] %>% col_classes() %>% str()
df[1:2] %>% col_classes() %>% str()

#' ### Or fail early if something goes wrong  

col_classes <- function(df) {
  class_list <- map(df, class)
  
  # Add a check that no element of class_list has length > 1
  if (any(map_dbl(class_list, length) > 1)) {
    stop("Some columns have more than one class", call. = FALSE)
  }
  
  # Use flatten_chr() to return a character vector
  flatten_chr(class_list)
}

# Check that our new function is type consistent
# df %>% col_classes() %>% str()
# df[3:4] %>% col_classes() %>% str()
# df[1:2] %>% col_classes() %>% str()

#' ### Programming with Non Stanadard Evaluation functions

big_x <- function(df, threshold) {
  dplyr::filter(df, x > threshold)
}

diamonds_sub <- diamonds[1:5000,]

# Use big_x() to find rows in diamonds_sub where x > 7
big_x(diamonds_sub, 7)

#' ### When things go wrong  

# Remove the x column from diamonds
diamonds_sub$x <- NULL

# Create variable x with value 1
x <- 1

# Use big_x() to find rows in diamonds_sub where x > 7
big_x(diamonds_sub, x > 7)

# Create a threshold column with value 100
diamonds_sub$threshold <- 100

# Use big_x() to find rows in diamonds_sub where x > 7
big_x(diamonds_sub, x > 7)

#' ### What to do?

big_x <- function(df, threshold) {
  # Write a check for x not being in df
  if (!"x" %in% names(df)) { 
    stop("df must contain variable called x", call. = FALSE)
  }
  
  # Write a check for threshold being in df
  if ("threshold" %in% names(df)) {
    stop("df must not contain variable called threshold", call. = FALSE)
  }
  
  dplyr::filter(df, x > threshold)
}

#' ### A hidden dependence  

# Read in the swimming_pools.csv to pools
pools <- read.csv("pools.csv")

# Examine the structure of pools
str(pools)

# Change the global stringsAsFactor option to FALSE
options(stringsAsFactors = FALSE)

# Read in the swimming_pools.csv to pools2
pools2 <- read.csv("pools.csv")

# Examine the structure of pools2
str(pools2) 

#' ### Legitimate use of options  

# Fit a regression model
fit <- lm(mpg ~ wt, data = mtcars)

# Look at the summary of the model
summary(fit)

# Set the global digits option to 2
options(digits = 2)

# Take another look at the summary
summary(fit)

# Restore defaults
options(stringsAsFactors = TRUE)
options(digits = 7)


#' -------------
#'
#' ## Session info
#+ show-sessionInfo
sessionInfo()