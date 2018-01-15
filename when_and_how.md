When and how you should write a function
================
Mark Blackmore
2018-01-15

-   [Start with a code snippet](#start-with-a-code-snippet)
-   [Rewrite for clarity](#rewrite-for-clarity)
-   [Finally turn it into a function](#finally-turn-it-into-a-function)
-   [Start ith a simple problem](#start-ith-a-simple-problem)
-   [Rewrite snippet as function](#rewrite-snippet-as-function)
-   [Put our function to use](#put-our-function-to-use)
-   [Argument names](#argument-names)
-   [Argument order](#argument-order)
-   [Return statements](#return-statements)
-   [What does this function do?](#what-does-this-function-do)
-   [Let's make it clear from its name](#lets-make-it-clear-from-its-name)
-   [Make the body more understandable](#make-the-body-more-understandable)
-   [Much better! But a few more tweaks](#much-better-but-a-few-more-tweaks)
-   [Session info](#session-info)

### Start with a code snippet

``` r
# Define example vector x
x <- 1:10

# Rewrite this snippet to refer to x
(x - min(x, na.rm = TRUE)) /
  (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
```

    ##  [1] 0.0000000 0.1111111 0.2222222 0.3333333 0.4444444 0.5555556 0.6666667
    ##  [8] 0.7777778 0.8888889 1.0000000

### Rewrite for clarity

``` r
# Define example vector x
x <- 1:10

# Define rng
rng <- range(x, na.rm = TRUE)

# Rewrite this snippet to refer to the elements of rng
(x - rng[1]) /
  (rng[2] - rng[1])
```

    ##  [1] 0.0000000 0.1111111 0.2222222 0.3333333 0.4444444 0.5555556 0.6666667
    ##  [8] 0.7777778 0.8888889 1.0000000

### Finally turn it into a function

``` r
# Define example vector x
x <- 1:10 

# Use the function template to create the rescale01 function
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE) 
  (x - rng[1]) / (rng[2] - rng[1])
}

# Test your function, call rescale01 using the vector x as the argument
rescale01(x)
```

    ##  [1] 0.0000000 0.1111111 0.2222222 0.3333333 0.4444444 0.5555556 0.6666667
    ##  [8] 0.7777778 0.8888889 1.0000000

### Start ith a simple problem

``` r
# Define example vectors x and y
x <- c( 1, 2, NA, 3, NA)
y <- c(NA, 3, NA, 3,  4)

# Count how many elements are missing in both x and y
sum(is.na(x) & is.na(y))
```

    ## [1] 1

### Rewrite snippet as function

``` r
# Define example vectors x and y
x <- c( 1, 2, NA, 3, NA)
y <- c(NA, 3, NA, 3,  4)

# Turn this snippet into a function: both_na()
both_na <- function(x, y){
  sum(is.na(x) & is.na(y))
}
```

### Put our function to use

``` r
# Define x, y1 and y2
x <-  c(NA, NA, NA)
y1 <- c( 1, NA, NA)
y2 <- c( 1, NA, NA, NA)

# Call both_na on x, y1
both_na(x, y1)
```

    ## [1] 2

``` r
# Call both_na on x, y2
## both_na(x, y2) returns an error
```

### Argument names

``` r
# Rewrite mean_ci to take arguments named level and x
mean_ci <- function(level, x) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - level
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

mean_ci(0.95, 1:10)
```

    ## [1] 3.623477 7.376523

### Argument order

``` r
# Alter the arguments to mean_ci - dtat arg first, detail arg after
mean_ci <- function(x, level = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - level
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}
```

### Return statements

``` r
# Notice what happens with an empty vector
mean_ci(numeric(0))
```

    ## [1] NA NA

``` r
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
```

    ## Warning: 'x' was empty

    ## [1] -Inf  Inf

``` r
mean_ci(1:10, 0.95)
```

    ## [1] 3.623477 7.376523

### What does this function do?

``` r
f <- function(x, y) {
  x[is.na(x)] <- y
  cat(sum(is.na(x)), y, "\n")
  x
}

# Define a numeric vector x with the values 1, 2, NA, 4 and 5
x <- c(1, 2, NA, 4, 5)

# Call f() with the arguments x = x and y = 3
f(x=x, y=3)
```

    ## 0 3

    ## [1] 1 2 3 4 5

``` r
# Call f() with the arguments x = x and y = 10
f(x=x, y=10)
```

    ## 0 10

    ## [1]  1  2 10  4  5

### Let's make it clear from its name

``` r
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
```

    ## 0 0

### Make the body more understandable

``` r
replace_missings <- function(x, replacement) {
  # Define is_miss
  is_miss <- is.na(x)
  # Rewrite rest of function to refer to is_miss
  x[is_miss] <- replacement
  cat(sum(is_miss), replacement, "\n")
  x
}

z <- replace_missings(z, 0)
```

    ## 0 0

### Much better! But a few more tweaks

``` r
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
```

    ## 2 missings replaced by the value 0

    ##  [1]  1.2242865  0.9648116  0.0000000  3.0548305  0.4427162 -0.1479685
    ##  [7]  0.6688705  0.4171186  0.5109801  0.0000000

------------------------------------------------------------------------

Session info
------------

``` r
sessionInfo()   
```

    ## R version 3.4.2 (2017-09-28)
    ## Platform: x86_64-w64-mingw32/x64 (64-bit)
    ## Running under: Windows 10 x64 (build 16299)
    ## 
    ## Matrix products: default
    ## 
    ## locale:
    ## [1] LC_COLLATE=English_United States.1252 
    ## [2] LC_CTYPE=English_United States.1252   
    ## [3] LC_MONETARY=English_United States.1252
    ## [4] LC_NUMERIC=C                          
    ## [5] LC_TIME=English_United States.1252    
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_3.4.2  backports_1.1.1 magrittr_1.5    rprojroot_1.2  
    ##  [5] tools_3.4.2     htmltools_0.3.6 yaml_2.1.14     Rcpp_0.12.13   
    ##  [9] stringi_1.1.5   rmarkdown_1.6   knitr_1.17      stringr_1.2.0  
    ## [13] digest_0.6.12   evaluate_0.10.1
