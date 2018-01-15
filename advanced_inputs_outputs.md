Advanced Inputs and Outputs
================
Mark Blackmore
2018-01-15

-   [Creating a safe function](#creating-a-safe-function)
-   [Using map safely](#using-map-safely)
-   [Working with safe output](#working-with-safe-output)
-   [Working with errors and results](#working-with-errors-and-results)
-   [Getting started](#getting-started)
-   [Mapping over two arguments](#mapping-over-two-arguments)
-   [Mapping over more than two arguments](#mapping-over-more-than-two-arguments)
-   [Argument matching](#argument-matching)
-   [Mapping over functions and their arguments](#mapping-over-functions-and-their-arguments)
-   [Walk](#walk)
-   [Walking over two or more arguments](#walking-over-two-or-more-arguments)
-   [Putting together writing functions and walk](#putting-together-writing-functions-and-walk)
-   [Nice breaks for all](#nice-breaks-for-all)
-   [Walking with many arguments: pwalk](#walking-with-many-arguments-pwalk)
-   [Walking with pipes](#walking-with-pipes)
-   [Session info](#session-info)

``` r
suppressWarnings(
  suppressPackageStartupMessages(
    library(tidyverse)
  )
)
```

### Creating a safe function

``` r
# Create safe_readLines() by passing readLines() to safely()
safe_readLines <- safely(readLines)

# Call safe_readLines() on "http://example.org"
safe_readLines("http://example.org")
```

    ## $result
    ##  [1] "<!doctype html>"                                                                                      
    ##  [2] "<html>"                                                                                               
    ##  [3] "<head>"                                                                                               
    ##  [4] "    <title>Example Domain</title>"                                                                    
    ##  [5] ""                                                                                                     
    ##  [6] "    <meta charset=\"utf-8\" />"                                                                       
    ##  [7] "    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\" />"                        
    ##  [8] "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />"                       
    ##  [9] "    <style type=\"text/css\">"                                                                        
    ## [10] "    body {"                                                                                           
    ## [11] "        background-color: #f0f0f2;"                                                                   
    ## [12] "        margin: 0;"                                                                                   
    ## [13] "        padding: 0;"                                                                                  
    ## [14] "        font-family: \"Open Sans\", \"Helvetica Neue\", Helvetica, Arial, sans-serif;"                
    ## [15] "        "                                                                                             
    ## [16] "    }"                                                                                                
    ## [17] "    div {"                                                                                            
    ## [18] "        width: 600px;"                                                                                
    ## [19] "        margin: 5em auto;"                                                                            
    ## [20] "        padding: 50px;"                                                                               
    ## [21] "        background-color: #fff;"                                                                      
    ## [22] "        border-radius: 1em;"                                                                          
    ## [23] "    }"                                                                                                
    ## [24] "    a:link, a:visited {"                                                                              
    ## [25] "        color: #38488f;"                                                                              
    ## [26] "        text-decoration: none;"                                                                       
    ## [27] "    }"                                                                                                
    ## [28] "    @media (max-width: 700px) {"                                                                      
    ## [29] "        body {"                                                                                       
    ## [30] "            background-color: #fff;"                                                                  
    ## [31] "        }"                                                                                            
    ## [32] "        div {"                                                                                        
    ## [33] "            width: auto;"                                                                             
    ## [34] "            margin: 0 auto;"                                                                          
    ## [35] "            border-radius: 0;"                                                                        
    ## [36] "            padding: 1em;"                                                                            
    ## [37] "        }"                                                                                            
    ## [38] "    }"                                                                                                
    ## [39] "    </style>    "                                                                                     
    ## [40] "</head>"                                                                                              
    ## [41] ""                                                                                                     
    ## [42] "<body>"                                                                                               
    ## [43] "<div>"                                                                                                
    ## [44] "    <h1>Example Domain</h1>"                                                                          
    ## [45] "    <p>This domain is established to be used for illustrative examples in documents. You may use this"
    ## [46] "    domain in examples without prior coordination or asking for permission.</p>"                      
    ## [47] "    <p><a href=\"http://www.iana.org/domains/example\">More information...</a></p>"                   
    ## [48] "</div>"                                                                                               
    ## [49] "</body>"                                                                                              
    ## [50] "</html>"                                                                                              
    ## 
    ## $error
    ## NULL

``` r
# Call safe_readLines() on "http://asdfasdasdkfjlda"
safe_readLines("http://asdfasdasdkfjlda")
```

    ## Warning in file(con, "r"): InternetOpenUrl failed: 'The server name or
    ## address could not be resolved'

    ## $result
    ## NULL
    ## 
    ## $error
    ## <simpleError in file(con, "r"): cannot open the connection>

### Using map safely

``` r
urls <- list(
  example = "http://example.org",
  rproj = "http://www.r-project.org",
  asdf = "http://asdfasdasdkfjlda"
)

# Define safe_readLines()
safe_readLines <- safely(readLines)

# Use the safe_readLines() function with map(): html
html <- map(urls, safe_readLines)
```

    ## Warning in file(con, "r"): InternetOpenUrl failed: 'The server name or
    ## address could not be resolved'

``` r
# Call str() on html
str(html)
```

    ## List of 3
    ##  $ example:List of 2
    ##   ..$ result: chr [1:50] "<!doctype html>" "<html>" "<head>" "    <title>Example Domain</title>" ...
    ##   ..$ error : NULL
    ##  $ rproj  :List of 2
    ##   ..$ result: chr [1:121] "<!DOCTYPE html>" "<html lang=\"en\">" "  <head>" "    <meta charset=\"utf-8\">" ...
    ##   ..$ error : NULL
    ##  $ asdf   :List of 2
    ##   ..$ result: NULL
    ##   ..$ error :List of 2
    ##   .. ..$ message: chr "cannot open the connection"
    ##   .. ..$ call   : language file(con, "r")
    ##   .. ..- attr(*, "class")= chr [1:3] "simpleError" "error" "condition"

``` r
# Extract the result from one of the successful elements
map(html, "result")
```

    ## $example
    ##  [1] "<!doctype html>"                                                                                      
    ##  [2] "<html>"                                                                                               
    ##  [3] "<head>"                                                                                               
    ##  [4] "    <title>Example Domain</title>"                                                                    
    ##  [5] ""                                                                                                     
    ##  [6] "    <meta charset=\"utf-8\" />"                                                                       
    ##  [7] "    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\" />"                        
    ##  [8] "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />"                       
    ##  [9] "    <style type=\"text/css\">"                                                                        
    ## [10] "    body {"                                                                                           
    ## [11] "        background-color: #f0f0f2;"                                                                   
    ## [12] "        margin: 0;"                                                                                   
    ## [13] "        padding: 0;"                                                                                  
    ## [14] "        font-family: \"Open Sans\", \"Helvetica Neue\", Helvetica, Arial, sans-serif;"                
    ## [15] "        "                                                                                             
    ## [16] "    }"                                                                                                
    ## [17] "    div {"                                                                                            
    ## [18] "        width: 600px;"                                                                                
    ## [19] "        margin: 5em auto;"                                                                            
    ## [20] "        padding: 50px;"                                                                               
    ## [21] "        background-color: #fff;"                                                                      
    ## [22] "        border-radius: 1em;"                                                                          
    ## [23] "    }"                                                                                                
    ## [24] "    a:link, a:visited {"                                                                              
    ## [25] "        color: #38488f;"                                                                              
    ## [26] "        text-decoration: none;"                                                                       
    ## [27] "    }"                                                                                                
    ## [28] "    @media (max-width: 700px) {"                                                                      
    ## [29] "        body {"                                                                                       
    ## [30] "            background-color: #fff;"                                                                  
    ## [31] "        }"                                                                                            
    ## [32] "        div {"                                                                                        
    ## [33] "            width: auto;"                                                                             
    ## [34] "            margin: 0 auto;"                                                                          
    ## [35] "            border-radius: 0;"                                                                        
    ## [36] "            padding: 1em;"                                                                            
    ## [37] "        }"                                                                                            
    ## [38] "    }"                                                                                                
    ## [39] "    </style>    "                                                                                     
    ## [40] "</head>"                                                                                              
    ## [41] ""                                                                                                     
    ## [42] "<body>"                                                                                               
    ## [43] "<div>"                                                                                                
    ## [44] "    <h1>Example Domain</h1>"                                                                          
    ## [45] "    <p>This domain is established to be used for illustrative examples in documents. You may use this"
    ## [46] "    domain in examples without prior coordination or asking for permission.</p>"                      
    ## [47] "    <p><a href=\"http://www.iana.org/domains/example\">More information...</a></p>"                   
    ## [48] "</div>"                                                                                               
    ## [49] "</body>"                                                                                              
    ## [50] "</html>"                                                                                              
    ## 
    ## $rproj
    ##   [1] "<!DOCTYPE html>"                                                                                                                                                                                                                                                                                                                                     
    ##   [2] "<html lang=\"en\">"                                                                                                                                                                                                                                                                                                                                  
    ##   [3] "  <head>"                                                                                                                                                                                                                                                                                                                                            
    ##   [4] "    <meta charset=\"utf-8\">"                                                                                                                                                                                                                                                                                                                        
    ##   [5] "    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">"                                                                                                                                                                                                                                                                                       
    ##   [6] "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"                                                                                                                                                                                                                                                                        
    ##   [7] "    <title>R: The R Project for Statistical Computing</title>"                                                                                                                                                                                                                                                                                       
    ##   [8] ""                                                                                                                                                                                                                                                                                                                                                    
    ##   [9] "    <link rel=\"icon\" type=\"image/png\" href=\"/favicon-32x32.png\" sizes=\"32x32\" />"                                                                                                                                                                                                                                                            
    ##  [10] "    <link rel=\"icon\" type=\"image/png\" href=\"/favicon-16x16.png\" sizes=\"16x16\" />"                                                                                                                                                                                                                                                            
    ##  [11] ""                                                                                                                                                                                                                                                                                                                                                    
    ##  [12] "    <!-- Bootstrap -->"                                                                                                                                                                                                                                                                                                                              
    ##  [13] "    <link href=\"/css/bootstrap.min.css\" rel=\"stylesheet\">"                                                                                                                                                                                                                                                                                       
    ##  [14] "    <link href=\"/css/R.css\" rel=\"stylesheet\">"                                                                                                                                                                                                                                                                                                   
    ##  [15] ""                                                                                                                                                                                                                                                                                                                                                    
    ##  [16] "    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->"                                                                                                                                                                                                                                                          
    ##  [17] "    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->"                                                                                                                                                                                                                                                                      
    ##  [18] "    <!--[if lt IE 9]>"                                                                                                                                                                                                                                                                                                                               
    ##  [19] "      <script src=\"https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js\"></script>"                                                                                                                                                                                                                                                             
    ##  [20] "      <script src=\"https://oss.maxcdn.com/respond/1.4.2/respond.min.js\"></script>"                                                                                                                                                                                                                                                                 
    ##  [21] "    <![endif]-->"                                                                                                                                                                                                                                                                                                                                    
    ##  [22] "  </head>"                                                                                                                                                                                                                                                                                                                                           
    ##  [23] "  <body>"                                                                                                                                                                                                                                                                                                                                            
    ##  [24] "    <div class=\"container page\">"                                                                                                                                                                                                                                                                                                                  
    ##  [25] "      <div class=\"row\">"                                                                                                                                                                                                                                                                                                                           
    ##  [26] "        <div class=\"col-xs-12 col-sm-offset-1 col-sm-2 sidebar\" role=\"navigation\">"                                                                                                                                                                                                                                                              
    ##  [27] "<div class=\"row\">"                                                                                                                                                                                                                                                                                                                                 
    ##  [28] "<div class=\"col-xs-6 col-sm-12\">"                                                                                                                                                                                                                                                                                                                  
    ##  [29] "<p><a href=\"/\"><img src=\"/Rlogo.png\" width=\"100\" height=\"78\" alt = \"R\" /></a></p>"                                                                                                                                                                                                                                                         
    ##  [30] "<p><small><a href=\"/\">[Home]</a></small></p>"                                                                                                                                                                                                                                                                                                      
    ##  [31] "<h2 id=\"download\">Download</h2>"                                                                                                                                                                                                                                                                                                                   
    ##  [32] "<p><a href=\"http://cran.r-project.org/mirrors.html\">CRAN</a></p>"                                                                                                                                                                                                                                                                                  
    ##  [33] "<h2 id=\"r-project\">R Project</h2>"                                                                                                                                                                                                                                                                                                                 
    ##  [34] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [35] "<li><a href=\"/about.html\">About R</a></li>"                                                                                                                                                                                                                                                                                                        
    ##  [36] "<li><a href=\"/logo/\">Logo</a></li>"                                                                                                                                                                                                                                                                                                                
    ##  [37] "<li><a href=\"/contributors.html\">Contributors</a></li>"                                                                                                                                                                                                                                                                                            
    ##  [38] "<li><a href=\"/news.html\">Whatâ<U+0080><U+0099>s New?</a></li>"                                                                                                                                                                                                                                                                                                   
    ##  [39] "<li><a href=\"/bugs.html\">Reporting Bugs</a></li>"                                                                                                                                                                                                                                                                                                  
    ##  [40] "<li><a href=\"http://developer.R-project.org\">Development Site</a></li>"                                                                                                                                                                                                                                                                            
    ##  [41] "<li><a href=\"/conferences.html\">Conferences</a></li>"                                                                                                                                                                                                                                                                                              
    ##  [42] "<li><a href=\"/search.html\">Search</a></li>"                                                                                                                                                                                                                                                                                                        
    ##  [43] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ##  [44] "</div>"                                                                                                                                                                                                                                                                                                                                              
    ##  [45] "<div class=\"col-xs-6 col-sm-12\">"                                                                                                                                                                                                                                                                                                                  
    ##  [46] "<h2 id=\"r-foundation\">R Foundation</h2>"                                                                                                                                                                                                                                                                                                           
    ##  [47] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [48] "<li><a href=\"/foundation/\">Foundation</a></li>"                                                                                                                                                                                                                                                                                                    
    ##  [49] "<li><a href=\"/foundation/board.html\">Board</a></li>"                                                                                                                                                                                                                                                                                               
    ##  [50] "<li><a href=\"/foundation/members.html\">Members</a></li>"                                                                                                                                                                                                                                                                                           
    ##  [51] "<li><a href=\"/foundation/donors.html\">Donors</a></li>"                                                                                                                                                                                                                                                                                             
    ##  [52] "<li><a href=\"/foundation/donations.html\">Donate</a></li>"                                                                                                                                                                                                                                                                                          
    ##  [53] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ##  [54] "<h2 id=\"help-with-r\">Help With R</h2>"                                                                                                                                                                                                                                                                                                             
    ##  [55] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [56] "<li><a href=\"/help.html\">Getting Help</a></li>"                                                                                                                                                                                                                                                                                                    
    ##  [57] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ##  [58] "<h2 id=\"documentation\">Documentation</h2>"                                                                                                                                                                                                                                                                                                         
    ##  [59] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [60] "<li><a href=\"http://cran.r-project.org/manuals.html\">Manuals</a></li>"                                                                                                                                                                                                                                                                             
    ##  [61] "<li><a href=\"http://cran.r-project.org/faqs.html\">FAQs</a></li>"                                                                                                                                                                                                                                                                                   
    ##  [62] "<li><a href=\"http://journal.r-project.org\">The R Journal</a></li>"                                                                                                                                                                                                                                                                                 
    ##  [63] "<li><a href=\"/doc/bib/R-books.html\">Books</a></li>"                                                                                                                                                                                                                                                                                                
    ##  [64] "<li><a href=\"/certification.html\">Certification</a></li>"                                                                                                                                                                                                                                                                                          
    ##  [65] "<li><a href=\"/other-docs.html\">Other</a></li>"                                                                                                                                                                                                                                                                                                     
    ##  [66] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ##  [67] "<h2 id=\"links\">Links</h2>"                                                                                                                                                                                                                                                                                                                         
    ##  [68] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [69] "<li><a href=\"http://www.bioconductor.org\">Bioconductor</a></li>"                                                                                                                                                                                                                                                                                   
    ##  [70] "<li><a href=\"/other-projects.html\">Related Projects</a></li>"                                                                                                                                                                                                                                                                                      
    ##  [71] "<li><a href=\"/gsoc.html\">GSoC</a></li>"                                                                                                                                                                                                                                                                                                            
    ##  [72] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ##  [73] "</div>"                                                                                                                                                                                                                                                                                                                                              
    ##  [74] "</div>"                                                                                                                                                                                                                                                                                                                                              
    ##  [75] "        </div>"                                                                                                                                                                                                                                                                                                                                      
    ##  [76] "        <div class=\"col-xs-12 col-sm-7\">"                                                                                                                                                                                                                                                                                                          
    ##  [77] "        <h1>The R Project for Statistical Computing</h1>"                                                                                                                                                                                                                                                                                            
    ##  [78] "<h2 id=\"getting-started\">Getting Started</h2>"                                                                                                                                                                                                                                                                                                     
    ##  [79] "<p>R is a free software environment for statistical computing and graphics. It compiles and runs on a wide variety of UNIX platforms, Windows and MacOS. To <strong><a href=\"http://cran.r-project.org/mirrors.html\">download R</a></strong>, please choose your preferred <a href=\"http://cran.r-project.org/mirrors.html\">CRAN mirror</a>.</p>"
    ##  [80] "<p>If you have questions about R like how to download and install the software, or what the license terms are, please read our <a href=\"http://cran.R-project.org/faqs.html\">answers to frequently asked questions</a> before you send an email.</p>"                                                                                              
    ##  [81] "<h2 id=\"news\">News</h2>"                                                                                                                                                                                                                                                                                                                           
    ##  [82] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [83] "<li><p><a href=\"http://cran.r-project.org/src/base/R-3\"><strong>R version 3.4.3 (Kite-Eating Tree)</strong></a> has been released on 2017-11-30.</p></li>"                                                                                                                                                                                         
    ##  [84] "<li><p><a href=\"https://journal.r-project.org/archive/2017-1\"><strong>The R Journal Volume 9/1</strong></a> is available.</p></li>"                                                                                                                                                                                                                
    ##  [85] "<li><p><a href=\"http://cran.r-project.org/src/base/R-3\"><strong>R version 3.3.3 (Another Canoe)</strong></a> has been released on Monday 2017-03-06.</p></li>"                                                                                                                                                                                     
    ##  [86] "<li><p><a href=\"https://journal.r-project.org/archive/2016-2\"><strong>The R Journal Volume 8/2</strong></a> is available.</p></li>"                                                                                                                                                                                                                
    ##  [87] "<li><p><strong>useR! 2017</strong> (July 4 - 7 in Brussels) has opened registration and more at http://user2017.brussels/</p></li>"                                                                                                                                                                                                                  
    ##  [88] "<li><p>Tomas Kalibera has joined the R core team.</p></li>"                                                                                                                                                                                                                                                                                          
    ##  [89] "<li><p>The R Foundation welcomes five new ordinary members: Jennifer Bryan, Dianne Cook, Julie Josse, Tomas Kalibera, and Balasubramanian Narasimhan.</p></li>"                                                                                                                                                                                      
    ##  [90] "<li><p><a href=\"http://journal.r-project.org\"><strong>The R Journal Volume 8/1</strong></a> is available.</p></li>"                                                                                                                                                                                                                                
    ##  [91] "<li><p>The <strong>useR! 2017</strong> conference will take place in Brussels, July 4 - 7, 2017.</p></li>"                                                                                                                                                                                                                                           
    ##  [92] "<li><p><a href=\"http://cran.r-project.org/src/base/R-3\"><strong>R version 3.2.5 (Very, Very Secure Dishes)</strong></a> has been released on 2016-04-14. This is a rebadging of the quick-fix release 3.2.4-revised.</p></li>"                                                                                                                     
    ##  [93] "<li><p><strong>Notice XQuartz users (Mac OS X)</strong> A security issue has been detected with the Sparkle update mechanism used by XQuartz. Avoid updating over insecure channels.</p></li>"                                                                                                                                                       
    ##  [94] "<li><p>The <a href=\"http://www.r-project.org/logo\"><strong>R Logo</strong></a> is available for download in high-resolution PNG or SVG formats.</p></li>"                                                                                                                                                                                          
    ##  [95] "<li><p><strong><a href=\"http://www.r-project.org/useR-2016\">useR! 2016</a></strong>, has taken place at Stanford University, CA, USA, June 27 - June 30, 2016.</p></li>"                                                                                                                                                                           
    ##  [96] "<li><p><a href=\"http://journal.r-project.org\"><strong>The R Journal Volume 7/2</strong></a> is available.</p></li>"                                                                                                                                                                                                                                
    ##  [97] "<li><p><a href=\"http://cran.r-project.org/src/base/R-3\"><strong>R version 3.2.3 (Wooden Christmas-Tree)</strong></a> has been released on 2015-12-10.</p></li>"                                                                                                                                                                                    
    ##  [98] "<li><p><a href=\"http://cran.r-project.org/src/base/R-3\"><strong>R version 3.1.3 (Smooth Sidewalk)</strong></a> has been released on 2015-03-09.</p></li>"                                                                                                                                                                                          
    ##  [99] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ## [100] "<!--- (Boilerplate for release run-in)"                                                                                                                                                                                                                                                                                                              
    ## [101] "-   [**R version 3.1.3 (Smooth Sidewalk) prerelease versions**](http://cran.r-project.org/src/base-prerelease) will appear starting February 28. Final release is scheduled for 2015-03-09."                                                                                                                                                         
    ## [102] "-->"                                                                                                                                                                                                                                                                                                                                                 
    ## [103] "        </div>"                                                                                                                                                                                                                                                                                                                                      
    ## [104] "      </div>"                                                                                                                                                                                                                                                                                                                                        
    ## [105] "      <div class=\"raw footer\">"                                                                                                                                                                                                                                                                                                                    
    ## [106] "        &copy; The R Foundation. For queries about this web site, please contact"                                                                                                                                                                                                                                                                    
    ## [107] "\t<script type='text/javascript'>"                                                                                                                                                                                                                                                                                                                    
    ## [108] "<!--"                                                                                                                                                                                                                                                                                                                                                
    ## [109] "var s=\"=b!isfg>#nbjmup;xfcnbtufsAs.qspkfdu/psh#?uif!xfcnbtufs=0b?\";"                                                                                                                                                                                                                                                                               
    ## [110] "m=\"\"; for (i=0; i<s.length; i++) {if(s.charCodeAt(i) == 28){m+= '&';} else if (s.charCodeAt(i) == 23) {m+= '!';} else {m+=String.fromCharCode(s.charCodeAt(i)-1);}}document.write(m);//-->"                                                                                                                                                        
    ## [111] "\t</script>;"                                                                                                                                                                                                                                                                                                                                         
    ## [112] "        for queries about R itself, please consult the "                                                                                                                                                                                                                                                                                             
    ## [113] "        <a href=\"help.html\">Getting Help</a> section."                                                                                                                                                                                                                                                                                             
    ## [114] "      </div>"                                                                                                                                                                                                                                                                                                                                        
    ## [115] "    </div>"                                                                                                                                                                                                                                                                                                                                          
    ## [116] "    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->"                                                                                                                                                                                                                                                                                  
    ## [117] "    <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js\"></script>"                                                                                                                                                                                                                                                     
    ## [118] "    <!-- Include all compiled plugins (below), or include individual files as needed -->"                                                                                                                                                                                                                                                            
    ## [119] "    <script src=\"/js/bootstrap.min.js\"></script>"                                                                                                                                                                                                                                                                                                  
    ## [120] "  </body>"                                                                                                                                                                                                                                                                                                                                           
    ## [121] "</html>"                                                                                                                                                                                                                                                                                                                                             
    ## 
    ## $asdf
    ## NULL

``` r
# Extract the error from the element that was unsuccessful
map(html, "error")
```

    ## $example
    ## NULL
    ## 
    ## $rproj
    ## NULL
    ## 
    ## $asdf
    ## <simpleError in file(con, "r"): cannot open the connection>

### Working with safe output

``` r
# Define save_readLines() and html
safe_readLines <- safely(readLines)
html <- map(urls, safe_readLines)
```

    ## Warning in file(con, "r"): InternetOpenUrl failed: 'The server name or
    ## address could not be resolved'

``` r
# Examine the structure of transpose(html)
str(transpose(html))
```

    ## List of 2
    ##  $ result:List of 3
    ##   ..$ example: chr [1:50] "<!doctype html>" "<html>" "<head>" "    <title>Example Domain</title>" ...
    ##   ..$ rproj  : chr [1:121] "<!DOCTYPE html>" "<html lang=\"en\">" "  <head>" "    <meta charset=\"utf-8\">" ...
    ##   ..$ asdf   : NULL
    ##  $ error :List of 3
    ##   ..$ example: NULL
    ##   ..$ rproj  : NULL
    ##   ..$ asdf   :List of 2
    ##   .. ..$ message: chr "cannot open the connection"
    ##   .. ..$ call   : language file(con, "r")
    ##   .. ..- attr(*, "class")= chr [1:3] "simpleError" "error" "condition"

``` r
# Extract the results: res
res <- transpose(html)[["result"]]

# Extract the errors: errs
errs <- transpose(html)[["error"]]
```

### Working with errors and results

``` r
# Initialize some objects
safe_readLines <- safely(readLines)
html <- map(urls, safe_readLines)
```

    ## Warning in file(con, "r"): InternetOpenUrl failed: 'The server name or
    ## address could not be resolved'

``` r
res <- transpose(html)[["result"]]
errs <- transpose(html)[["error"]]

# Create a logical vector is_ok
is_ok <- map_lgl(errs, is.null)

# Extract the successful results
res[is_ok]
```

    ## $example
    ##  [1] "<!doctype html>"                                                                                      
    ##  [2] "<html>"                                                                                               
    ##  [3] "<head>"                                                                                               
    ##  [4] "    <title>Example Domain</title>"                                                                    
    ##  [5] ""                                                                                                     
    ##  [6] "    <meta charset=\"utf-8\" />"                                                                       
    ##  [7] "    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\" />"                        
    ##  [8] "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />"                       
    ##  [9] "    <style type=\"text/css\">"                                                                        
    ## [10] "    body {"                                                                                           
    ## [11] "        background-color: #f0f0f2;"                                                                   
    ## [12] "        margin: 0;"                                                                                   
    ## [13] "        padding: 0;"                                                                                  
    ## [14] "        font-family: \"Open Sans\", \"Helvetica Neue\", Helvetica, Arial, sans-serif;"                
    ## [15] "        "                                                                                             
    ## [16] "    }"                                                                                                
    ## [17] "    div {"                                                                                            
    ## [18] "        width: 600px;"                                                                                
    ## [19] "        margin: 5em auto;"                                                                            
    ## [20] "        padding: 50px;"                                                                               
    ## [21] "        background-color: #fff;"                                                                      
    ## [22] "        border-radius: 1em;"                                                                          
    ## [23] "    }"                                                                                                
    ## [24] "    a:link, a:visited {"                                                                              
    ## [25] "        color: #38488f;"                                                                              
    ## [26] "        text-decoration: none;"                                                                       
    ## [27] "    }"                                                                                                
    ## [28] "    @media (max-width: 700px) {"                                                                      
    ## [29] "        body {"                                                                                       
    ## [30] "            background-color: #fff;"                                                                  
    ## [31] "        }"                                                                                            
    ## [32] "        div {"                                                                                        
    ## [33] "            width: auto;"                                                                             
    ## [34] "            margin: 0 auto;"                                                                          
    ## [35] "            border-radius: 0;"                                                                        
    ## [36] "            padding: 1em;"                                                                            
    ## [37] "        }"                                                                                            
    ## [38] "    }"                                                                                                
    ## [39] "    </style>    "                                                                                     
    ## [40] "</head>"                                                                                              
    ## [41] ""                                                                                                     
    ## [42] "<body>"                                                                                               
    ## [43] "<div>"                                                                                                
    ## [44] "    <h1>Example Domain</h1>"                                                                          
    ## [45] "    <p>This domain is established to be used for illustrative examples in documents. You may use this"
    ## [46] "    domain in examples without prior coordination or asking for permission.</p>"                      
    ## [47] "    <p><a href=\"http://www.iana.org/domains/example\">More information...</a></p>"                   
    ## [48] "</div>"                                                                                               
    ## [49] "</body>"                                                                                              
    ## [50] "</html>"                                                                                              
    ## 
    ## $rproj
    ##   [1] "<!DOCTYPE html>"                                                                                                                                                                                                                                                                                                                                     
    ##   [2] "<html lang=\"en\">"                                                                                                                                                                                                                                                                                                                                  
    ##   [3] "  <head>"                                                                                                                                                                                                                                                                                                                                            
    ##   [4] "    <meta charset=\"utf-8\">"                                                                                                                                                                                                                                                                                                                        
    ##   [5] "    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">"                                                                                                                                                                                                                                                                                       
    ##   [6] "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"                                                                                                                                                                                                                                                                        
    ##   [7] "    <title>R: The R Project for Statistical Computing</title>"                                                                                                                                                                                                                                                                                       
    ##   [8] ""                                                                                                                                                                                                                                                                                                                                                    
    ##   [9] "    <link rel=\"icon\" type=\"image/png\" href=\"/favicon-32x32.png\" sizes=\"32x32\" />"                                                                                                                                                                                                                                                            
    ##  [10] "    <link rel=\"icon\" type=\"image/png\" href=\"/favicon-16x16.png\" sizes=\"16x16\" />"                                                                                                                                                                                                                                                            
    ##  [11] ""                                                                                                                                                                                                                                                                                                                                                    
    ##  [12] "    <!-- Bootstrap -->"                                                                                                                                                                                                                                                                                                                              
    ##  [13] "    <link href=\"/css/bootstrap.min.css\" rel=\"stylesheet\">"                                                                                                                                                                                                                                                                                       
    ##  [14] "    <link href=\"/css/R.css\" rel=\"stylesheet\">"                                                                                                                                                                                                                                                                                                   
    ##  [15] ""                                                                                                                                                                                                                                                                                                                                                    
    ##  [16] "    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->"                                                                                                                                                                                                                                                          
    ##  [17] "    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->"                                                                                                                                                                                                                                                                      
    ##  [18] "    <!--[if lt IE 9]>"                                                                                                                                                                                                                                                                                                                               
    ##  [19] "      <script src=\"https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js\"></script>"                                                                                                                                                                                                                                                             
    ##  [20] "      <script src=\"https://oss.maxcdn.com/respond/1.4.2/respond.min.js\"></script>"                                                                                                                                                                                                                                                                 
    ##  [21] "    <![endif]-->"                                                                                                                                                                                                                                                                                                                                    
    ##  [22] "  </head>"                                                                                                                                                                                                                                                                                                                                           
    ##  [23] "  <body>"                                                                                                                                                                                                                                                                                                                                            
    ##  [24] "    <div class=\"container page\">"                                                                                                                                                                                                                                                                                                                  
    ##  [25] "      <div class=\"row\">"                                                                                                                                                                                                                                                                                                                           
    ##  [26] "        <div class=\"col-xs-12 col-sm-offset-1 col-sm-2 sidebar\" role=\"navigation\">"                                                                                                                                                                                                                                                              
    ##  [27] "<div class=\"row\">"                                                                                                                                                                                                                                                                                                                                 
    ##  [28] "<div class=\"col-xs-6 col-sm-12\">"                                                                                                                                                                                                                                                                                                                  
    ##  [29] "<p><a href=\"/\"><img src=\"/Rlogo.png\" width=\"100\" height=\"78\" alt = \"R\" /></a></p>"                                                                                                                                                                                                                                                         
    ##  [30] "<p><small><a href=\"/\">[Home]</a></small></p>"                                                                                                                                                                                                                                                                                                      
    ##  [31] "<h2 id=\"download\">Download</h2>"                                                                                                                                                                                                                                                                                                                   
    ##  [32] "<p><a href=\"http://cran.r-project.org/mirrors.html\">CRAN</a></p>"                                                                                                                                                                                                                                                                                  
    ##  [33] "<h2 id=\"r-project\">R Project</h2>"                                                                                                                                                                                                                                                                                                                 
    ##  [34] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [35] "<li><a href=\"/about.html\">About R</a></li>"                                                                                                                                                                                                                                                                                                        
    ##  [36] "<li><a href=\"/logo/\">Logo</a></li>"                                                                                                                                                                                                                                                                                                                
    ##  [37] "<li><a href=\"/contributors.html\">Contributors</a></li>"                                                                                                                                                                                                                                                                                            
    ##  [38] "<li><a href=\"/news.html\">Whatâ<U+0080><U+0099>s New?</a></li>"                                                                                                                                                                                                                                                                                                   
    ##  [39] "<li><a href=\"/bugs.html\">Reporting Bugs</a></li>"                                                                                                                                                                                                                                                                                                  
    ##  [40] "<li><a href=\"http://developer.R-project.org\">Development Site</a></li>"                                                                                                                                                                                                                                                                            
    ##  [41] "<li><a href=\"/conferences.html\">Conferences</a></li>"                                                                                                                                                                                                                                                                                              
    ##  [42] "<li><a href=\"/search.html\">Search</a></li>"                                                                                                                                                                                                                                                                                                        
    ##  [43] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ##  [44] "</div>"                                                                                                                                                                                                                                                                                                                                              
    ##  [45] "<div class=\"col-xs-6 col-sm-12\">"                                                                                                                                                                                                                                                                                                                  
    ##  [46] "<h2 id=\"r-foundation\">R Foundation</h2>"                                                                                                                                                                                                                                                                                                           
    ##  [47] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [48] "<li><a href=\"/foundation/\">Foundation</a></li>"                                                                                                                                                                                                                                                                                                    
    ##  [49] "<li><a href=\"/foundation/board.html\">Board</a></li>"                                                                                                                                                                                                                                                                                               
    ##  [50] "<li><a href=\"/foundation/members.html\">Members</a></li>"                                                                                                                                                                                                                                                                                           
    ##  [51] "<li><a href=\"/foundation/donors.html\">Donors</a></li>"                                                                                                                                                                                                                                                                                             
    ##  [52] "<li><a href=\"/foundation/donations.html\">Donate</a></li>"                                                                                                                                                                                                                                                                                          
    ##  [53] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ##  [54] "<h2 id=\"help-with-r\">Help With R</h2>"                                                                                                                                                                                                                                                                                                             
    ##  [55] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [56] "<li><a href=\"/help.html\">Getting Help</a></li>"                                                                                                                                                                                                                                                                                                    
    ##  [57] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ##  [58] "<h2 id=\"documentation\">Documentation</h2>"                                                                                                                                                                                                                                                                                                         
    ##  [59] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [60] "<li><a href=\"http://cran.r-project.org/manuals.html\">Manuals</a></li>"                                                                                                                                                                                                                                                                             
    ##  [61] "<li><a href=\"http://cran.r-project.org/faqs.html\">FAQs</a></li>"                                                                                                                                                                                                                                                                                   
    ##  [62] "<li><a href=\"http://journal.r-project.org\">The R Journal</a></li>"                                                                                                                                                                                                                                                                                 
    ##  [63] "<li><a href=\"/doc/bib/R-books.html\">Books</a></li>"                                                                                                                                                                                                                                                                                                
    ##  [64] "<li><a href=\"/certification.html\">Certification</a></li>"                                                                                                                                                                                                                                                                                          
    ##  [65] "<li><a href=\"/other-docs.html\">Other</a></li>"                                                                                                                                                                                                                                                                                                     
    ##  [66] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ##  [67] "<h2 id=\"links\">Links</h2>"                                                                                                                                                                                                                                                                                                                         
    ##  [68] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [69] "<li><a href=\"http://www.bioconductor.org\">Bioconductor</a></li>"                                                                                                                                                                                                                                                                                   
    ##  [70] "<li><a href=\"/other-projects.html\">Related Projects</a></li>"                                                                                                                                                                                                                                                                                      
    ##  [71] "<li><a href=\"/gsoc.html\">GSoC</a></li>"                                                                                                                                                                                                                                                                                                            
    ##  [72] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ##  [73] "</div>"                                                                                                                                                                                                                                                                                                                                              
    ##  [74] "</div>"                                                                                                                                                                                                                                                                                                                                              
    ##  [75] "        </div>"                                                                                                                                                                                                                                                                                                                                      
    ##  [76] "        <div class=\"col-xs-12 col-sm-7\">"                                                                                                                                                                                                                                                                                                          
    ##  [77] "        <h1>The R Project for Statistical Computing</h1>"                                                                                                                                                                                                                                                                                            
    ##  [78] "<h2 id=\"getting-started\">Getting Started</h2>"                                                                                                                                                                                                                                                                                                     
    ##  [79] "<p>R is a free software environment for statistical computing and graphics. It compiles and runs on a wide variety of UNIX platforms, Windows and MacOS. To <strong><a href=\"http://cran.r-project.org/mirrors.html\">download R</a></strong>, please choose your preferred <a href=\"http://cran.r-project.org/mirrors.html\">CRAN mirror</a>.</p>"
    ##  [80] "<p>If you have questions about R like how to download and install the software, or what the license terms are, please read our <a href=\"http://cran.R-project.org/faqs.html\">answers to frequently asked questions</a> before you send an email.</p>"                                                                                              
    ##  [81] "<h2 id=\"news\">News</h2>"                                                                                                                                                                                                                                                                                                                           
    ##  [82] "<ul>"                                                                                                                                                                                                                                                                                                                                                
    ##  [83] "<li><p><a href=\"http://cran.r-project.org/src/base/R-3\"><strong>R version 3.4.3 (Kite-Eating Tree)</strong></a> has been released on 2017-11-30.</p></li>"                                                                                                                                                                                         
    ##  [84] "<li><p><a href=\"https://journal.r-project.org/archive/2017-1\"><strong>The R Journal Volume 9/1</strong></a> is available.</p></li>"                                                                                                                                                                                                                
    ##  [85] "<li><p><a href=\"http://cran.r-project.org/src/base/R-3\"><strong>R version 3.3.3 (Another Canoe)</strong></a> has been released on Monday 2017-03-06.</p></li>"                                                                                                                                                                                     
    ##  [86] "<li><p><a href=\"https://journal.r-project.org/archive/2016-2\"><strong>The R Journal Volume 8/2</strong></a> is available.</p></li>"                                                                                                                                                                                                                
    ##  [87] "<li><p><strong>useR! 2017</strong> (July 4 - 7 in Brussels) has opened registration and more at http://user2017.brussels/</p></li>"                                                                                                                                                                                                                  
    ##  [88] "<li><p>Tomas Kalibera has joined the R core team.</p></li>"                                                                                                                                                                                                                                                                                          
    ##  [89] "<li><p>The R Foundation welcomes five new ordinary members: Jennifer Bryan, Dianne Cook, Julie Josse, Tomas Kalibera, and Balasubramanian Narasimhan.</p></li>"                                                                                                                                                                                      
    ##  [90] "<li><p><a href=\"http://journal.r-project.org\"><strong>The R Journal Volume 8/1</strong></a> is available.</p></li>"                                                                                                                                                                                                                                
    ##  [91] "<li><p>The <strong>useR! 2017</strong> conference will take place in Brussels, July 4 - 7, 2017.</p></li>"                                                                                                                                                                                                                                           
    ##  [92] "<li><p><a href=\"http://cran.r-project.org/src/base/R-3\"><strong>R version 3.2.5 (Very, Very Secure Dishes)</strong></a> has been released on 2016-04-14. This is a rebadging of the quick-fix release 3.2.4-revised.</p></li>"                                                                                                                     
    ##  [93] "<li><p><strong>Notice XQuartz users (Mac OS X)</strong> A security issue has been detected with the Sparkle update mechanism used by XQuartz. Avoid updating over insecure channels.</p></li>"                                                                                                                                                       
    ##  [94] "<li><p>The <a href=\"http://www.r-project.org/logo\"><strong>R Logo</strong></a> is available for download in high-resolution PNG or SVG formats.</p></li>"                                                                                                                                                                                          
    ##  [95] "<li><p><strong><a href=\"http://www.r-project.org/useR-2016\">useR! 2016</a></strong>, has taken place at Stanford University, CA, USA, June 27 - June 30, 2016.</p></li>"                                                                                                                                                                           
    ##  [96] "<li><p><a href=\"http://journal.r-project.org\"><strong>The R Journal Volume 7/2</strong></a> is available.</p></li>"                                                                                                                                                                                                                                
    ##  [97] "<li><p><a href=\"http://cran.r-project.org/src/base/R-3\"><strong>R version 3.2.3 (Wooden Christmas-Tree)</strong></a> has been released on 2015-12-10.</p></li>"                                                                                                                                                                                    
    ##  [98] "<li><p><a href=\"http://cran.r-project.org/src/base/R-3\"><strong>R version 3.1.3 (Smooth Sidewalk)</strong></a> has been released on 2015-03-09.</p></li>"                                                                                                                                                                                          
    ##  [99] "</ul>"                                                                                                                                                                                                                                                                                                                                               
    ## [100] "<!--- (Boilerplate for release run-in)"                                                                                                                                                                                                                                                                                                              
    ## [101] "-   [**R version 3.1.3 (Smooth Sidewalk) prerelease versions**](http://cran.r-project.org/src/base-prerelease) will appear starting February 28. Final release is scheduled for 2015-03-09."                                                                                                                                                         
    ## [102] "-->"                                                                                                                                                                                                                                                                                                                                                 
    ## [103] "        </div>"                                                                                                                                                                                                                                                                                                                                      
    ## [104] "      </div>"                                                                                                                                                                                                                                                                                                                                        
    ## [105] "      <div class=\"raw footer\">"                                                                                                                                                                                                                                                                                                                    
    ## [106] "        &copy; The R Foundation. For queries about this web site, please contact"                                                                                                                                                                                                                                                                    
    ## [107] "\t<script type='text/javascript'>"                                                                                                                                                                                                                                                                                                                    
    ## [108] "<!--"                                                                                                                                                                                                                                                                                                                                                
    ## [109] "var s=\"=b!isfg>#nbjmup;xfcnbtufsAs.qspkfdu/psh#?uif!xfcnbtufs=0b?\";"                                                                                                                                                                                                                                                                               
    ## [110] "m=\"\"; for (i=0; i<s.length; i++) {if(s.charCodeAt(i) == 28){m+= '&';} else if (s.charCodeAt(i) == 23) {m+= '!';} else {m+=String.fromCharCode(s.charCodeAt(i)-1);}}document.write(m);//-->"                                                                                                                                                        
    ## [111] "\t</script>;"                                                                                                                                                                                                                                                                                                                                         
    ## [112] "        for queries about R itself, please consult the "                                                                                                                                                                                                                                                                                             
    ## [113] "        <a href=\"help.html\">Getting Help</a> section."                                                                                                                                                                                                                                                                                             
    ## [114] "      </div>"                                                                                                                                                                                                                                                                                                                                        
    ## [115] "    </div>"                                                                                                                                                                                                                                                                                                                                          
    ## [116] "    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->"                                                                                                                                                                                                                                                                                  
    ## [117] "    <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js\"></script>"                                                                                                                                                                                                                                                     
    ## [118] "    <!-- Include all compiled plugins (below), or include individual files as needed -->"                                                                                                                                                                                                                                                            
    ## [119] "    <script src=\"/js/bootstrap.min.js\"></script>"                                                                                                                                                                                                                                                                                                  
    ## [120] "  </body>"                                                                                                                                                                                                                                                                                                                                           
    ## [121] "</html>"

``` r
# Extract the input from the unsuccessful results
urls[!is_ok]
```

    ## $asdf
    ## [1] "http://asdfasdasdkfjlda"

### Getting started

``` r
# Create a list n containing the values: 5, 10, and 20
n <- list(5, 10, 20)

# Call map() on n with rnorm() to simulate three samples
map(n, rnorm)
```

    ## [[1]]
    ## [1] -1.2214383  0.5366951  0.6823449 -0.2334834  0.5430769
    ## 
    ## [[2]]
    ##  [1]  0.1427981 -0.3768627  0.5343543 -1.1500998 -0.7793329 -0.4163524
    ##  [7]  0.6999803  1.8238646  0.2291522  1.6165608
    ## 
    ## [[3]]
    ##  [1] -0.40110741  0.70523027  1.07648758 -0.08135929 -0.48928144
    ##  [6] -0.72633601 -0.95181948 -0.50547837  0.23959839  0.10017463
    ## [11]  1.20794417  1.47918158  0.26047410  0.17667267  0.54214472
    ## [16]  1.88339939 -2.45614515  0.67804570 -0.13506070  0.45448723

### Mapping over two arguments

``` r
# Initialize n
n <- list(5, 10, 20)

# Create a list mu containing the values: 1, 5, and 10
mu <- list(1, 5, 10)

# Edit to call map2() on n and mu with rnorm() to simulate three samples
map2(n, mu, rnorm)
```

    ## [[1]]
    ## [1] 0.8555138 1.6273820 0.5168351 2.0799440 2.3508324
    ## 
    ## [[2]]
    ##  [1] 4.419126 4.830928 3.937672 7.001716 5.603982 4.710123 4.347061
    ##  [8] 5.502339 4.837283 3.634987
    ## 
    ## [[3]]
    ##  [1]  9.572723  9.512621  9.327911 11.445868  9.643655 10.166784  8.746727
    ##  [8] 10.456755  9.301446  9.704700 10.881073 10.121682 10.719822  7.715683
    ## [15]  9.867954 12.123370  9.478883  9.182172 10.450203 10.382097

### Mapping over more than two arguments

``` r
# Initialize n and mu
n <- list(5, 10, 20)
mu <- list(1, 5, 10)

# Create a sd list with the values: 0.1, 1 and 0.1
sd <- list(0.1, 1, 0.1)

# Edit this call to pmap() to iterate over the sd list as well
pmap(list(n, mu, sd), rnorm)
```

    ## [[1]]
    ## [1] 1.0279251 0.9444572 1.0913609 1.1930866 0.7624164
    ## 
    ## [[2]]
    ##  [1] 5.501713 5.469858 5.382754 3.639139 4.418150 5.934115 4.451285
    ##  [8] 4.090516 4.684796 6.577442
    ## 
    ## [[3]]
    ##  [1]  9.958172  9.819503 10.044973  9.892124 10.114344  9.967808  9.901165
    ##  [8] 10.066920 10.213966  9.926671  9.802237  9.991128 10.215458 10.135968
    ## [15]  9.968832 10.064651 10.179693  9.810671  9.999761 10.143640

### Argument matching

``` r
# Name the elements of the argument list
pmap(list(mean=mu, n=n, sd=sd), rnorm)
```

    ## [[1]]
    ## [1] 0.8767423 1.1071667 1.0593482 1.0463707 1.0410143
    ## 
    ## [[2]]
    ##  [1] 3.242663 4.137544 5.275493 6.036465 2.621299 6.631652 4.920310
    ##  [8] 4.935539 4.574548 2.932945
    ## 
    ## [[3]]
    ##  [1]  9.969265 10.081843 10.172196 10.033005 10.041567  9.951397  9.968353
    ##  [8] 10.081489  9.922902  9.973252  9.938671 10.111712 10.066805 10.259793
    ## [15]  9.843459  9.907056  9.930375  9.791008  9.790873 10.101253

### Mapping over functions and their arguments

``` r
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
```

    ## [[1]]
    ## [1]  9.715819 11.230482  8.968986  8.795254 10.252403
    ## 
    ## [[2]]
    ## [1] 4.6339198 2.4844285 3.5151808 3.2225571 0.8456517
    ## 
    ## [[3]]
    ## [1] 0.2046233 0.3730210 0.7343054 0.1042544 0.2313891

### Walk

``` r
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
```

![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-11-1.png)![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-11-2.png)![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-11-3.png)

### Walking over two or more arguments

``` r
# Replace "Sturges" with reasonable breaks for each sample
breaks_list <- list(
  Normal = seq(6, 16, 0.5),
  Uniform = seq(0, 5, 0.25),
  Exp = seq(0, 1.5, 0.1)
)

# Use walk2() to make histograms with the right breaks
walk2(sims, breaks_list, hist)
```

![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-12-1.png)![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-12-2.png)![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-12-3.png)

### Putting together writing functions and walk

``` r
# Turn this snippet into find_breaks()

find_breaks <- function(x){
  rng <- range(sims[[1]], na.rm = TRUE)
  seq(rng[1], rng[2], length.out = 30)
}

# Call find_breaks() on sims[[1]]
find_breaks(sim[[1]])
```

    ##  [1]  7.056114  7.227571  7.399028  7.570485  7.741942  7.913399  8.084856
    ##  [8]  8.256313  8.427770  8.599227  8.770684  8.942141  9.113598  9.285055
    ## [15]  9.456512  9.627969  9.799426  9.970883 10.142340 10.313797 10.485254
    ## [22] 10.656711 10.828168 10.999625 11.171082 11.342539 11.513996 11.685453
    ## [29] 11.856910 12.028367

### Nice breaks for all

``` r
# Use map() to iterate find_breaks() over sims: nice_breaks
nice_breaks <- map(sims, find_breaks)

# Use nice_breaks as the second argument to walk2()
# Note: nice_breaks throws an error
walk2(sims, "Sturges", hist) 
```

![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-14-1.png)![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-14-2.png)![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-14-3.png)

### Walking with many arguments: pwalk

``` r
# Increase sample size to 1000
sims <- invoke_map(f, params, n = 1000)

# Compute nice_breaks (don't change this)
nice_breaks <- map(sims, find_breaks)

# Create a vector nice_titles
nice_titles <- c("Normal(10, 1)", "Uniform(0, 5)", "Exp(5)")

# Use pwalk() instead of walk2()
pwalk(list(x = sims, breaks = "Sturges", main = nice_titles), hist, xlab = "")
```

![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-15-1.png)![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-15-2.png)![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-15-3.png)

### Walking with pipes

``` r
# Pipe this along to map(), using summary() as .f
sims %>%
  walk(hist) %>%
  map(summary)
```

![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-16-1.png)![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-16-2.png)![](advanced_inputs_outputs_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-16-3.png)

    ## $Normal
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   7.088   9.324  10.053  10.022  10.690  13.414 
    ## 
    ## $Uniform
    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ## 0.002173 1.149462 2.582026 2.502412 3.820991 4.999205 
    ## 
    ## $Exp
    ##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
    ## 0.0000031 0.0582116 0.1347326 0.1934939 0.2708029 2.1136884

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
    ## [1] dplyr_0.7.4     purrr_0.2.3     readr_1.1.1     tidyr_0.7.1    
    ## [5] tibble_1.3.4    ggplot2_2.2.1   tidyverse_1.1.1
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.13     cellranger_1.1.0 compiler_3.4.2   plyr_1.8.4      
    ##  [5] bindr_0.1        forcats_0.2.0    tools_3.4.2      digest_0.6.12   
    ##  [9] lubridate_1.6.0  jsonlite_1.5     evaluate_0.10.1  nlme_3.1-131    
    ## [13] gtable_0.2.0     lattice_0.20-35  pkgconfig_2.0.1  rlang_0.1.2     
    ## [17] psych_1.7.8      yaml_2.1.14      parallel_3.4.2   haven_1.1.0     
    ## [21] bindrcpp_0.2     xml2_1.1.1       httr_1.3.1       stringr_1.2.0   
    ## [25] knitr_1.17       hms_0.3          rprojroot_1.2    grid_3.4.2      
    ## [29] glue_1.1.1       R6_2.2.2         readxl_1.0.0     foreign_0.8-69  
    ## [33] rmarkdown_1.6    modelr_0.1.1     reshape2_1.4.2   magrittr_1.5    
    ## [37] backports_1.1.1  scales_0.5.0     htmltools_0.3.6  rvest_0.3.2     
    ## [41] assertthat_0.2.0 mnormt_1.5-5     colorspace_1.3-2 stringi_1.1.5   
    ## [45] lazyeval_0.2.0   munsell_0.4.3    broom_0.4.2
