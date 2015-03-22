# ui.R
#
# Copyright (C) 2015 Kyle Scully
#
# Author(s)/Maintainer(s):
# Kyle Scully
#
# This script does the following:
#
#  * builds the UI for the shiny webapp
#
library(shiny)
library(ggvis)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

shinyUI(fluidPage(
  fluidRow(
    column(5,
      wellPanel(
        h4("About"),
        p("This data was scraped from etsy.com.  Use the filters below to find an interesting subset.  Then pick the two attributes you want to compare.  Lastly, you can select a cluster number which runs a kmeans() on your two variables with the number of clusters specificed.  The result: a beautiful graph of your subset with clusters color coded and a linear regression (lm) ran on each grouping.  Enjoy!")
      ),
      wellPanel(
        h4("Filter"),
        sliderInput(
          "reviews",
          "Number of reviews:",
          0,
          151745,
          80,
          value = c(12, 316)
        ),
        sliderInput(
          "age",
          "Days the store has been opened:",
          0,
          3554,
          value = c(419, 1522)
        ),
        sliderInput(
          "admirers",
          "Number of admirers:",
          0,
          104451,
          value = c(103,1777),
        ),
        sliderInput(
          "sales",
          "Number of items sold:",
          0,
          452537,
          value = c(50, 1383)
        )#,
        #textInput("location", "Store's location (city state country) contains:"),
        #textInput("name", "Store name contains:")
      ),
      wellPanel(
        selectInput("xvar", "X-axis variable", axis_vars, selected = "age"),
        selectInput("yvar", "Y-axis variable", axis_vars, selected = "admirers")
      ),
      wellPanel(
        sliderInput("clusters", "Number of clusters:", 1, 4, 1)
      )
    ),
    column(7,
      ggvisOutput("plot1"),
      wellPanel(
        span("Number of stores selected:", textOutput("n_stores"))
      )
    )
  )
))
