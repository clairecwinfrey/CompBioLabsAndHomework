# Script for Lab #11 
# Claire Winfrey
# April 2, 2021

#######################################################################
# Week 11: More data filtering, subsetting, summarizing, and plotting
#######################################################################

# Full citation for data that we're working with:
# Zanne AE, Lopez-Gonzalez G, Coomes DA, Ilic J, Jansen S, Lewis SL, Miller RB, 
# Swenson NG, Wiemann MC, Chave J (2009) Data from: Towards a worldwide wood 
# economics spectrum. Dryad Digital Repository. https://doi.org/10.5061/dryad.234

# Date archived in Dryad associated with the following publication:
# Chave J, Coomes DA, Jansen S, Lewis SL, Swenson NG, Zanne AE (2009) 
# Towards a worldwide wood economics spectrum. Ecology Letters 12(4): 
# 351-366. https://doi.org/10.1111/j.1461-0248.2009.01285.x

##########
# Part I: Getting set up to work with the data

# ("Problems" 1-3)
# Data were downloaded from Dryad and the second tab in the Excel sheet 
# "GlobalWoodDensityDatabase" were saved as a csv in the Lab11 folder
setwd("/Users/clairewinfrey/Desktop/Spring_2021/Comp_Bio/CompBio_LabsandHW/Lab11")
WoodData <- read.csv("GlobalWoodDensityDatabase.csv", stringsAsFactors = F)
head(WoodData)
class(WoodData) #data frame
dim(WoodData)
colnames(WoodData)
colnames(WoodData)[4] <- "WoodDensity" #rename column to make this more simple

###############
# Part II: Working with Wood Density Data

# Problem 4: Removing rows with missing data

# 4a. Which row has no density entered?
which(is.na(WoodData$WoodDensity)) #row 12150 has no density entered
WoodData$WoodDensity[12150] #yep!

# 4b. Remove that row from the data frame.
WoodData <- WoodData[-12150,] #remove row 12150 from the data set
dim(WoodData) #now there are only 16467 rows, when there were initially 16468 
which(is.na(WoodData$WoodDensity)) #and now there are no rows with NA

# Problem 5: Dealing with one kind of pseudoreplication.

# Collapse data set so that 1) each species is only listed once, 2) the data
# frame has the family and binomial information for each species, and 3) the data
# frame has the mean of the density for each species

library("dplyr") #load dplyr library

# So that I can play with this without having to re-make my WoodData df each
# time I mess up, I'll make a copy of the data frame:
WoodDataSandbox <- WoodData
dim(WoodDataSandbox)
# First, how many species should we have (so how many rows should I have
# if the data manipulation is successful?)
length(unique(WoodDataSandbox$Binomial)) #8412

# For one way of tackling this, I followed a tutorial here: https://datacarpentry.org/R-genomics/04-dplyr.html
# and used piping:
WoodDataBySpecies <- WoodDataSandbox %>%
  group_by(Binomial, Family) %>% #keep Family and Binomial information
  summarize(MeanDensity = mean(WoodDensity, na.rm = TRUE))
head(WoodDataBySpecies) #
dim(WoodDataBySpecies) #This is the dimensions that I'd expect!

# Because I'm not too comfortable with the dplyr syntax yet, I'll check to
# make sure that a few MeanDensity columns are as I'd expect:
# I'll see if the average density for Abarema jupunba was correctly calculated
# by comparing it with a calculation done in base R.

index <- which(WoodData$Binomial=="Abarema jupunba")
mean(WoodData$WoodDensity[index]) == WoodDataBySpecies[1,3]
# Because these are unequal, it implies that more fine-tunig of the code is required

