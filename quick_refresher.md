Quick refresher
================
Mark Blackmore
2018-01-15

-   [Writing a function](#writing-a-function)
-   [Testing your understanding of scoping (1)](#testing-your-understanding-of-scoping-1)
-   [Testing your understanding of scoping (2)](#testing-your-understanding-of-scoping-2)
-   [Testing your understanding of scoping (3)](#testing-your-understanding-of-scoping-3)
-   [Subsetting lists](#subsetting-lists)
-   [Exploring lists](#exploring-lists)
-   [A safr way to create the sequence](#a-safr-way-to-create-the-sequence)
-   [Keeping output](#keeping-output)
-   [Session info](#session-info)

### Writing a function

``` r
# Define ratio() function
ratio <- function(x, y) {
  x/y
}

# Call ratio() with arguments 3 and 4
ratio(3, 4)
```

    ## [1] 0.75

``` r
# Rewrite the call to follow best practices
mean(c(1:9, NA), trim = 0.1, na.rm = TRUE)
```

    ## [1] 5

``` r
# Function output
f <- function(x) {
  if (TRUE) {
    return(x + 1)
  }
  x
}

f(2)
```

    ## [1] 3

### Testing your understanding of scoping (1)

``` r
y <- 10
f <- function(x) {
  x + y
}

f(10)
```

    ## [1] 20

### Testing your understanding of scoping (2)

``` r
y <- 10
f <- function(x) {
  y <- 5
  x + y
}

f(10)
```

    ## [1] 15

### Testing your understanding of scoping (3)

``` r
rm(list = ls())
f <- function(x) {
  y <- 5
  x + y
}
f(5)
```

    ## [1] 10

``` r
# now, calling y returns an error
```

### Subsetting lists

``` r
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
```

    ## [1] "logical"

``` r
# Element called x in tricky_list
typeof(tricky_list[["x"]])
```

    ## [1] "list"

``` r
# 2nd element inside the element called x in tricky_list
typeof(tricky_list[["x"]][[2]])
```

    ## [1] "character"

### Exploring lists

``` r
# Guess where the regression model is stored
names(tricky_list)
```

    ## [1] "nums"  "y"     "x"     "model"

``` r
# Use names() and str() on the model element
names(tricky_list[["model"]])
```

    ##  [1] "coefficients"  "residuals"     "effects"       "rank"         
    ##  [5] "fitted.values" "assign"        "qr"            "df.residual"  
    ##  [9] "xlevels"       "call"          "terms"         "model"

``` r
str(tricky_list[["model"]])
```

    ## List of 12
    ##  $ coefficients : Named num [1:2] 37.29 -5.34
    ##   ..- attr(*, "names")= chr [1:2] "(Intercept)" "wt"
    ##  $ residuals    : Named num [1:32] -2.28 -0.92 -2.09 1.3 -0.2 ...
    ##   ..- attr(*, "names")= chr [1:32] "Mazda RX4" "Mazda RX4 Wag" "Datsun 710" "Hornet 4 Drive" ...
    ##  $ effects      : Named num [1:32] -113.65 -29.116 -1.661 1.631 0.111 ...
    ##   ..- attr(*, "names")= chr [1:32] "(Intercept)" "wt" "" "" ...
    ##  $ rank         : int 2
    ##  $ fitted.values: Named num [1:32] 23.3 21.9 24.9 20.1 18.9 ...
    ##   ..- attr(*, "names")= chr [1:32] "Mazda RX4" "Mazda RX4 Wag" "Datsun 710" "Hornet 4 Drive" ...
    ##  $ assign       : int [1:2] 0 1
    ##  $ qr           :List of 5
    ##   ..$ qr   : num [1:32, 1:2] -5.657 0.177 0.177 0.177 0.177 ...
    ##   .. ..- attr(*, "dimnames")=List of 2
    ##   .. .. ..$ : chr [1:32] "Mazda RX4" "Mazda RX4 Wag" "Datsun 710" "Hornet 4 Drive" ...
    ##   .. .. ..$ : chr [1:2] "(Intercept)" "wt"
    ##   .. ..- attr(*, "assign")= int [1:2] 0 1
    ##   ..$ qraux: num [1:2] 1.18 1.05
    ##   ..$ pivot: int [1:2] 1 2
    ##   ..$ tol  : num 1e-07
    ##   ..$ rank : int 2
    ##   ..- attr(*, "class")= chr "qr"
    ##  $ df.residual  : int 30
    ##  $ xlevels      : Named list()
    ##  $ call         : language lm(formula = mpg ~ wt, data = mtcars)
    ##  $ terms        :Classes 'terms', 'formula'  language mpg ~ wt
    ##   .. ..- attr(*, "variables")= language list(mpg, wt)
    ##   .. ..- attr(*, "factors")= int [1:2, 1] 0 1
    ##   .. .. ..- attr(*, "dimnames")=List of 2
    ##   .. .. .. ..$ : chr [1:2] "mpg" "wt"
    ##   .. .. .. ..$ : chr "wt"
    ##   .. ..- attr(*, "term.labels")= chr "wt"
    ##   .. ..- attr(*, "order")= int 1
    ##   .. ..- attr(*, "intercept")= int 1
    ##   .. ..- attr(*, "response")= int 1
    ##   .. ..- attr(*, ".Environment")=<environment: R_GlobalEnv> 
    ##   .. ..- attr(*, "predvars")= language list(mpg, wt)
    ##   .. ..- attr(*, "dataClasses")= Named chr [1:2] "numeric" "numeric"
    ##   .. .. ..- attr(*, "names")= chr [1:2] "mpg" "wt"
    ##  $ model        :'data.frame':   32 obs. of  2 variables:
    ##   ..$ mpg: num [1:32] 21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
    ##   ..$ wt : num [1:32] 2.62 2.88 2.32 3.21 3.44 ...
    ##   ..- attr(*, "terms")=Classes 'terms', 'formula'  language mpg ~ wt
    ##   .. .. ..- attr(*, "variables")= language list(mpg, wt)
    ##   .. .. ..- attr(*, "factors")= int [1:2, 1] 0 1
    ##   .. .. .. ..- attr(*, "dimnames")=List of 2
    ##   .. .. .. .. ..$ : chr [1:2] "mpg" "wt"
    ##   .. .. .. .. ..$ : chr "wt"
    ##   .. .. ..- attr(*, "term.labels")= chr "wt"
    ##   .. .. ..- attr(*, "order")= int 1
    ##   .. .. ..- attr(*, "intercept")= int 1
    ##   .. .. ..- attr(*, "response")= int 1
    ##   .. .. ..- attr(*, ".Environment")=<environment: R_GlobalEnv> 
    ##   .. .. ..- attr(*, "predvars")= language list(mpg, wt)
    ##   .. .. ..- attr(*, "dataClasses")= Named chr [1:2] "numeric" "numeric"
    ##   .. .. .. ..- attr(*, "names")= chr [1:2] "mpg" "wt"
    ##  - attr(*, "class")= chr "lm"

``` r
# Subset the coefficients element
tricky_list[["model"]][["coefficients"]]
```

    ## (Intercept)          wt 
    ##   37.285126   -5.344472

``` r
# Subset the wt element
tricky_list[["model"]][["coefficients"]][["wt"]]
```

    ## [1] -5.344472

### A safr way to create the sequence

``` r
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
```

    ## [1] 0.2112018
    ## [1] -0.2823895
    ## [1] -0.5321322
    ## [1] -0.1443082

``` r
# Change the value of df
df <- data.frame()

# Repeat for loop to verify there is no error
for (i in seq_along(df)) {
  print(median(df[[i]]))
}
```

### Keeping output

``` r
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
```

    ## [1]  0.1030177 -0.1280884 -0.6287061  0.1118977

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
