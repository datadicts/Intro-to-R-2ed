############################################################
# R script to accompany Intro to R for Business, Chapter 05#
# Written by Troy Adair                                    #
############################################################

## Variable Assignment Examples

# Numeric
x = 7

# Use better assignment operator
y <- 8

# Using "=" for all things
relationship = lm(formula=y~x)

# Using "<-" for assignment
relationship <- lm(formula=y~x)

# Display value of x in console
x

# Looking at the attributes of X
class(x)
typeof(x)
length(x)
attributes(x)

# Assigning a value as an integer
y <- 8L
class (y)

# Converting a numeric value to an integer
y <- 8
class(y)
typeof(y)
y <- as.integer(y)
class(y)
typeof(y)



# How to programmatically clear console
cat("\014") 

# Character
Name <- "Troy"
class(Name)
typeof(Name)
length(Name)

# Logical
CheckFlag <- T
class(CheckFlag)
typeof(CheckFlag)

# Integer
y
class(y)
typeof(y)

## Storing and Using Dates

#date() 
DateTime <- date()
class(DateTime)
typeof(DateTime)

#Sys.Date
Date <- Sys.Date()
class(Date)
typeof(Date)

#Differences in dates
AgeDays = as.double(Sys.Date() - as.Date("2000-01-01"))
AgeYears = AgeDays/365

#Sys.time
Time <- Sys.time()
class(Time)
typeof(Time)

## Operators

# Programmatically clear the Console
cat("\014")

# How to programmatically remove all variables from Environment
rm(list=ls(all=TRUE))

# Assign two numbers to variables
x <- 100
y <- 250

z1 <- X + y

# The preceeding will return an error because X <> x

z1 <- x + y
z1
z2 <- x - y
z2
z3 <- x * y
z3
z4 <- x / y
z4
z5 <- x ** y
z5
z6 <- x ^ y
z6


# Programmatically remove all variables from Environment
rm(list=ls(all=TRUE))

# Programmatically clear the Console
cat("\014")


## Vectors in R
# Character Vectors

Name1 <- "Sirah"
Name2 <- "Johann"
Name3 <- "Yu"
Name <- c(Name1, Name2, Name3)

name <- c("Mike", "Lucy", "John") 

name
name[1]
name[2:3]
name[c(1,3)]

# For checking presence:
"Lucy" %in% name
any("Lucy"==name)
is.element("Lucy", name)

# For finding first occurance:
match("Lucy", name)

# For finding all occurances as vector of indices:
which("Lucy" == name)

# For finding all occurances as logical vector:
  
"Lucy" == name

# Numeric Vectors and Vector Math
X <- c(1, 3, 5, 7, 9, 11)
X*3
sqrt(X)

Y <- c(2,4,6,8,10,12)
X-Y

Z <- c(0,2,4)

X-Z

Z2 <- c(0,1,2,3)

X-Z2

# Date Vectors
# Use as.Date( ) to convert strings to dates
mydates <- as.Date(c("2007-06-22", "2004-02-13"))
mydates
typeof(mydates)

# Count number of days between 6/22/07 and 2/13/04
days <- mydates[1] - mydates[2]
days


# Missing Data in R
Z <- c(2, NA, 6, 8, NA, 12)
Z
is.na(Z)

Z <- c(2, NULL, 6, 8, NA, 12)
Z
is.na(Z)

# Useful Vector Functions....
nchar(name)
length(X)
mean(X)


# Clean Up 
rm(list=ls(all=TRUE))
cat("\014") 

## Arrays and Matrices

# 2-dimensional arrays
theArray2d <- array(1:9, dim=c(3,3))
View(theArray2d)
theArray2d[1,2]

# 3-dimensional arrays
theArray3d <- array(1:27, dim=c(3,3,3))
theArray3d[1,2,3]
View(theArray3d)

# Matrices
theMatrix <- matrix(1:6, nrow=2)
View(theMatrix)

# Matrix with byrow
theMatrix <- matrix(1:6, nrow=2, byrow=TRUE)
View(theMatrix)

# Lists
y <- list("a", 1L, 1.5, TRUE)
y[3]

class(y)
typeof(y)


#Display the structure of an R object
str(y)
?str()

# Clean Up 
rm(list=ls(all=TRUE))
cat("\014") 

# Data Frames
x <- 10:1
y <- -4:5
z <- c('Hockey', 'Football', 'Curling', 'Soccer', 'Rugby', 'Baseball', 'Golf', 'Basketball', 'Wrestling', 'Tennis')
theDF <- data.frame(x,y,z)
theDF

str(theDF)

theDF[1,2]
View(theDF)

# Using names
theDF$x
theDF$x[3]

# Editing names
names(theDF)<-c("Popularity", "Team Strength", "Sport")
View(theDF)

# Summary of referencing data frame elements
theDF[2:3]
theDF[c(1,3)]
theDF[3]
theDF$Sport
theDF["Sport"]
theDF$Team Strength
theDF$"Team Strength"

# Clean Up 
rm(list=ls(all=TRUE))
cat("\014") 
