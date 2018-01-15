Functional programming
================
Mark Blackmore
2018-01-15

-   [Using a for loop to remove duplication](#using-a-for-loop-to-remove-duplication)
-   [Turning the for loop into a function](#turning-the-for-loop-into-a-function)

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

    ## [1] -0.2027553  0.1097720  0.1785253 -0.1296783

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

    ## [1] -0.2027553  0.1097720  0.1785253 -0.1296783
