############################################################
# R script to accompany Intro to R for Business, Chapter 09#
# Written by Troy Adair                                    #
############################################################

# Load the previously referenced data frame in "YT_Sample_Validated.RData"
load("YT_Sample_Validated.RData")

# Install and load packages that seem to be dependencies of Rcmdr
if (!require("Rtools")) install.packages("Rtools")
library(Rtools)
if (!require("data.table")) install.packages("data.table")
library(data.table)
if (!require("car")) install.packages("car")
library(car)

# Let's try to run Rcmdr
if (!require("Rcmdr")) install.packages("Rcmdr")
library(Rcmdr)

# Install RColorBrewer and then try again to run Rcmdr
if (!require("RColorBrewer")) install.packages("RColorBrewer")
library(Rcmdr)

# When done with Rcmdr
detach("package:Rcmdr", unload = TRUE)
