#' ---
#' title: When and how you should write a function
#' author: "Mark Blackmore"
#' date: "`r format(Sys.Date())`"
#' output: 
#'   github_document:
#'     toc: true
#'     
#' ---
#'
#' ### Start with a code snippet

# Define example vector x
x <- 1:10

# Rewrite this snippet to refer to x
(x - min(x, na.rm = TRUE)) /
  (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

#' ### Rewrite for clarity  

# Define example vector x
x <- 1:10

# Define rng
rng <- range(x, na.rm = TRUE)

# Rewrite this snippet to refer to the elements of rng
(x - rng[1]) /
  (rng[2] - rng[1])

#' ### Finally turn it into a function  

# Define example vector x
x <- 1:10 

# Use the function template to create the rescale01 function
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE) 
  (x - rng[1]) / (rng[2] - rng[1])
}

# Test your function, call rescale01 using the vector x as the argument
rescale01(x)

#' ### Start ith a simple problem  

# Define example vectors x and y
x <- c( 1, 2, NA, 3, NA)
y <- c(NA, 3, NA, 3,  4)

# Count how many elements are missing in both x and y
sum(is.na(x) & is.na(y))

#' ### Rewrite snippet as function  

# Define example vectors x and y
x <- c( 1, 2, NA, 3, NA)
y <- c(NA, 3, NA, 3,  4)

# Turn this snippet into a function: both_na()
both_na <- function(x, y){
  sum(is.na(x) & is.na(y))
}

#' ### Put our function to use  

# Define x, y1 and y2
x <-  c(NA, NA, NA)
y1 <- c( 1, NA, NA)
y2 <- c( 1, NA, NA, NA)

# Call both_na on x, y1
both_na(x, y1)

# Call both_na on x, y2
## both_na(x, y2) returns an error

#' ### Argument names  

# Rewrite mean_ci to take arguments named level and x
mean_ci <- function(level, x) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - level
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

mean_ci(0.95, 1:10)

#' ### Argument order  

# Alter the arguments to mean_ci - dtat arg first, detail arg after
mean_ci <- function(x, level = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - level
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

#' ### Return statements  

# Notice what happens with an empty vector
mean_ci(numeric(0))

# Alter the mean_ci function to address empty vector input
mean_ci <- function(x, level = 0.95) {
  if(length(x) == 0) {
    warning("'x' was empty", call. = FALSE)
    return(c(-Inf, Inf))
  }
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - level
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

# Test
mean_ci(numeric(0))
mean_ci(1:10, 0.95)


#' ### What does this function do?

f <- function(x, y) {
  x[is.na(x)] <- y
  cat(sum(is.na(x)), y, "\n")
  x
}

# Define a numeric vector x with the values 1, 2, NA, 4 and 5
x <- c(1, 2, NA, 4, 5)

# Call f() with the arguments x = x and y = 3
f(x=x, y=3)

# Call f() with the arguments x = x and y = 10
f(x=x, y=10)

#' ### Let's make it clear from its name

# Rename the function f() to replace_missings()
replace_missings <- function(x, replacement) {
  # Change the name of the y argument to replacement
  x[is.na(x)] <- replacement
  cat(sum(is.na(x)), replacement, "\n")
  x
}

# Rewrite the call on z to match our new names
z <- c(1, 2, NA, 4, 5)
z <- replace_missings(z, 0)

#' ### Make the body more understandable  

replace_missings <- function(x, replacement) {
  # Define is_miss
  is_miss <- is.na(x)
  # Rewrite rest of function to refer to is_miss
  x[is_miss] <- replacement
  cat(sum(is_miss), replacement, "\n")
  x
}

z <- replace_missings(z, 0)

#' ### Much better! But a few more tweaks  

# replace_missings() throws an error

replace_missings <- function(x, replacement) {
  is_miss <- is.na(x)
  x[is_miss] <- replacement
  
  # Rewrite to use message()
  message(sum(is_miss), " missings replaced by the value ", replacement)
  x
}


# Check your new function by running on dfz$z
dfz <- data.frame(z = c(1.2242865, 0.9648116, NA, 3.0548305, 0.4427162,
                         -0.1479685, 0.6688705, 0.4171186, 0.5109801, NA))
replace_missings(dfz$z, 0)

#' -------------
#'  
#' ## Session info
#+ show-sessionInfo
sessionInfo()   
