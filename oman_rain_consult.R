# Load libraries
library(plyr)
library(dplyr)
library(tidyverse)

# Set your filepath see: "Session > Set working directory"
setwd("~/Desktop")

# Read in your data.
rain <- read.csv("Auqrum_nd.csv")

# Filter only one day, in this case June 1st.
june_rain <-
  filter(rain, Date == "2020-06-01")

june_rain$Time <- as.character(june_rain$Time)

# Create a vector of minutes in a day.
Time <- format(seq(as.POSIXct("2020-06-01 00:00", tz="GMT"),
                      length.out=1440, by='1 min'), '%H:%M')

# Create a vector of "2020-06-01" or whatever day it is, yeah?
Date <- as.Date("2020-06-01")

# Create a vector of just NA
Rain_value <- NA

# Put those 3 vectors into a data.frame object.
blank_day <- data.frame(Date, Time, Rain_value)

# Change time vector to character.
blank_day$Time <- as.character(blank_day$Time)

# Bind the day of rain samples with the blank_day of minutes.
all_that_rain <- rbind(blank_day, june_rain)

# Here is the trick! :) Use distinct() to select only the first row, of that minute 
all_that_rain %>% 
  distinct(Time, .keep_all = TRUE)

write.csv(all_that_rain, "june_1st_rain.csv")









