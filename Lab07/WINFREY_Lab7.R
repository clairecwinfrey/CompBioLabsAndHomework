# Script for Lab #7 (= Assignment #6)
# Claire Winfrey
# March 5, 2021

#################################################
# Writing your own functions, Part 1
#################################################

# Load "DataForLab07.csv" file (assuming that you're already in the Lab07 subfolder)
# setwd("/Users/clairewinfrey/Desktop/Spring_2021/Comp_Bio/CompBio_sandbox/CompBio_on_git/Labs/Lab07")
Lab7_dat <- read.csv(file = "DataForLab07.csv")
class(Lab7_dat) #data frame

# Problem 1. Write a function named triangleArea that calculates and returns
# the area of a triangle when given base and height.

triangleArea <- function(base, height) {
  # two values, base and height, must be given
  # 0.5 multiplied by the base and height is the triangle area
  results <- 0.5 * base * height
  return(results)
}

# Demonstrate that function works by calling it for imaginary triangle with base
# of 10 units and height of 9 units
base_10 <- 10 #set base to be 10 units
height_9 <- 9 #set height to be 9 units

ex_area <- triangleArea(base_10, height_9)
ex_area

#########
# Problem 2. 
# a. Write a function called myAbs() that calculates and returns absolute
# values.

myAbs <- function(dat) {
  if (dat >= 1) {
    return(dat)
  } else {
    return(dat * -1)
  }
}

# Demonstrate that function works by calling it for the number 5 and for the 
# number -2.3.
scal_5 <- 5
scal_n2.3 <- -2.3

myAbs(dat = scal_5)
myAbs(dat = scal_2.3)

# b. Revise your function to make it work on vectors, and demonstrate that it 
# works using the vector c(1.1, 2, 0, -4.3, 9, -12)

vec2 <- c(1.1, 2, 0, -4.3, 9, -12)
myAbs(vec2) #doesn't work!

# One way of getting my function to work on vector input is to change the function
# to take advantage of the fact that a number squared is always positive. I can
# use this fact, combined with the built-in square root function in R, to create 
# a customized absolute value function that works with scalar or vector input, and
# that doesn't need a for loop or if else statements!

myAbs2 <- function(dat) {
  squared <- (dat)^2 # whatever is entered as our argument gets squared, making
  # it positive
  result <- sqrt(squared) #take the square root of this to get the absolute
  # value of whatever we entered!
  return(result)
}

myAbs2(dat=vec2)
# Check on our original scalar values:
myAbs(scal_5)
myAbs(scal_n2.3)

# Or, here is way to change myAbs to make it work by incorporating a for loop! 
# Code taken from our class discussion on March 8
myAbs3 <- function(x) {
  if (is.integer(x) | is.numeric(x)){
    for (i in 1:length(x)) {
      if (is.na(x[i])) {
      cat(paste("\nUh-oh! There's an NA at position", i, "\n"))
    } else if (x[i] < 0) {
      x[i] <- -x[i] 
    }
  }
} else {
  cat("\nUh-oh! Your input doesn't look like a number!\n")
}
return(x)
}

# Check to see if myAbs3 works as expected! And it looks good!
myAbs3(vec2) #on vector defined earlier
myAbs3(c(12, 0, -11.4, NA)) #on a random vector
myAbs3(-12.97) #on a scalar

#########
# Problem 3: Write a function that returns a vector of the first "n" Fibonacci
# numbers, where n is any integer greater than or equal to 3.

fib_func <- function(n, first_num) {
  # n is the number of values in the Fibonacci sequence that the user wants!
  # first_num is the first value in the Fibonacci sequence (either 0 or 1)
  fib_vec <- c(first_num, 1, rep(NA, (n - 2))) # pre-allocate a vector to store Fibonacci
  # sequences, where the length is set by user defined n.
  for (j in 3:length(fib_vec)) {
    fib_vec[j] <- fib_vec[j-1] + fib_vec[j-2] #makes it so that the value in a given 
    # position is equal to the sum of the values in the two positions before it
  }
  return(fib_vec)
}

