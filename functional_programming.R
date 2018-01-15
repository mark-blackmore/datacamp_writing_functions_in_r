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

#' ### What about column means?   

# Create col_mean() function to find column means
col_mean <- function(df) {
  output <- numeric(length(df))
  for (i in seq_along(df)) {
    output[[i]] <- mean(df[[i]])
  }
  output
}

col_mean(df)

#' ### What about column standard deviations?  

# Define col_sd() function
col_sd <- function(df) {
  output <- numeric(length(df))
  for (i in seq_along(df)) {
    output[[i]] <- sd(df[[i]])
  }
  output
}

col_sd(df)

#' ### Uh oh...time to write a function again  

# Add a second argument called power
f <- function(x, power) {
  # Edit the body to return absolute deviations raised to power
  abs(x - mean(x)) ^ power
}

# Add a second argument called power
f <- function(x, power) {
  # Edit the body to return absolute deviations raised to power
  abs(x - mean(x)) ^ power
}


#' ### Using a function as an argument  

col_summary <- function(df, fun) {
  output <- vector("numeric", length(df))
  for (i in seq_along(df)) {
    output[[i]] <- fun(df[[i]])
  }
  output
}

# Find the column medians using col_median() and col_summary()
col_median(df)
col_summary(df, fun = median)

# Find the column means using col_mean() and col_summary()
col_mean(df)
col_summary(df, fun = mean)

# Find the column IQRs using col_summary()
col_summary(df, fun = IQR)

#' ### The map functions  

# Load the purrr package
library(purrr)

# Use map_dbl() to find column means
map_dbl(df, mean)

# Use map_dbl() to column medians
map_dbl(df, median)

# Use map_dbl() to find column standard deviations
map_dbl(df, sd)

#' ### The ... argument to the map functions  

planes <- data.frame(year = c(1956, 1975, 1977, 1996, 2010, NA),
                     engines = c(4, 1, 2, 2, 2, 1),
                     seats = c(102, 4, 139, 142, 20, 2),
                     speed = c(232, 108, 432, NA, NA, NA)) 

# Find the mean of each column
map_dbl(planes, mean)

# Find the mean of each column, excluding missing values
map_dbl(planes, mean, na.rm = TRUE)

# Find the 5th percentile of each column, excluding missing values
map_dbl(planes, quantile, 0.05, na.rm = TRUE)

#' ### Picking the right map function  

df3 <- data.frame(A = c(0.5123748, -0.5320614, -0.9896766,  0.1467971,  0.5180139,  
                        1.6141701, 1.1358714,  1.9706641, -0.8599646, -1.5132293 ),
                  B = c("A", "B", "A", "B", "A", "B", "A", "B", "A", "B"),
                  C = 1:10,
                  D = c(0.07360872, -0.10654830,  1.02213489, -0.08360299,  1.32206949,
                        1.13624467, 0.57766900,  0.61217352,  0.34261408,  0.37195776))

# Find the columns that are numeric
map_lgl(df3, is.numeric)

# Find the type of each column
map_chr(df3, typeof)

# Find a summary of each column
map(df3, summary)

#' ### Solve a simple problem first  

cyl <- split(mtcars, mtcars$cyl)
# Examine the structure of cyl
str(cyl)

# Extract the first element into four_cyls
four_cyls <- cyl[[1]]

# Fit a linear regression of mpg on wt using four_cyls
lm(mpg ~ wt, four_cyls )

#' ### Using an anonymous function  

fit_reg <- function(df) {
  lm(mpg ~ wt, data = df)
}

# Call user written function
map(cyl, fit_reg)

# Rewrite to call an anonymous function
map(cyl, function(df) lm(mpg ~ wt, data = df))

#' ### Using a formula  

# Rewrite to use the formula shortcut instead
map(cyl, ~ lm(mpg ~ wt, data = .))

#' ### Using a string  

# Save the result from the previous exercise to the variable models
models <- map(cyl, ~ lm(mpg ~ wt, data = .))

# Use map and coef to get the coefficients for each model: coefs
coefs <- map(models, coef)

# Use string shortcut to extract the wt coefficient 
map(coefs, "wt")

#' ### Using a numeric vector 

coefs <- map(models, coef)

# use map_dbl with the numeric shortcut to pull out the second element
map_dbl(coefs, 2)

#' ### Putting it together with pipes  

# Define models (don't change)
models <- mtcars %>% 
  split(mtcars$cyl) %>%
  map(~ lm(mpg ~ wt, data = .))

# Rewrite to be a single command using pipes 
models %>% map(summary) %>% map_dbl("r.squared")


