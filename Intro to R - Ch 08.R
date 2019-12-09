############################################################
# R script to accompany Intro to R for Business, Chapter 08#
# Written by Troy Adair                                    #
############################################################

# Clean Up 
rm(list=ls(all=TRUE))
cat("\014")

# Store current working directory
projdir <- getwd()
projdir

## Prior to attempting this section, download file
## "YTData.zip" from the link on intro-to-r.com, decompress it,
## and store the resulting folder in the working directory for this project.

# Installing data.table (if required) and loading it into memory
if (!require("data.table")) install.packages("data.table")
library("data.table")

# Setting and checking number of cpu threads
setDTthreads(0)
getDTthreads()

####################################
# Setting up PostgreSQL connection #
####################################

# Check to see if RPostgreSQL package is installed, and install it if it's not
if (!require("RPostgreSQL")) install.packages("RPostgreSQL")

# Load RPostgreSQL package
library('RPostgreSQL')

## Loading required package DBI and defining database driver

pg = dbDriver("PostgreSQL")

# Local Postgres.app database connection; fill in password and 
# your own database information here.

con = dbConnect(pg, user="postgres", password="password",
                host="localhost", port=5432, dbname="postgres")

# List tables in postgres data base
dbListTables(con)

# If exist, remove ytdata table from database
dbRemoveTable(con, "ytdata")

#####################################################
# Setting up to read all csv files in YTData folder #
#####################################################

# Change working directory to YTData folder
setwd("./YTData/")

# First put all file names into a list and display them 
all.files <- list.files(pattern = "*.csv")
all.files

##############################################
# Create function for reading given filename #
##############################################

readFun <- function( filename ) {
  
  message(paste("Processing: ",filename))
  # Feedback indicating filename being processed
  
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

###################################################################
# Using lapply to perform function for all filenames in all.files #
###################################################################

Time <- Sys.time()
mylist <- lapply(all.files, readFun)
Sys.time() - Time

# Reset working directory to previous location
setwd(projdir)

# List fields in ytdata
dbListFields(con, "ytdata")

# Perform query to SELECT observations meeting specified parameters
Time <- Sys.time()
rs <- dbSendQuery(con, "SELECT * FROM ytdata WHERE trip_distance > 100")
long_trips <- dbFetch(rs)
dbClearResult(rs)
Sys.time() - Time

# Examining fetched results

str(long_trips)
summary(long_trips$trip_distance)
View(long_trips)
