# Claire Winfrey
# EBIO 4420-5420
# Lab 04 (12 Feb. 2021)

# PART I: Practice writing for loops
# 1. Print the word "hi" to the console using a for loop
for (i in 1:10) {
  print("hi")
}

# 2. Tim has $10 in his piggybank, receives a $5 allowance each week, and 
# spends $1.34 on 2 packs of gum per week. At the end of each week, how much
# money will Tim have in his piggybank?

piggybank <- 10 #dollars
allowance <- 5 #dollars each week
gum_cost <- 2 * 1.34 #cost of 2 packs of gum per week
weeks <- 8 #relevant time frame

for ( i in 1:weeks ) {
  piggybank <- piggybank + allowance - gum_cost
  print(piggybank) #prints out the balance at the end of each of the 8 weeks
}

# 3. A conservation biologist is studying a population of 2,000 individuals
# that she expects will shrink by 5% each year. What is the expected population
# size each year for the next seven years?

pop <- 2000 #initial number of individuals in the population 
decline <- 0.95 #remaining proportion of individuals the next year
years <- 7 #relevant number of years for the study

for ( i in 1:years ) {
  pop <- pop * decline
  print(pop) # population over the 7 years
}

# 4. Using the discrete-time logistic growth equation to estimate a future
# population size 
n_1 <- 2500 #current population size
pop_size <- c(n_1,rep(NA, 11)) #pre-allocated vector for storing yearly population sizes
K <- 10000 #carrying capacity for the population
r <- 0.8 #intrinsic growth rate of population
years <- 12 #the number of years we want to predict population size

for (i in 1:years) {
  pop_size[i+1] <- pop_size[i] + ( r * pop_size[i] * (K - pop_size[i])/K )
  print(pop_size[i])
}
pop_size[12] #the population in year 12 is predicted to be 9999.985, 
# so about 10,000 individuals

# PART II: Practice writing "for loops" and practice sorting the data produced
# by your loops in arrays

# 5. Basics of array indexing using for loops
# 5a. Make a vector of 18 zeros
zero_vec <- rep(0, 18)
zero_vec

# 5b. Here, I make a for loop over a vector of length 18. Each slot in the vector
# is three multipled by that position in the vector.
vec <- rep(NA, 18) #pre-allocate empty vector
for (i in seq(1,18)) {
  vec[i] <- i * 3 
}
vec #print out resulting vector of multiples of 3!

# 5c. In the vector made in 5a, replace the first 0 with 1
zero_vec[1] <- 1
zero_vec

# 5d. Using the vector created in 5c, create a for loop so that the value stored
# in each position in the vector is equal to one plus twice the value of the 
# previous value of the previous entry

for (i in 1:length(zero_vec)) {
  zero_vec[i+1] <- 1 + (2 * zero_vec[i]) #each value in position i +1 is equal to
  # two times the value in the previous entry, plus one!
}
zero_vec #this prints out the same pattern as in the GitHub assignment page, 
# but it is 19 numbers long instead of 18 numbers long. Despite trying out
# a lot of different approaches (i.e. changing code to i in 1:18), I'm 
# unable to get it to not continue to a length of zero_vec plus 1!

# 6. Making a for loop for the first 20 values in the Fibonacci sequence.
fib_1 <- 0 #first value in Fibonacci sequence
fib_2 <- 1 #second value in Fibonacci sequence 

fib_vec <- c(fib_1, fib_2, rep(NA, 18)) # pre-allocate a vector to store Fibonacci
# sequences
fib_vec_NAs <- 18 #to represent 18 empty slots in fib vec that we are going to loop 
  # through. To avoid "magic numbers"!

for (j in 1:fib_vec_NAs) {
  fib_vec[j+2] <- fib_vec[j] + fib_vec[j + 1] #makes it so that the value in a given 
  # position is equal to the sum of the values in the two positions before it
}
fib_vec

# 7. Store all of the data in question 4 in part 1.
# I stored all of the data as a part of my work in question 4!
time <- 1:13 #years from this year to 12 years in the future
abundance <- pop_size #rename the vector that from question 4 that stored all
# the population sizes 

plot(time, abundance) #plot of the projected population growth of our species,
# starting with this year (time =1).
  

