Functional programming
================
Mark Blackmore
2018-01-15

-   [Using a for loop to remove duplication](#using-a-for-loop-to-remove-duplication)
-   [Turning the for loop into a function](#turning-the-for-loop-into-a-function)
-   [What about column means?](#what-about-column-means)
-   [What about column standard deviations?](#what-about-column-standard-deviations)
-   [Uh oh...time to write a function again](#uh-oh...time-to-write-a-function-again)
-   [Using a function as an argument](#using-a-function-as-an-argument)
-   [The map functions](#the-map-functions)
-   [The ... argument to the map functions](#the-...-argument-to-the-map-functions)
-   [Picking the right map function](#picking-the-right-map-function)
-   [Solve a simple problem first](#solve-a-simple-problem-first)
-   [Using an anonymous function](#using-an-anonymous-function)
-   [Using a formula](#using-a-formula)
-   [Using a string](#using-a-string)
-   [Using a numeric vector](#using-a-numeric-vector)
-   [Putting it together with pipes](#putting-it-together-with-pipes)

### Using a for loop to remove duplication

``` r
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
```

    ## [1]  0.15816912 -0.03842034 -0.31411890 -0.52354702

### Turning the for loop into a function

``` r
# Turn this code into col_median()
col_median <- function(df){
  output <- vector("double", ncol(df))  
  for (i in seq_along(df)) {            
    output[[i]] <- median(df[[i]])      
  }
  output
}

col_median(df)
```

    ## [1]  0.15816912 -0.03842034 -0.31411890 -0.52354702

### What about column means?

``` r
# Create col_mean() function to find column means
col_mean <- function(df) {
  output <- numeric(length(df))
  for (i in seq_along(df)) {
    output[[i]] <- mean(df[[i]])
  }
  output
}

col_mean(df)
```

    ## [1]  0.31226912 -0.08289358 -0.20273164 -0.38814542

### What about column standard deviations?

``` r
# Define col_sd() function
col_sd <- function(df) {
  output <- numeric(length(df))
  for (i in seq_along(df)) {
    output[[i]] <- sd(df[[i]])
  }
  output
}

col_sd(df)
```

    ## [1] 1.0537019 0.7705826 0.8659556 1.0847900

### Uh oh...time to write a function again

``` r
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
```

### Using a function as an argument

``` r
col_summary <- function(df, fun) {
  output <- vector("numeric", length(df))
  for (i in seq_along(df)) {
    output[[i]] <- fun(df[[i]])
  }
  output
}

# Find the column medians using col_median() and col_summary()
col_median(df)
```

    ## [1]  0.15816912 -0.03842034 -0.31411890 -0.52354702

``` r
col_summary(df, fun = median)
```

    ## [1]  0.15816912 -0.03842034 -0.31411890 -0.52354702

``` r
# Find the column means using col_mean() and col_summary()
col_mean(df)
```

    ## [1]  0.31226912 -0.08289358 -0.20273164 -0.38814542

``` r
col_summary(df, fun = mean)
```

    ## [1]  0.31226912 -0.08289358 -0.20273164 -0.38814542

``` r
# Find the column IQRs using col_summary()
col_summary(df, fun = IQR)
```

    ## [1] 1.5121108 1.2750435 0.5443823 1.3445191

### The map functions

``` r
# Load the purrr package
library(purrr)

# Use map_dbl() to find column means
map_dbl(df, mean)
```

    ##           a           b           c           d 
    ##  0.31226912 -0.08289358 -0.20273164 -0.38814542

``` r
# Use map_dbl() to column medians
map_dbl(df, median)
```

    ##           a           b           c           d 
    ##  0.15816912 -0.03842034 -0.31411890 -0.52354702

``` r
# Use map_dbl() to find column standard deviations
map_dbl(df, sd)
```

    ##         a         b         c         d 
    ## 1.0537019 0.7705826 0.8659556 1.0847900

### The ... argument to the map functions

``` r
planes <- data.frame(year = c(1956, 1975, 1977, 1996, 2010, NA),
                     engines = c(4, 1, 2, 2, 2, 1),
                     seats = c(102, 4, 139, 142, 20, 2),
                     speed = c(232, 108, 432, NA, NA, NA)) 

# Find the mean of each column
map_dbl(planes, mean)
```

    ##     year  engines    seats    speed 
    ##       NA  2.00000 68.16667       NA

``` r
# Find the mean of each column, excluding missing values
map_dbl(planes, mean, na.rm = TRUE)
```

    ##       year    engines      seats      speed 
    ## 1982.80000    2.00000   68.16667  257.33333

``` r
# Find the 5th percentile of each column, excluding missing values
map_dbl(planes, quantile, 0.05, na.rm = TRUE)
```

    ##    year engines   seats   speed 
    ##  1959.8     1.0     2.5   120.4

### Picking the right map function

``` r
df3 <- data.frame(A = c(0.5123748, -0.5320614, -0.9896766,  0.1467971,  0.5180139,  
                        1.6141701, 1.1358714,  1.9706641, -0.8599646, -1.5132293 ),
                  B = c("A", "B", "A", "B", "A", "B", "A", "B", "A", "B"),
                  C = 1:10,
                  D = c(0.07360872, -0.10654830,  1.02213489, -0.08360299,  1.32206949,
                        1.13624467, 0.57766900,  0.61217352,  0.34261408,  0.37195776))

# Find the columns that are numeric
map_lgl(df3, is.numeric)
```

    ##     A     B     C     D 
    ##  TRUE FALSE  TRUE  TRUE

``` r
# Find the type of each column
map_chr(df3, typeof)
```

    ##         A         B         C         D 
    ##  "double" "integer" "integer"  "double"

``` r
# Find a summary of each column
map(df3, summary)
```

    ## $A
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ## -1.5132 -0.7780  0.3296  0.2003  0.9814  1.9707 
    ## 
    ## $B
    ## A B 
    ## 5 5 
    ## 
    ## $C
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.00    3.25    5.50    5.50    7.75   10.00 
    ## 
    ## $D
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ## -0.1065  0.1409  0.4748  0.5268  0.9196  1.3221

### Solve a simple problem first

``` r
cyl <- split(mtcars, mtcars$cyl)
# Examine the structure of cyl
str(cyl)
```

    ## List of 3
    ##  $ 4:'data.frame':   11 obs. of  11 variables:
    ##   ..$ mpg : num [1:11] 22.8 24.4 22.8 32.4 30.4 33.9 21.5 27.3 26 30.4 ...
    ##   ..$ cyl : num [1:11] 4 4 4 4 4 4 4 4 4 4 ...
    ##   ..$ disp: num [1:11] 108 146.7 140.8 78.7 75.7 ...
    ##   ..$ hp  : num [1:11] 93 62 95 66 52 65 97 66 91 113 ...
    ##   ..$ drat: num [1:11] 3.85 3.69 3.92 4.08 4.93 4.22 3.7 4.08 4.43 3.77 ...
    ##   ..$ wt  : num [1:11] 2.32 3.19 3.15 2.2 1.61 ...
    ##   ..$ qsec: num [1:11] 18.6 20 22.9 19.5 18.5 ...
    ##   ..$ vs  : num [1:11] 1 1 1 1 1 1 1 1 0 1 ...
    ##   ..$ am  : num [1:11] 1 0 0 1 1 1 0 1 1 1 ...
    ##   ..$ gear: num [1:11] 4 4 4 4 4 4 3 4 5 5 ...
    ##   ..$ carb: num [1:11] 1 2 2 1 2 1 1 1 2 2 ...
    ##  $ 6:'data.frame':   7 obs. of  11 variables:
    ##   ..$ mpg : num [1:7] 21 21 21.4 18.1 19.2 17.8 19.7
    ##   ..$ cyl : num [1:7] 6 6 6 6 6 6 6
    ##   ..$ disp: num [1:7] 160 160 258 225 168 ...
    ##   ..$ hp  : num [1:7] 110 110 110 105 123 123 175
    ##   ..$ drat: num [1:7] 3.9 3.9 3.08 2.76 3.92 3.92 3.62
    ##   ..$ wt  : num [1:7] 2.62 2.88 3.21 3.46 3.44 ...
    ##   ..$ qsec: num [1:7] 16.5 17 19.4 20.2 18.3 ...
    ##   ..$ vs  : num [1:7] 0 0 1 1 1 1 0
    ##   ..$ am  : num [1:7] 1 1 0 0 0 0 1
    ##   ..$ gear: num [1:7] 4 4 3 3 4 4 5
    ##   ..$ carb: num [1:7] 4 4 1 1 4 4 6
    ##  $ 8:'data.frame':   14 obs. of  11 variables:
    ##   ..$ mpg : num [1:14] 18.7 14.3 16.4 17.3 15.2 10.4 10.4 14.7 15.5 15.2 ...
    ##   ..$ cyl : num [1:14] 8 8 8 8 8 8 8 8 8 8 ...
    ##   ..$ disp: num [1:14] 360 360 276 276 276 ...
    ##   ..$ hp  : num [1:14] 175 245 180 180 180 205 215 230 150 150 ...
    ##   ..$ drat: num [1:14] 3.15 3.21 3.07 3.07 3.07 2.93 3 3.23 2.76 3.15 ...
    ##   ..$ wt  : num [1:14] 3.44 3.57 4.07 3.73 3.78 ...
    ##   ..$ qsec: num [1:14] 17 15.8 17.4 17.6 18 ...
    ##   ..$ vs  : num [1:14] 0 0 0 0 0 0 0 0 0 0 ...
    ##   ..$ am  : num [1:14] 0 0 0 0 0 0 0 0 0 0 ...
    ##   ..$ gear: num [1:14] 3 3 3 3 3 3 3 3 3 3 ...
    ##   ..$ carb: num [1:14] 2 4 3 3 3 4 4 4 2 2 ...

``` r
# Extract the first element into four_cyls
four_cyls <- cyl[[1]]

# Fit a linear regression of mpg on wt using four_cyls
lm(mpg ~ wt, four_cyls )
```

    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = four_cyls)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##      39.571       -5.647

### Using an anonymous function

``` r
fit_reg <- function(df) {
  lm(mpg ~ wt, data = df)
}

# Call user written function
map(cyl, fit_reg)
```

    ## $`4`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = df)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##      39.571       -5.647  
    ## 
    ## 
    ## $`6`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = df)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##       28.41        -2.78  
    ## 
    ## 
    ## $`8`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = df)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##      23.868       -2.192

``` r
# Rewrite to call an anonymous function
map(cyl, function(df) lm(mpg ~ wt, data = df))
```

    ## $`4`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = df)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##      39.571       -5.647  
    ## 
    ## 
    ## $`6`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = df)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##       28.41        -2.78  
    ## 
    ## 
    ## $`8`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = df)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##      23.868       -2.192

### Using a formula

``` r
# Rewrite to use the formula shortcut instead
map(cyl, ~ lm(mpg ~ wt, data = .))
```

    ## $`4`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = .)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##      39.571       -5.647  
    ## 
    ## 
    ## $`6`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = .)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##       28.41        -2.78  
    ## 
    ## 
    ## $`8`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = .)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##      23.868       -2.192

### Using a string

``` r
# Save the result from the previous exercise to the variable models
models <- map(cyl, ~ lm(mpg ~ wt, data = .))

# Use map and coef to get the coefficients for each model: coefs
coefs <- map(models, coef)

# Use string shortcut to extract the wt coefficient 
map(coefs, "wt")
```

    ## $`4`
    ## [1] -5.647025
    ## 
    ## $`6`
    ## [1] -2.780106
    ## 
    ## $`8`
    ## [1] -2.192438

### Using a numeric vector

``` r
coefs <- map(models, coef)

# use map_dbl with the numeric shortcut to pull out the second element
map_dbl(coefs, 2)
```

    ##         4         6         8 
    ## -5.647025 -2.780106 -2.192438

### Putting it together with pipes

``` r
# Define models (don't change)
models <- mtcars %>% 
  split(mtcars$cyl) %>%
  map(~ lm(mpg ~ wt, data = .))

# Rewrite to be a single command using pipes 
models %>% map(summary) %>% map_dbl("r.squared")
```

    ##         4         6         8 
    ## 0.5086326 0.4645102 0.4229655
