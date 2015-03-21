# cleaner.R
#
# Copyright (C) 2015 Kyle Scully
#
# Author(s)/Maintainer(s):
# Kyle Scully
#
# This script does the following:
#
#  * cleans etsy dataset of crawler specific columns
#  * remove crawler specific columns
#  * rename opened._source column
#  * calculates shop's age
#

etsy <- read.csv("rawdata/etsy_30k.csv")

#remove crawler specific columns
etsy.clean <- etsy[,c(7,9,10,11,12,13)]

#change date column to use date type
etsy.clean$opened._source <- as.Date(etsy.clean$opened._source , "%B %d %Y")

#rename column for clarity
names(etsy.clean)[2] <- "opened_on"

#make new column
today <- as.Date("2015-03-18")
etsy.clean$age <- as.numeric(today - etsy.clean$opened)