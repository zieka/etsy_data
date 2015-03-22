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
  titlePanel("ETSY.COM EXPLORER"),
  fluidRow(
    column(3,
      wellPanel(
        h4("Filter"),
        sliderInput(
          "reviews",
          "Number of reviews:",
          0,
          151745,
          80,
          value = c(0, 151745)
        ),
        sliderInput(
          "age",
          "Days the store has been opened:",
          0,
          3554,
          value = c(0, 3554)
        ),
        sliderInput(
          "admirers",
          "Number of admirers:",
          0,
          104451,
          value = c(0,104451),
        ),
        sliderInput(
          "sales",
          "Number of items sold:",
          0,
          452537,
          value = c(0, 452537)
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
    column(6,
      ggvisOutput("plot1"),
      wellPanel(
        span("Number of stores selected:", textOutput("n_stores"))
      )
    )
  )
))
