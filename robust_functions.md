Robust Functions
================
Mark Blackmore
2018-01-15

-   [An error is better than a surprise](#an-error-is-better-than-a-surprise)
-   [An informative error is even better](#an-informative-error-is-even-better)
-   [Using purrr solves the "type-consistent" problem](#using-purrr-solves-the-type-consistent-problem)
-   [A type consistent solution](#a-type-consistent-solution)
-   [Or fail early if something goes wrong](#or-fail-early-if-something-goes-wrong)
-   [Programming with Non Stanadard Evaluation functions](#programming-with-non-stanadard-evaluation-functions)
-   [When things go wrong](#when-things-go-wrong)
-   [What to do?](#what-to-do)
-   [A hidden dependence](#a-hidden-dependence)
-   [Legitimate use of options](#legitimate-use-of-options)
-   [Session info](#session-info)

``` r
suppressWarnings(
  suppressPackageStartupMessages(
    library(tidyverse)
  )
)
```

### An error is better than a surprise

``` r
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
```

### An informative error is even better

``` r
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
```

### Using purrr solves the "type-consistent" problem

``` r
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
```

    ## List of 4
    ##  $ a: chr "integer"
    ##  $ b: chr "numeric"
    ##  $ y: chr [1:2] "POSIXct" "POSIXt"
    ##  $ z: chr [1:2] "ordered" "factor"

``` r
str(B)
```

    ##  chr [1:2, 1:2] "POSIXct" "POSIXt" "ordered" "factor"
    ##  - attr(*, "dimnames")=List of 2
    ##   ..$ : NULL
    ##   ..$ : chr [1:2] "y" "z"

``` r
str(C)
```

    ##  Named chr [1:2] "integer" "numeric"
    ##  - attr(*, "names")= chr [1:2] "a" "b"

``` r
# Use map() to define X, Y and Z
X <- map(df[1:4], class)
Y <- map(df[3:4], class)
Z <- map(df[1:2], class)

# Use str() to check type consistency
str(X)
```

    ## List of 4
    ##  $ a: chr "integer"
    ##  $ b: chr "numeric"
    ##  $ y: chr [1:2] "POSIXct" "POSIXt"
    ##  $ z: chr [1:2] "ordered" "factor"

``` r
str(Y)
```

    ## List of 2
    ##  $ y: chr [1:2] "POSIXct" "POSIXt"
    ##  $ z: chr [1:2] "ordered" "factor"

``` r
str(Z)
```

    ## List of 2
    ##  $ a: chr "integer"
    ##  $ b: chr "numeric"

### A type consistent solution

``` r
col_classes <- function(df) {
  # Assign list output to class_list
  class_list <- map(df, class)
  
  # Use map_chr() to extract first element in class_list
  map_chr(class_list, 1)
}

# Check that our new function is type consistent
df %>% col_classes() %>% str()
```

    ##  Named chr [1:4] "integer" "numeric" "POSIXct" "ordered"
    ##  - attr(*, "names")= chr [1:4] "a" "b" "y" "z"

``` r
df[3:4] %>% col_classes() %>% str()
```

    ##  Named chr [1:2] "POSIXct" "ordered"
    ##  - attr(*, "names")= chr [1:2] "y" "z"

``` r
df[1:2] %>% col_classes() %>% str()
```

    ##  Named chr [1:2] "integer" "numeric"
    ##  - attr(*, "names")= chr [1:2] "a" "b"

### Or fail early if something goes wrong

``` r
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
```

### Programming with Non Stanadard Evaluation functions

``` r
big_x <- function(df, threshold) {
  dplyr::filter(df, x > threshold)
}

diamonds_sub <- diamonds[1:5000,]

# Use big_x() to find rows in diamonds_sub where x > 7
big_x(diamonds_sub, 7)
```

    ## # A tibble: 17 x 10
    ##    carat     cut color clarity depth table price     x     y     z
    ##    <dbl>   <ord> <ord>   <ord> <dbl> <dbl> <int> <dbl> <dbl> <dbl>
    ##  1  1.27 Premium     H     SI2  59.3    61  2845  7.12  7.05  4.20
    ##  2  1.50    Fair     H      I1  65.6    54  2964  7.26  7.09  4.70
    ##  3  1.52    Good     E      I1  57.3    58  3105  7.53  7.42  4.28
    ##  4  1.52    Good     E      I1  57.3    58  3105  7.53  7.42  4.28
    ##  5  1.21    Good     E      I1  57.2    62  3144  7.01  6.95  3.99
    ##  6  1.50    Good     G      I1  57.4    62  3179  7.56  7.39  4.29
    ##  7  1.50 Premium     H      I1  60.1    57  3457  7.40  7.28  4.42
    ##  8  1.51    Good     G      I1  64.0    59  3497  7.29  7.17  4.63
    ##  9  1.52    Fair     H      I1  64.9    58  3504  7.18  7.13  4.65
    ## 10  1.52 Premium     I      I1  61.2    58  3541  7.43  7.35  4.52
    ## 11  1.50 Premium     H      I1  61.1    59  3599  7.37  7.26  4.47
    ## 12  1.50    Good     I      I1  63.7    61  3696  7.22  7.10  4.57
    ## 13  1.31 Premium     J     SI2  59.7    59  3697  7.06  7.01  4.20
    ## 14  1.25 Premium     F      I1  58.0    59  3724  7.12  7.05  4.11
    ## 15  1.27 Premium     I      I1  60.2    62  3732  7.05  7.00  4.23
    ## 16  1.51    Fair     F      I1  67.8    59  3734  7.09  7.00  4.78
    ## 17  1.51    Fair     F      I1  67.5    56  3734  7.17  7.05  4.80

### When things go wrong

``` r
# Remove the x column from diamonds
diamonds_sub$x <- NULL

# Create variable x with value 1
x <- 1

# Use big_x() to find rows in diamonds_sub where x > 7
big_x(diamonds_sub, x > 7)
```

    ## # A tibble: 5,000 x 9
    ##    carat       cut color clarity depth table price     y     z
    ##    <dbl>     <ord> <ord>   <ord> <dbl> <dbl> <int> <dbl> <dbl>
    ##  1  0.23     Ideal     E     SI2  61.5    55   326  3.98  2.43
    ##  2  0.21   Premium     E     SI1  59.8    61   326  3.84  2.31
    ##  3  0.23      Good     E     VS1  56.9    65   327  4.07  2.31
    ##  4  0.29   Premium     I     VS2  62.4    58   334  4.23  2.63
    ##  5  0.31      Good     J     SI2  63.3    58   335  4.35  2.75
    ##  6  0.24 Very Good     J    VVS2  62.8    57   336  3.96  2.48
    ##  7  0.24 Very Good     I    VVS1  62.3    57   336  3.98  2.47
    ##  8  0.26 Very Good     H     SI1  61.9    55   337  4.11  2.53
    ##  9  0.22      Fair     E     VS2  65.1    61   337  3.78  2.49
    ## 10  0.23 Very Good     H     VS1  59.4    61   338  4.05  2.39
    ## # ... with 4,990 more rows

``` r
# Create a threshold column with value 100
diamonds_sub$threshold <- 100

# Use big_x() to find rows in diamonds_sub where x > 7
big_x(diamonds_sub, x > 7)
```

    ## # A tibble: 0 x 10
    ## # ... with 10 variables: carat <dbl>, cut <ord>, color <ord>,
    ## #   clarity <ord>, depth <dbl>, table <dbl>, price <int>, y <dbl>,
    ## #   z <dbl>, threshold <dbl>

### What to do?

``` r
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
```

### A hidden dependence

``` r
# Read in the swimming_pools.csv to pools
pools <- read.csv("pools.csv")

# Examine the structure of pools
str(pools)
```

    ## 'data.frame':    20 obs. of  4 variables:
    ##  $ Name     : Factor w/ 20 levels "Acacia Ridge Leisure Centre",..: 1 2 3 4 5 6 19 7 8 9 ...
    ##  $ Address  : Factor w/ 20 levels "1 Fairlead Crescent, Manly",..: 5 20 18 10 9 11 6 15 12 17 ...
    ##  $ Latitude : num  -27.6 -27.6 -27.6 -27.5 -27.4 ...
    ##  $ Longitude: num  153 153 153 153 153 ...

``` r
# Change the global stringsAsFactor option to FALSE
options(stringsAsFactors = FALSE)

# Read in the swimming_pools.csv to pools2
pools2 <- read.csv("pools.csv")

# Examine the structure of pools2
str(pools2) 
```

    ## 'data.frame':    20 obs. of  4 variables:
    ##  $ Name     : chr  "Acacia Ridge Leisure Centre" "Bellbowrie Pool" "Carole Park" "Centenary Pool (inner City)" ...
    ##  $ Address  : chr  "1391 Beaudesert Road, Acacia Ridge" "Sugarwood Street, Bellbowrie" "Cnr Boundary Road and Waterford Road Wacol" "400 Gregory Terrace, Spring Hill" ...
    ##  $ Latitude : num  -27.6 -27.6 -27.6 -27.5 -27.4 ...
    ##  $ Longitude: num  153 153 153 153 153 ...

### Legitimate use of options

``` r
# Fit a regression model
fit <- lm(mpg ~ wt, data = mtcars)

# Look at the summary of the model
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = mtcars)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -4.5432 -2.3647 -0.1252  1.4096  6.8727 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  37.2851     1.8776  19.858  < 2e-16 ***
    ## wt           -5.3445     0.5591  -9.559 1.29e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 3.046 on 30 degrees of freedom
    ## Multiple R-squared:  0.7528, Adjusted R-squared:  0.7446 
    ## F-statistic: 91.38 on 1 and 30 DF,  p-value: 1.294e-10

``` r
# Set the global digits option to 2
options(digits = 2)

# Take another look at the summary
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = mtcars)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -4.543 -2.365 -0.125  1.410  6.873 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)   37.285      1.878   19.86  < 2e-16 ***
    ## wt            -5.344      0.559   -9.56  1.3e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 3 on 30 degrees of freedom
    ## Multiple R-squared:  0.753,  Adjusted R-squared:  0.745 
    ## F-statistic: 91.4 on 1 and 30 DF,  p-value: 1.29e-10

``` r
# Restore defaults
options(stringsAsFactors = TRUE)
options(digits = 7)
```

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
    ## other attached packages:
    ## [1] bindrcpp_0.2    dplyr_0.7.4     purrr_0.2.3     readr_1.1.1    
    ## [5] tidyr_0.7.1     tibble_1.3.4    ggplot2_2.2.1   tidyverse_1.1.1
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.13     cellranger_1.1.0 compiler_3.4.2   plyr_1.8.4      
    ##  [5] bindr_0.1        forcats_0.2.0    tools_3.4.2      digest_0.6.12   
    ##  [9] lubridate_1.6.0  jsonlite_1.5     evaluate_0.10.1  nlme_3.1-131    
    ## [13] gtable_0.2.0     lattice_0.20-35  pkgconfig_2.0.1  rlang_0.1.2     
    ## [17] psych_1.7.8      yaml_2.1.14      parallel_3.4.2   haven_1.1.0     
    ## [21] xml2_1.1.1       httr_1.3.1       stringr_1.2.0    knitr_1.17      
    ## [25] hms_0.3          rprojroot_1.2    grid_3.4.2       glue_1.1.1      
    ## [29] R6_2.2.2         readxl_1.0.0     foreign_0.8-69   rmarkdown_1.6   
    ## [33] modelr_0.1.1     reshape2_1.4.2   magrittr_1.5     backports_1.1.1 
    ## [37] scales_0.5.0     htmltools_0.3.6  rvest_0.3.2      assertthat_0.2.0
    ## [41] mnormt_1.5-5     colorspace_1.3-2 stringi_1.1.5    lazyeval_0.2.0  
    ## [45] munsell_0.4.3    broom_0.4.2
