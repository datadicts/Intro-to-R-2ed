# CHeck to see if RPostgreSQL package is installed, and install it if it's not
if (!require("RPostgreSQL")) install.packages("RPostgreSQL")

# Load RPostgreSQL package
library('RPostgreSQL')

## Loading required package: DBI

pg = dbDriver("PostgreSQL")

# Local Postgres.app database; no password by default
# Of course, you fill in your own database information here.
con = dbConnect(pg, user="postgres", password="",
                host="localhost", port=5432, dbname="Yellow_Taxi")
dbListTables(con)
dbListFields(con, "temp")
# rs <- dbSendQuery(con,"SELECT * from temp")
long_trips <- dbGetQuery(con, "select * from temp where trip_distance > 100")
head(long_trips)
