# Claire Winfrey
# EBIO 4420-5420
# Lab 05 (19 Feb. 2021): Loops & Conditionals

# Set working directory to be in Labs folder of the sandbox on my local machine.
#setwd("/Users/clairewinfrey/Desktop/Spring_2021/Comp_Bio/CompBio_sandbox/CompBio_on_git/Labs")

# Part 1: Practice some simple conditionals.

# Problem 1. Create a variable named `x` and assign a numeric value of your choosing to it.
# Write an if-else statement that checks if the value is larger than 5.  Your
# code should print a message about whether the value is larger or smaller than 5.

x <- 17 #random numeric value! 
threshold <- 5
if (x > threshold) {
  print(paste("The number", x,"is larger than 5!"))
} else {
  cat(paste("The number", x, "is equal to or less than five")) 
}

# Try the code above with a number equal to or less than five
x2 <- 4.8 #a second random number!
if (x2 > threshold) {
  print(paste("The number", x2,"is larger than 5!"))
} else {
  cat(paste("The number", x2, "is equal to or less than five")) 
}
#########

# Problem 2. 
ex_5_dat <- read.csv(file="Lab05/ExampleData.csv")#obtain and import 
# ExampleData.csv in the Lab 5 folder
my5vec <- ex_5_dat$x #extract data from dataframe made above and make it into a vector
is.vector(my5vec) #TRUE
length(my5vec) #vector has 2024 elements!

# 2a. Make a for loop that goes through this vector and changes every negative
# value into an NA.
for (i in 1:length(my5vec)) {
  if (my5vec[i] < 0) {
    my5vec[i] <- NA
  }
}
my5vec

# 2b. Using logical indexing, change all the NAs to NaNs.
index <- which(is.na(my5vec)) #pull out the indices for values in my5vec that
# are NAs
my5vec[index] <- NaN #change the values identified above to NaNs

# 2c. Use a which statement and integer indexing to change NaNs to zero
int_ind <- which(is.nan(my5vec))
my5vec[int_ind] <- 0
  
# 2d. How many values from the imported data fall into the range between 50
# and 100?
index <-which(my5vec >= 50 & my5vec <= 100)
length(index) #498 of the values are between 50 and 100!

# 2f. Make vector consisting of all the imported data that fall between 50 and 100.
FiftyToOneHundred <- my5vec[index] #use the object from 2d to index
# values in the original vector that are between 50 and 100!
FiftyToOneHundred #this object now has all of the values that correspond to all of
# slots in the vector identified as being between 50 and 100 in part 2d!

# 2e. Save FiftyToOneHundred as a csv.
#setwd("~/Desktop/Spring_2021/Comp_Bio/CompBio_LabsandHW/Lab05/")
write.csv(FiftyToOneHundred, file="FiftyToOneHundred.csv")
#########

# Problem 3: Use the data in CO2_data_cut_paste.csv (Lab 4)
CO2_data_cut_paste <- read.csv(file="Lab04/CO2_data_cut_paste.csv") #Read in data in Lab4

# 3a. What was the first year for which data on "gas" emissions were non-zero?
str(CO2_data_cut_paste)
gas_above_zero <- min(which(CO2_data_cut_paste$Gas > 0 )) #this shows that the first year is the 135th year
yr_one <-CO2_data_cut_paste$Year[gas_above_zero] 
yr_one #The first year that gas emissions were above zero is 1885.

# 3b. During which years were "total" emissions between 200 and 300 million
# metric tons of carbon?
total_200_300 <-which(CO2_data_cut_paste$Total >= 200 & CO2_data_cut_paste$Total <= 300)
CO2_data_cut_paste$Year[total_200_300] #From 1879-1887, the total emissions were
# between 200 and 300 million metric tons of carbon.

# Part 2: Loops + conditionals + biology

# Write code that calculates abundances of predators and prey over time according
# to the Lokta-Volterra model.

# First, set up parameters:
totalGenerations <- 1000
initPrey <- 100 	#initial prey abundance at time t = 1
initPred <- 10		#initial predator abundance at time t = 1
a <- 0.01 		#attack rate
r <- 0.2 		#growth rate of prey
m <- 0.05 		#mortality rate of predators
k <- 0.1 		#conversion constant of prey into predators

# Second, create a time vector and two other vectors to store results:
time_vec <- 1:totalGenerations
prey <- c(initPrey, rep(NA, (totalGenerations-1))) #vector with initial prey followed
# by 999 NAs to store number of  prey over the 1000 generations of observation
pred <- c(initPred, rep(NA, (totalGenerations-1))) #to store numbers of predators over the 1000 gens

# Third, create a for loop to implement the Lotka-Volterra calculations. Fourth,
# add in if statements that make negative prey abundances go to zero

for (t in 2:length(prey)) {
  prey[t] <- prey[t-1] + (r * prey[t-1]) - (a * prey[t-1] * pred[t-1])
  if (prey[t] < 0) {
    prey[t] <- 0
  }
  pred[t] <- pred[t-1] + (k * a * prey[t-1] * pred[t-1]) - (m * pred[t-1])
  if (pred[t] < 0) {
    pred[t] <- 0
  }
}
prey
pred

# Fifth, make a plot that shows the abundances of prey and predators over time
plot(time_vec, prey, xlab = "Time (years)", ylab = "Abundance", col= "blue")
lines(time_vec, pred, col="red")
legend(x =700, y=700, legend= c("Prey", "Predators"), col=c("blue", "red"), lty=1, cex=1)

# Sixth, make a matrix of the results and save it as a csv:
myResults <- matrix(data=NA, nrow = length(time_vec), ncol=3)
dim(myResults) #empty matrix looks as expected
colnames(myResults) <- c("TimeStep", "PreyAbundance", "PredatorAbundance") #change
# column names in the new matrix
myResults[,1] <- time_vec; myResults[,2] <- prey; myResults[,3] <- pred #populate the matrix 
# with the relevant results from the for loop above!
#setwd("~/Desktop/Spring_2021/Comp_Bio/CompBio_LabsandHW/Lab05/")
write.csv(x=myResults, file="PredPredyResults.csv")

