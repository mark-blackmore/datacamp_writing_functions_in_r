#' ---
#' title: Advanced Inputs and Outputs
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
  
#' ### Creating a safe function  

# Create safe_readLines() by passing readLines() to safely()
safe_readLines <- safely(readLines)

# Call safe_readLines() on "http://example.org"
safe_readLines("http://example.org")

# Call safe_readLines() on "http://asdfasdasdkfjlda"
safe_readLines("http://asdfasdasdkfjlda")

#' ### Using map safely  

urls <- list(
  example = "http://example.org",
  rproj = "http://www.r-project.org",
  asdf = "http://asdfasdasdkfjlda"
)

# Define safe_readLines()
safe_readLines <- safely(readLines)

# Use the safe_readLines() function with map(): html
html <- map(urls, safe_readLines)

# Call str() on html
str(html)

# Extract the result from one of the successful elements
map(html, "result")

# Extract the error from the element that was unsuccessful
map(html, "error")

#' ### Working with safe output  

# Define save_readLines() and html
safe_readLines <- safely(readLines)
html <- map(urls, safe_readLines)

# Examine the structure of transpose(html)
str(transpose(html))

# Extract the results: res
res <- transpose(html)[["result"]]

# Extract the errors: errs
errs <- transpose(html)[["error"]]

#' ###  Working with errors and results  

# Initialize some objects
safe_readLines <- safely(readLines)
html <- map(urls, safe_readLines)
res <- transpose(html)[["result"]]
errs <- transpose(html)[["error"]]

# Create a logical vector is_ok
is_ok <- map_lgl(errs, is.null)

# Extract the successful results
res[is_ok]

# Extract the input from the unsuccessful results
urls[!is_ok]

#' ### Getting started  

# Create a list n containing the values: 5, 10, and 20
n <- list(5, 10, 20)

# Call map() on n with rnorm() to simulate three samples
map(n, rnorm)

#' ### Mapping over two arguments  

# Initialize n
n <- list(5, 10, 20)

# Create a list mu containing the values: 1, 5, and 10
mu <- list(1, 5, 10)

# Edit to call map2() on n and mu with rnorm() to simulate three samples
map2(n, mu, rnorm)

#' ### Mapping over more than two arguments  

# Initialize n and mu
n <- list(5, 10, 20)
mu <- list(1, 5, 10)

# Create a sd list with the values: 0.1, 1 and 0.1
sd <- list(0.1, 1, 0.1)

# Edit this call to pmap() to iterate over the sd list as well
pmap(list(n, mu, sd), rnorm)

#' ### Argument matching

# Name the elements of the argument list
pmap(list(mean=mu, n=n, sd=sd), rnorm)

#' ### Mapping over functions and their arguments  

# Define list of functions
f <- list("rnorm", "runif", "rexp")

# Parameter list for rnorm()
rnorm_params <- list(mean = 10)

# Add a min element with value 0 and max element with value 5
runif_params <- list(min = 0, max = 5)

# Add a rate element with value 5
rexp_params <- list(rate = 5)

# Define params for each function
params <- list(
  rnorm_params,
  runif_params,
  rexp_params
)

# Call invoke_map() on f supplying params as the second argument
invoke_map(f, params, n = 5)

#' ### Walk  

# Define list of functions
f <- list(Normal = "rnorm", Uniform = "runif", Exp = "rexp")

# Define params
params <- list(
  Normal = list(mean = 10),
  Uniform = list(min = 0, max = 5),
  Exp = list(rate = 5)
)

# Assign the simulated samples to sims
sims <- invoke_map(f, params, n = 50)

# Use walk() to make a histogram of each element in sims
walk(sims, hist)

#' ### Walking over two or more arguments  

# Replace "Sturges" with reasonable breaks for each sample
breaks_list <- list(
  Normal = seq(6, 16, 0.5),
  Uniform = seq(0, 5, 0.25),
  Exp = seq(0, 1.5, 0.1)
)

# Use walk2() to make histograms with the right breaks
walk2(sims, breaks_list, hist)

#' ### Putting together writing functions and walk

# Turn this snippet into find_breaks()

find_breaks <- function(x){
  rng <- range(sims[[1]], na.rm = TRUE)
  seq(rng[1], rng[2], length.out = 30)
}

# Call find_breaks() on sims[[1]]
find_breaks(sim[[1]])

#' ### Nice breaks for all

# Use map() to iterate find_breaks() over sims: nice_breaks
nice_breaks <- map(sims, find_breaks)

# Use nice_breaks as the second argument to walk2()
# Note: nice_breaks throws an error
walk2(sims, "Sturges", hist) 

#' ### Walking with many arguments: pwalk

# Increase sample size to 1000
sims <- invoke_map(f, params, n = 1000)

# Compute nice_breaks (don't change this)
nice_breaks <- map(sims, find_breaks)

# Create a vector nice_titles
nice_titles <- c("Normal(10, 1)", "Uniform(0, 5)", "Exp(5)")

# Use pwalk() instead of walk2()
pwalk(list(x = sims, breaks = "Sturges", main = nice_titles), hist, xlab = "")

#' ### Walking with pipes

# Pipe this along to map(), using summary() as .f
sims %>%
  walk(hist) %>%
  map(summary)


#' -------------
#'
#' ## Session info
#+ show-sessionInfo
sessionInfo()