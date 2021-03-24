# Script for Lab #8 (= Assignment #7)
# Claire Winfrey
# March 12, 2021

#################################################
# Lab 08: Documentation & Metadata
# Problem 3 
#################################################

# Start with the logistic growth model for loop from Lab04, create a function
# that turns returns a vector of population sizes and that plots the results:

# 1. Defining a function that returns just the vector of population sizes (i.e. no plot):
log_growth <- function(r, K, gens, init_pop){
  # r = intrinsic growth rate of population
  # K = population carrying capacity
  # gens = the total number of generations (including the initial pop size)
  # init_pop = the initial population size
  pop_size <- c(init_pop, rep(NA, (gens-1))) #pre-allocate vector to store population
  # sizes at each generation.
  for (i in 2:gens) { #for loop to get population sizes at each generation
    pop_size[i] <- pop_size[i-1] + ( r * pop_size[i-1] * (K - pop_size[i-1])/K )
  }
  return(pop_size)
}

# 2. Now, editing the function above so that it also plots the results!
log_growth_plot <- function(r, K, gens, init_pop){
  # r = intrinsic growth rate of population
  # K = population carrying capacity
  # gens = the total number of generations (including the initial pop size)
  # init_pop = the initial population size
  pop_size <- c(init_pop, rep(NA, (gens-1))) #pre-allocate vector to store population
  gens_seq <- seq(1, gens) # make a vector of values to number each generation
  # sizes at each generation.
  for (i in 2:gens) { #for loop to get population sizes at each generation
    pop_size[i] <- pop_size[i-1] + ( r * pop_size[i-1] * (K - pop_size[i-1])/K )
  } 
  pop_mat <- cbind(gens_seq, pop_size)
  plot(pop_mat) #plot results
  return(pop_mat) #return results
}

# Example where I  call both functions
r1 <- 0.8 #example intrinisic growth rate
K1 <- 10000 #example carrying capacity
gens1 <- 12 #example number of generations
gens2 <- 100 #more generatins for cooler plots
init_pop1 <- 2500 #example initial population size

# Testing the first function out:
results_1 <- log_growth(r1, K1, gens1, init_pop1)
results_1 #returns the population size over 12 generations, as expected

# Testing the second function out:
results_2 <- log_growth_plot(r1, K1, gens1, init_pop1)

# With more gens:
results_3 <- log_growth_plot(r1, K1, gens2, init_pop1)
colnames(results_3) <- c("generations", "abundance")
results_3

# Write data to a file 
# set working directory
# setwd("~/Desktop/Spring_2021/Comp_Bio/CompBio_LabsandHW/Lab08") #greyed out for
# when Sam runs my file!
write.csv(x= results_3, file = "intrinsic_growth_rate.csv", row.names= FALSE)