# Demonstration of usage:
fib_func(n=10, first_num=1) #10 values in Fibonacci sequence and starting value of 1
fib_func(n=10, first_num=0) #10 values in Fibonacci sequence and starting value of 0
fib_func(n=2, first_num = 1) #function breaks when n < 3. 
fib_func(n=1, first_num = 1)
fib_func(n=10.3, first_num=0) #still works with non-integers that are greater than 2
fib_func(n=10.7, first_num=0) #and this shows that R rounds down if n is not a whole number

# Bonus 3b: Make function check user input for the n argument
fib_func3b <- function(n, first_num) {
  # n is the number of values in the Fibonacci sequence that the user wants!
  if ((n == round(n)) & n >= 3) { #only evaluate code below if n is an integer
    #greater than or equal to 3!
    fib_vec <- c(first_num, 1, rep(NA, (n - 2))) # pre-allocate a vector to store Fibonacci
    # sequences, where the length is set by user defined n minus 2. Default is 3!
    for (j in 3:length(fib_vec)) {
      fib_vec[j] <- fib_vec[j-1] + fib_vec[j-2] #makes it so that the value in a given 
      # position is equal to the sum of the values in the two positions before it
    }
  } else {
    cat("\nUh-oh! n must be an integer greater than 3!\n")
  }
  return(fib_vec)
}

# # Demonstration of usage for function fib_func3b
fib_func3b(4,0) #still works as expected for appropriate numbers
fib_func3b(4.3,1) #but as this example and the next 2 show, invalid values of n
# elicit error messages.
fib_func3b(0,0)
fib_func3b(-4,0)

#########
# Problem 4: 

# 4a. Write a function that takes two numbers as its arguments and
# returns the square of the difference between them. 
sq_diff_func <- function(x,y) {
  results <- (x - y) ^ 2
  return(results)
}

# Demonstration of usage:
sq_diff_func(3,5) #Answer is 4, as expected

## with a vector!:
vec_4a <- c(2,4,6) #vector to test out
sq_diff_func(vec_4, 4) #result is a vector with the sequence 4,0,4 as expected!

# 4b. Write a function, without using the mean() function, that calculates the 
# average of a vector of numbers.
avg_vec_func <- function(vec){
  results <- sum(vec)/length(vec)
  return(results)
}

# # Demonstration of usage:
my_vec <- c(5,15,10) #a random vector to test
avg_vec_func(my_vec) #10
avg_vec_func(my_vec) == mean(my_vec) #this shows that my function returns the 
# same answer as the mean function!

# This test case uses the data in "DataForLab07.csv", which was loaded near the
# beginning of this file.
class(Lab7_dat) #object is a dataframe
avg_vec_func(Lab7_dat) #this is not the answer, 108.9457, that I was expecting!
Lab7_vec <- Lab7_dat$x #extract the relevant vector from the dataframe!
is.vector(Lab7_vec) #now we have a vector!
# Try function again:
avg_vec_func(vec=Lab7_vec) #Answer is 108.9457, as expected!

# 4c. Write a function that calculates and returns the sum of squares and incorporates
# the previous two functions that were defined in parts a and b of this problem.

sum_of_squares <- function(vec) { #vec is a user-defined vector!
  if (is.vector(vec)) { #vec must be a vector!
  vec_mean <- avg_vec_func(vec) #calculate the mean of the vector
  diff_vec <- rep(NA, length(vec)) # preallocate a vector to store the squared
  # differences between each value in vec and the mean of vec
  for (i in 1:length(diff_vec)) {
    diff_vec[i] <- sq_diff_func(vec[i], vec_mean) #get squared difference between 
    # each value in vec and the mean of vec using the function defined above
  }
  results <- sum(diff_vec)
  } else {
    cat("\nUh-oh! vec must be a vector!\n")
  }
  return(results)
}

sum_of_squares(Lab7_vec) #Answer is correct, 179442.4!
sum_of_squares(Lab7_dat) #Here, I get an error message because the Lab7_dat,
# which was the default Lab07 data loaded into the script, is not a vector!


