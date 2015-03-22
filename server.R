# server.R
#
# Copyright (C) 2015 Kyle Scully
#
# Author(s)/Maintainer(s):
# Kyle Scully
#
# This script does the following:
#
#  * builds the controller logic for the shiny webapp
#
library(shiny)
library(ggvis)
library(dplyr)
library(data.table)

# read in cleaned data
all_stores <- read.csv("cleaned_data/etsy_30k.clean.csv")

shinyServer(function(input, output, session) {

  # Filter the stores, returning a data frame
  stores <- reactive({
    #temp variables for input values
    minreviews <- input$reviews[1]
    maxreviews <- input$reviews[2]
    minadmirers <- input$admirers[1]
    maxadmirers <- input$admirers[2]
    mindays <- input$age[1]
    maxdays <- input$age[2]
    minsales <- input$sales[1]
    maxsales <- input$sales[2]

    # Apply filters
    m <- all_stores %>%
      filter(
        reviews >= minreviews,
        reviews <= maxreviews,
        admirers >= minadmirers,
        admirers <= maxadmirers,
        age >= mindays,
        age <= maxdays,
        sales >= minsales,
        sales <= maxsales
      )

    # Optional: filter by location
    if (!is.null(input$location) && input$location != "") {
      location.keyword <- paste0(".*", input$location, ".*")
      m <- m %>% filter(location %like% location.keyword)
    }
    # Optional: filter by cast store_name
    if (!is.null(input$name) && input$name != "") {
      name.keyword <- paste0(".*", input$name, ".*")
      m <- m %>% filter(name %like% name.keyword)
    }

    m <- as.data.frame(m)
    m

  })

  # Function for generating tooltip text
  store_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$name)) return(NULL)

    all_stores <- isolate(stores())
    store <- all_stores[all_stores$name == x$name, ]

    paste0(
      "<b>",
      store$name
    )
  }

  # A reactive expression with the ggvis plot
  vis <- reactive({

  selectedData <- reactive({
    temp <- as.data.frame(stores())
    temp[, c(input$xvar, input$yvar)]
  })

  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })


    # Lables for axes
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]

    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))

    stores %>%
      ggvis(x = xvar, y = yvar, fill = ~factor(clusters()$cluster )) %>%
      layer_points(
        size := 50,
        size.hover := 200,
        fillOpacity := 0.2,
        fillOpacity.hover := 0.5,
        key := ~name) %>%
      group_by(clusters()$cluster) %>%
      layer_model_predictions(model = "lm") %>%
      add_tooltip(store_tooltip, "hover") %>%
      add_axis("x", title = xvar_name) %>%
      add_axis("y", title = yvar_name, title_offset = 70) %>%
      add_legend("fill", title = "K-Means Cluster")

  })

  vis %>% bind_shiny("plot1")

  output$n_stores <- renderText({ nrow(stores()) })
})
