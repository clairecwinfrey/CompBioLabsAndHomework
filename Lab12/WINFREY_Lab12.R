# Script for Lab #12
# Claire Winfrey
# April 2, 2021
# (also worked on in class April 5th and 7th)

# Working with some data from the Colorado Department of Public Health
# and Environment (CDPHE) on COVID-19 in Colorado.

# Changed so that it works on my computer
#setwd("~/Desktop/Spring_2021/Comp_Bio/CompBio_sandbox/CompBio_on_git/Datasets/COVID-19/CDPHE_Data/CDPHE_Data_Portal/")

stateStatsData <- read.csv("DailyStateStats2/CDPHE_COVID19_Daily_State_Statistics_2_2021-04-02.csv", 
                           stringsAsFactors = F)

library("tidyverse")
library("dplyr")
####################################################
## Explore the data
####################################################
names(stateStatsData) 
str(stateStatsData)
summary(stateStatsData)
unique(stateStatsData$Name)
unique(stateStatsData$Desc_)
table(stateStatsData$Name)
View(stateStatsData)

#############################################
# Part 1: (Finish) Getting the data into shape
#############################################

# (going off of what we did together in class):

# 1. subset the data so that we only keep the rows where the text in the column (variable) named "Name" is "Colorado"
ColoradoData <- filter(stateStatsData, Name == "Colorado")

# 2. subset to keep (select) only the columns "Date", "Cases", and "Deaths"
substateStats <-ColoradoData %>%
  select("Date", "Cases", "Deaths")

# 3. change the data in the "Date" column to be actual dates rather than a character
substateStats$Date <- strptime(substateStats$Date, format = "%m/%d/%Y", tz = "")

## my group in class ##
# 4. sort the data so that the rows are in order by date from earliest to latest
require("lubridate")
substateStats <- substateStats %>% 
  arrange(Date)

# 5. subset the data so that we only have dates prior to May 15th, 2020
substateStats$Date <- as.POSIXlt(substateStats$Date, format = "%m/%d/%Y", tz = "")
dt <- as.Date("2020-05-15")
dt <- as.POSIXlt("2020-05-15") #get dates in right format for ggplot later?
index <- which(as.Date(substateStats$Date) < dt)
COearlyCovid <- substateStats[index , ]
View(COearlyCovid) #looks as expected!

# or using lubridate
# require("lubridate") 
# datesTimes <- parse_date_time(x = substateStatsArr$Date, orders = c("mdy"))


# Now do it all in a pipeline with pipes (Sam's example from class)
ColoradoData <- stateStatsData %>% 
  filter(Name == "Colorado") %>% #this removed 5 rowd
  select(Date, Cases, Deaths) %>% 
  mutate(Date = strptime(Date, format = "%m/%d/%Y", tz = "")) %>% #Could not specify stateStatsData$Date becasue then it would go back to the beginning!
  arrange(Date) %>% 
  filter( Date < as.Date("2020-05-15"))
View(ColoradoData)

####################################################
# Part 2: Make plots in R using the data from Part 1
####################################################
# Plot 1: Cases on y axis, Date on x
ggplot(data = ColoradoData,
  mapping = aes(x=Date, y=Cases)) +
  geom_point() +
  geom_line()
  
# Get error "Error: Invalid input: time_trans works with objects of class POSIXct only"

# I'll try a few ways to get around this: 
myPlot <- ggplot(data = ColoradoData,
  mapping = aes(x=as.Date(Date), y=Cases)) +
  geom_line() +
  xlab("Date")
# This above looks like the example in the Lab12 document on GitHub,
# (except that my data shows twice as many cases by May 15th!)

#########
# Plot #2: Date on x-axis, Deaths on y-axis:
myPlot2 <- ggplot(data = ColoradoData,
  mapping = aes(x=as.Date(Date), y=Deaths)) +
  geom_line() +
  xlab("Date")
# Huh, again the shape of my line in the date is quite different than the example
# that we were asked to replicate, but it looks correct based on viewing the ColoradoData
# data frame. 

####################################################
# Part 3: Write a function for adding doubling times
####################################################
addDoublingTimeRefLines <- function( myPlot, doublingTimeVec, timeVar, ObsData, startFrom ) {
  # myPlot is the starting plot, where time or dates are on the x- axis and observations of something are on the y axis.
  # doublingTimeVec is vector which 
  # timeVar is the time or date data you are working with, e.g. ColoradoData$Date
  # ObsData is the observational data you are working with, e.g. ColoradoData$Cases from above
  # Instead of having "startFrom", I make the starting time as below with "timeZero"
  require("ggplot2")
  timeZero <- min(timeVar)
  # I think that for the code below, I wouldn't have to specify the data, because it would work
  # off of whatever the starting plot "myPlot" had as data...
  RefLine1 <- 2^ #the power that 2 is to should reflect 
  myNewPlot <- myPlot + 
    geom_line(mapping = aes(x = timeVar - timeZero, y = RefLine1),
    color = "maroon", 
    linetype = "dashed" ) )
  return( myNewPlot )
}