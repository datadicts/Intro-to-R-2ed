############################################################
# R script to supplementIntro to R for Business, Chapter 05#
# Written by Troy Adair                                    #
############################################################

## if...else statements vs. ifelse() function
# Loading vector name back into memory

name <- c("Mike", "Lucy", "John") 

# Using if...else statement with one element of name

if (name[2]=="Lucy") {
  print("Name Matched")
} else {
  print("Name NOT Matched")
}

# What happens if we try and use if...else with entire name vector?

if (name=="Lucy") {
  print("Name Matched")
} else {
  print("Name NOT Matched")
}

if (name=="Mike") {
  print("Name Matched")
} else {
  print("Name NOT Matched")
}

# To get vector of results, use ifelse() function:

ifelse(name=="Lucy","Name Matched","Name NOT Matched")

ifelse(name=="John",1,0)

# Programmatically remove all variables from Environment
rm(list=ls(all=TRUE))

# Programmatically clear the Console
cat("\014")


## R for loops
# Let's add another "Lucy" to our list of names and create a vector of ages

name <- c("Mike", "Lucy", "John", "Lucy")
age <- c(7,34,57,9)

# Set n equal to the number of elements in the name vector
n<-length(name)

# Loop to print out the ages of all values where name="Lucy"
for (i in 1:n) {
  if(name[i]=="Lucy") {
    print(age[i])
  } else {}
}

