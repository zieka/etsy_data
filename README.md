# Etsy Data

## Summary
I have scraped some info off of approx 30,000 etsy stores which can be found in the raw data directory.
I created a cleaning script which removes some of the crawler specific columns and cleans the data up for analysis.
I then created a shiny app to allow for some exploratory analysis of the data, including k-means clusterings!
Enjoy!

### How to use:
Do one of the following:

* Visit `https://zieka.shinyapps.io/etsy_data/`
    - Note: this app is slow on shinyapps.io
* Clone and run via R (skip the package installs if you already have them)
    - `git clone https://github.com/zieka/etsy_data`
    - `cd etsy_data` navigate to the directory
    - `R` open an R console
    - `install.packages(c('devtools','data.table'))` 
    - `devtools::install_github(c('rstudio/ggvis', 'rstudio/shiny', 'hadley/dplyr'))`
    - `shiny::runApp()`
