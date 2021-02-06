# Claire Winfrey
# EBIO 4420-5420
# Lab 03 (5 Feb. 2021)

# PART I
# Lab step #3. The two lines below create variables to store number of bags of
# chips that I start with, and another variable that stores number of guests.
chip_bags <- 5
guests <- 8

# Lab step #5. The variable below is the number of bags of chips that I expect
# each guest to eat.
bags_pp <- 0.4

# Lab step #7. The code below calculates the number of chips bags that I expect
# to remain after my Star Wars Watch party. I add one to the number of guests so
# that I am accounted for too!
leftovers <- chip_bags - (guests + 1) * bags_pp
leftovers #1.4 bags of chips remain for later consumption!

# PART II
# Lab step #8. Make vectors of each person's ranking of the Star Wars movies
Claire <- c(5,7,4,3,1,2,6,9,8) #my REAL ranking :)
Self <- c(7,9,8,1,2,3,4,6,5)
Penny <- c(5,9,8,3,1,2,4,7,6)
Lenny <- c(6,5,4,9,8,7,3,2,1)
Stewie <- c(1,9,5,6,8,7,2,3,4)

# Lab step #9. Accessing Penny's ranking for Episode IV, and storing it as a vew
# variable.
PennyIV <- Penny[4]
PennyIV

# Lab step #10. Concatenate all 5 sets of rankings into a single object.
rankings <- cbind(Claire, Self, Penny, Lenny, Stewie)
dim(rankings) #9 rows, 5 columns
class(rankings)

# Lab step #11
str(PennyIV)
str(Penny)
# Using the str() function on the code above shows that PennyIV is a an object
# with only one component, the number 3. In contrast, the output of str(Penny)
# contains numbers in brackets, which show that Penny is a vector with a length
# of 9, and then the output lists those 9 numbers in order.

# Lab step #12. Create a data frame out of the matrix rankings above
rankings.df1 <- as.data.frame(rankings)
class(rankings.df1) #data frame
rankings.df2 <- data.frame(Claire, Self, Penny, Lenny, Stewie)
class(rankings.df2) #data frame

# Lab step #13. Interrogating the differences between the object created in step
# 10 "rankings" and that created in step 12, "rankings.df1"
# 1. The dimensions of the two objects are the same, 9 rows and 5 columns
dim(rankings) 
dim(rankings.df1)
# 2. Using the str function reveals that "rankings" is a matrix, while 
# "rankings.df1" is a dataframe. It also shows that the str() function is
# seemingly more informative with dataframes than with matrices, as the 
# function provides much more information when used with rankings.df1 than with
# rankings.
str(rankings)
str(rankings.df1)
# 3. Using == shows that although the two objects are different classes of
# objects, they contain the same values in the same order.
rankings == rankings.df1
#. 4 Using the function typeof shows that the storage mode of the two objects is 
# different. rankings has a "double" storage mode, meaning that it contains vectors
# with real values, and rankings.df1, a dataframe, uses a list storage mode
typeof(rankings)
typeof(rankings.df1)

# Lab step #14 Making a vector with Star Wars episode names
names <- c("I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX")

# Lab step #15 Name the rows in the matrix and dataframes
rownames(rankings) <- names
rankings
rownames(rankings.df1) <- names
rankings.df1
rownames(rankings.df2) <- names
rankings.df2

# Lab step #16
rankings[3,] #shows how everyone ranks Episode III (not a fan fave it seems!)

# Lab step #17
rankings.df2[,4] #pulls out all of Lenny's preferences!
rankings.df2[,5] #pulls out all of Stewie's preferences (whihc is what the code
#in the line above would have done had I not added my real rankings as column 1!)

# Lab step #18
rankings.df1[1,5] #The Empire Strikes Back is the BEST!

# Lab step #19
rankings[2,3] #Penny ranks Episode II last!

# Lab step #20
rankings[c(4:6),] #Everyone's rankings of the original trilogy

# Lab step #21
rankings[c(2,5,7),] #Everyone's rankings of Episode II, V, and VII

# Lab step #22
rankings.df1[c(4,6),c(3,5)] #Penny and Stowie's rankings of Episodes IV and VI

# Lab step #23
lenny_II <- rankings.df1[2,4] #save Lenny's original ranking of Episode II
rankings.df1[2,4] <- rankings.df1[5,4] #put in Lenny's ranking for Episode V
# where his ranking for Episode II is currently 
rankings.df1[5,4] <- lenny_II #Make the original ranking of Episode II the new
# ranking for Episode V
# This shows that "rankings.df1", which we just edited, has swapped the correct
# values, because "rankings" is the same as "rankings.df1" was before we edited it
# in this step, step 23
rankings.df1[5,4] == rankings[2,4]
rankings.df1[2,4] == rankings[5,4]

# Lab step #24
rankings["III", "Penny"] #8
rankings["III", "Penny"] == rankings[3, 3] #this shows it worked for the matrix
# from step 10!
rankings.df2["III", "Penny"] #8
rankings.df2["III", "Penny"] == rankings[3, 3] #this shows it worked for one of
# the dataframes from step 12!

# Lab step #25- Undoing the switch from step 23 on rankings.df1
lenny_V <- rankings.df1["V","Lenny"] #save the ranking of episode II in the df 
# edited in step 23
rankings.df1["V","Lenny"] <- rankings.df1["II","Lenny"] #put in Lenny's ranking for Episode II
# where his ranking for Episode V is currently 
rankings.df1["II","Lenny"] <- lenny_V # Put current ranking for V in Episode II spot!
rankings.df1 == rankings #this shows that "rankings.df1", which we just edited,
# is back to how it was originally, because it matches "rankings" everywhere.

# Lab step #26 - redoing the switch from step 23 (so ranking of V is switched with II)
lenny_II <- rankings.df1$Lenny[2] #save Lenny's ranking of Episode II from step 25
rankings.df1$Lenny[2] <- rankings.df1$Lenny[5]
rankings.df1$Lenny[5] <- lenny_II
# The following two lines of code show that I re-created the swapping from step 23, 
# because Lenny's ranking on episode V in this edited dataframe equal his ranking for 
# episode II in the unedited, original matrix, and vice versa!
rankings.df1[5,4] == rankings[2,4] 
rankings.df1[2,4] == rankings[5,4]
