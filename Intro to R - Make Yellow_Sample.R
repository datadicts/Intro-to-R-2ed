# Bringing in column headers as names and using them to set names
if (!require("data.table")) install.packages("data.table")
library("data.table")

header <- read.table("yellow_tripdata_2017-06.csv", header = TRUE,
                     sep=",", nrow = 1)
DF <- fread("yellow_tripdata_2017-06.csv", skip=1, sep=",",
            header=FALSE, data.table=FALSE)
setnames(DF, colnames(header))
# Save the "bad" observations so we can clean them out
# in the next chapter
DF2<-DF[which(DF$total_amount<=0 |
                DF$fare_amount >=100000 |
                DF$fare_amount < 0 |
                DF$trip_distance >= 100),]
# Reform DF with only the "good" observations
DF<-DF[which(DF$total_amount >0 &
               DF$fare_amount <100000 &
               DF$fare_amount >= 0 &
               DF$trip_distance < 100),]

# Select a random subsample of 1,000,000 rows
set.seed(10)
index <- sample(1:nrow(DF), 1000000, replace=FALSE)

# Look at the index to see it's just row numbers
head(index)

# Copy the row numbers for the sample only into Yellow_Sample
Yellow_Sample <- DF[index,]

# Concatenate (or "bind") the random sample and the "bad" ones
Yellow_Sample <- rbind(DF2,Yellow_Sample)

# Save the data frame as csv
fwrite(Yellow_Sample,"Yellow_Sample.csv")