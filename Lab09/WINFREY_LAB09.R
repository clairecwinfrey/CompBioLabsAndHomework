# Script for Lab #9 (= Assignment #8)
# Claire Winfrey
# March 19, 2021

#######################################################
# Lab 08: Parsing Dates and Times from a Real Data File
#######################################################

# setwd("~/Desktop/Spring_2021/Comp_Bio/CompBio_sandbox/CompBio_on_git/Datasets/Cusack_et_al/")
camData <- read.csv("Cusack_et_al_random_versus_trail_camera_trap_data_Ruaha_2013_14.csv", stringsAsFactors = F)

# Problem 1: Currently DateTime column is characters. Goal is to get the values in
# this column to represent time as we think of it. (See https://www.stat.berkeley.edu/~s133/dates.html)
camData$DateTime
class(camData$DateTime)

# Make subset of data for trying out different kinds of code
smallVec <- camData$DateTime[1:5]
smallVec

# Try with strptime function:
# getting to know function by using some code from help file
?strptime
dates <- c("02/27/92", "02/27/92", "01/14/92", "02/28/92", "02/01/92")
times <- c("23:03:20", "22:29:56", "01:03:30", "18:21:03", "16:56:26")
x <- paste(dates, times)
strptime(x, "%m/%d/%y %H:%M:%S")

# Try with our subsetted data
attempt1 <- strptime(x=smallVec, "%m/%d/%y %H:%M:%S")
attempt1 # All NAs!

# How does smallVec differ from x in example from help file?
class(x); class(smallVec) #same
x
smallVec
# Differences: x has month, day, year, and our data have day, month, year
# x gives year as two numbers, ours has full year
# x has second and our data do not 

# Maybe we can just change second argument in strptime() to reflect these differneces?
try2 <-strptime(smallVec, "%d/%m/%y %H:%M") 
try2 # still only NAs

# I found on stackoverflow that %Y might let us work with 4-digit years 
try3 <- strptime(smallVec, "%d/%m/%Y %H:%M") 
try3 #YAY! We got something that looks right!
smallVec #looks close enough to the original. Only thing is that, since original
# data are from Tanzania, the time wouldn't be EDT, as is the default here (or is
# maybe because I am currently working in Knoxville, TN?) 
# Tanzania is East Africa Time, GMT +3. 

try4 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz="GMT +3") # doesn't like tz as "GMT +3"
# or "GMT+3". 
try4 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz="EAT") #EAT for East Africa time doesn't work...
try4 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz="UTC+03") #nope
try4 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz="UTC +03") #still no
try4 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz="AST")
try4 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz="GMT+03")
try4 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz="GMT +03")
try4 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz="UTC +3")
try4 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz="UTC+3")
try4 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz="UTC+03:00")

# None of the above is working, which is getting frustrating. 
# I'll compromise and just try to remove the EST designation. 
try5 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz= "", usetz = FALSE) #this isn't working either

# However, when trying to solve the issue above, I found a nifty website that 
# helped me find how to change the time zone!
# Website: https://www.codementor.io/@benjamingorman/dates-and-times-in-r-without-losing-your-sanity-izpgxe4rb
try6 <- strptime(x=smallVec, format="%d/%m/%Y %H:%M", tz="Africa/Kampala")
# YAY, it worked!!!

# NOW, APPLY TECHNIQUE TO WHOLE DATASET
FixedDateTime <- strptime(camData$DateTime, format="%d/%m/%Y %H:%M", tz="Africa/Kampala")
FixedDateTime #looks good!

camData$DateTime <- FixedDateTime
camData$DateTime #looks correct

########### FIN
# Well, that's all I was able to complete in a few hours, because wowza that first problem took a lot of time!
