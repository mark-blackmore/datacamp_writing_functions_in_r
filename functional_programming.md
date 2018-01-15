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

    ## [1] 0.002316167 0.174966436 0.233346776 0.165688804

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

    ## [1] 0.002316167 0.174966436 0.233346776 0.165688804

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

    ## [1] -0.21749834  0.09633615  0.29368930  0.29535148

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

    ## [1] 0.8728061 1.3521124 1.0583077 0.8195153

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

    ## [1] 0.002316167 0.174966436 0.233346776 0.165688804

``` r
col_summary(df, fun = median)
```

    ## [1] 0.002316167 0.174966436 0.233346776 0.165688804

``` r
# Find the column means using col_mean() and col_summary()
col_mean(df)
```

    ## [1] -0.21749834  0.09633615  0.29368930  0.29535148

``` r
col_summary(df, fun = mean)
```

    ## [1] -0.21749834  0.09633615  0.29368930  0.29535148

``` r
# Find the column IQRs using col_summary()
col_summary(df, fun = IQR)
```

    ## [1] 0.6615423 2.3136151 1.4055018 0.6414719

### The map functions

``` r
# Load the purrr package
library(purrr)

# Use map_dbl() to find column means
map_dbl(df, mean)
```

    ##           a           b           c           d 
    ## -0.21749834  0.09633615  0.29368930  0.29535148

``` r
# Use map_dbl() to column medians
map_dbl(df, median)
```

    ##           a           b           c           d 
    ## 0.002316167 0.174966436 0.233346776 0.165688804

``` r
# Use map_dbl() to find column standard deviations
map_dbl(df, sd)
```

    ##         a         b         c         d 
    ## 0.8728061 1.3521124 1.0583077 0.8195153

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
