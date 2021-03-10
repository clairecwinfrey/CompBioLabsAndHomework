# Claire Winfrey
# EBIO 4420-5420
# Lab 05 (19 Feb. 2021): Loops & Conditionals

# Part 1: Practice some simple conditionals.

# 1. 
x <- 17
threshold <- 5
if (x > threshold) {
  print(paste())
}

X <- c(5, 4, 6.5, 8, 2.3, 6)
for ( i in 1:length(X) ) {
  if ( X[i] >= 6 ) {
    print(paste("Element #",i,"of X is >= 6"))
  }
}

X <- c(5, 4, 6.5, 8, 2.3, 6)
for ( i in X ) { #R iterating over all values of 5... so first value of x is 5, nothing is done. second iteration, x is 4
  if ( X[i] >= 6 ) {
    print(paste("Element #",i,"of X is >= 6"))
  }
}
