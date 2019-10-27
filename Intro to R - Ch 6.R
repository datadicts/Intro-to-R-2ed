############################################################
# R script to accompany Intro to R for Business, Chapter 6 #
# Written by Troy Adair                                    #
############################################################

# Clean Up 
rm(list=ls(all=TRUE))
cat("\014")

# Store current working directory
projdir <- getwd()
projdir

## Reading in external data
## Prior to attempting this section, download file
## "yellow-tripdata_2017-06.csv" from the link on intro-to-r.com
## and store it in working directory for this project.

## Reading in our csv file using fread() from package data.table 
# Installing data.table (if required) and loading it into memory
if (!require("data.table")) install.packages("data.table")
library("data.table")

#Checking and setting number of cpu threads
setDTthreads(0)
getDTthreads()

########################


# Check to see if RPostgreSQL package is installed, and install it if it's not
if (!require("RPostgreSQL")) install.packages("RPostgreSQL")

# Load RPostgreSQL package
library('RPostgreSQL')

## Loading required package: DBI

pg = dbDriver("PostgreSQL")

# Local Postgres.app database; no password by default
# Of course, you fill in your own database information here.
con = dbConnect(pg, user="postgres", password="Pain@2type",
                host="localhost", port=5432, dbname="postgres")
dbListTables(con)
# remove table from database
dbRemoveTable(con, "ytdata")


## First put all file names into a list 
setwd("./YTData/")
library(data.table)
all.files <- list.files(pattern = "*.csv")
all.files
## Read data using fread
readFun <- function( filename ) {
  
  message(paste("Processing: ",filename))
  # read in the data
  
  header <- read.table(filename, header = TRUE,
                       sep=",", nrow = 1)
  DF <- fread(filename, skip=1, sep=",",
              header=FALSE, data.table=FALSE,
              showProgress=FALSE)
  setnames(DF, colnames(header))
  rm(header)
  message(paste("Writing to PostgreSQL"))
  dbWriteTable(con, "ytdata", 
               value = DF, append = TRUE, row.names = FALSE)
  return( DF )
}



# then using 
Time <- Sys.time()
mylist <- lapply(all.files, readFun)
Sys.time() - Time

dbListFields(con, "ytdata")

Time <- Sys.time()
rs <- dbSendQuery(con, "SELECT * FROM ytdata WHERE trip_distance > 100")
long_trips <- dbFetch(rs)
dbClearResult(rs)
Sys.time() - Time

str(long_trips)
View(long_trips)

summary(long_trips$trip_distance)
