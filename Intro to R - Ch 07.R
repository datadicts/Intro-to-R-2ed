############################################################
# R script to accompany Intro to R for Business, Chapter 07#
# Written by Troy Adair                                    #
############################################################

# Load the previously referenced data frame in "Yellow_Sample.RData"
load("Yellow_Sample.RData")

# Load "validate" package into active memory
if (!require("validate")) install.packages("validate")
library("validate")

# Let's examine Yellow_Sample to remind us what's in it...
# Trick to list column names, numbered and vertically
as.data.frame(colnames(Yellow_Sample))
str(Yellow_Sample)
summary(Yellow_Sample)

# Let's add a new variable with sequential IDs for each row
Yellow_Sample$id<-seq.int(nrow(Yellow_Sample))

# Now we'll check to see that the new "id" variable has been added...
str(Yellow_Sample$id)

# attach() will place the data frame name into the search path, meaning that
# for many functions we can dispense with using the whole data frame name.
attach(Yellow_Sample)

# Now we can actually start using the validate package.
# validator() will take desired rules as inputs...
v <-  validator( trip_distance<100,
                 fare_amount>=0,
                 fare_amount<100000,
                 total_amount>0)
v

# What class/type is v?
class(v)
typeof(v)

# Now, we "confront()" our data with that set of rules, specifying our unique key
cf <- confront(Yellow_Sample,v,key="id")
cf

# Let's put the cf into a data frame object to see if we can see more about it...
out <- as.data.frame(cf)
View(out)

# If we merge this with the original data, will get >4M rows...why?
rm(out)
# So, alternate way to wind up with a tractable data set...
# (Note: we'll see a much better way to handle this with the dplyr() package later)

v1<-validator(trip_distance<100)
v1
cf1<-confront(Yellow_Sample,v1,key="id")
out1<-as.data.frame(cf1)
View(out1)

v2<-validator(fare_amount>=0)
v2
cf2<-confront(Yellow_Sample,v2,key="id")
out2<-as.data.frame(cf2)
# View(out2)

v3<-validator(fare_amount<100000)
v3
cf3<-confront(Yellow_Sample,v3,key="id")
out3<-as.data.frame(cf3)
# View(out3)

v4<-validator(total_amount>0)
v4
cf4<-confront(Yellow_Sample,v4,key="id")
out4<-as.data.frame(cf4)
# View(out4)

# Now, to keep each validation rule and result clear...
names(out1)
names(out1)[3]<-"TD.LT.100"
names(out1)
names(out2)[3]<-"FARE.GE.0"
names(out3)[3]<-"FARE.LT.100000"
names(out4)[3]<-"AMT.GT.0"

# Now to merge the results of the confrontation with Yellow_Sample
# We'll start with "out1"....
YT_Sample_Validated <- merge(out1,Yellow_Sample, by.x="id",by.y="id")
head(YT_Sample_Validated,1)

# " ... and we'll use "subset" to drop "name" and "expression"...
YT_Sample_Validated <- subset(YT_Sample_Validated,select=-c(name,expression))
head(YT_Sample_Validated,1)

# Next, merge "out2" into our (working) merged data frame, YT_Sample_Validated....
YT_Sample_Validated <- merge(out2,YT_Sample_Validated, by.x="id",by.y="id")
YT_Sample_Validated <- subset(YT_Sample_Validated,select=-c(name,expression))

# Next, merge "out3" into our (working) merged data frame, YT_Sample_Validated....
YT_Sample_Validated <- merge(out3,YT_Sample_Validated, by.x="id",by.y="id")
YT_Sample_Validated <- subset(YT_Sample_Validated,select=-c(name,expression))

# Finally, merge "out4" into our (working) merged data frame, YT_Sample_Validated....
YT_Sample_Validated <- merge(out4,YT_Sample_Validated, by.x="id",by.y="id")
YT_Sample_Validated <- subset(YT_Sample_Validated,select=-c(name,expression))


# And let's take a look at what it looks like:
str(YT_Sample_Validated)
View(YT_Sample_Validated)


# Finally, save our validated data set for the next module...
save(YT_Sample_Validated,file="YT_Sample_Validated.RData")


## Dealing with data that needs to be changed and deleted
# Clear out Console and Enviroment
rm(list=ls(all=TRUE))
cat("\014")

DF <- read.csv("PakistanSuicideAttacks Ver 11 (30-November-2017).csv")
class(DF)
typeof(DF)
View(DF)

# Put "DF" in path
attach(DF)

# Install and load tidyverse
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)

# Using pipes
head(select(DF,Date,Time))
DF %>% select(Date, Time) %>% head

# dplyr function distinct
DF_deduped <- distinct(DF,Date,Time,Latitude,Longitude,.keep_all=TRUE)
View(DF_deduped)

# distinct() using pipes...
DF_deduped <- DF %>% distinct(Date,Time,Latitude,Longitude,.keep_all=TRUE)
View(DF_deduped)

# Using mutate() to do find and replace "N/A" with NA
DF_replaced <- mutate(DF_deduped,Time=replace(Time,Time=="N/A",NA))
View(DF_replaced)

# Replacing multiple variables/instances 
DF_replaced <- mutate(DF_deduped,Time=replace(Time,Time=="N/A",NA),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="shiite","Shiite"),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="sunni","Sunni"),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="None",NA),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="",NA))
View(DF_replaced)

# So now pipes start to make sense
DF_replaced <- DF %>% distinct(Date,Time,Latitude,Longitude,.keep_all=TRUE) %>% 
  mutate(Time=replace(Time,Time=="N/A",NA),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="shiite","Shiite"),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="sunni","Sunni"),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="None",NA),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="",NA))
View(DF_replaced)

# One way to  capitalize is override regular expression usage and pass a Perl expression...
DF_capped <- DF_replaced %>%
  mutate(City = sub("(.)", "\\U\\1", City, perl=TRUE))
View(DF_capped)


# But we are using a program that allows us to cherry-pick functions from different packages
if (!require("R.utils")) install.packages("R.utils")
library(R.utils)
DF_capped <- DF_replaced %>% mutate(City = capitalize(City))
View(DF_capped)

# Cleaning up Date
# Will use separate() function from tidyr

# Split the Day of the Week and the Date
DF1 <- DF_capped %>% separate(col=Date,into=c("Day of Week", "Date"),"-",extra="merge")
View(DF1)

#Extract the Year
DF2 <- DF1 %>% mutate(Year=substr(Date, nchar(Date)-3, nchar(Date)),Date=substr(Date,1,nchar(Date)-5))
View(DF2)

# Standardize the "Month-Day" portion by substituting blanks for dashes
DF2$Date <- gsub("-", " ", DF2$Date)
View(DF2)

# Split the Month and the Day
DF3 <- DF2 %>% separate(col=Date,into=c("Month", "Day")," ",extra="merge")
View(DF3)

# Replace alpha Month with Month Number
DF4 <- DF3 %>% mutate(Month=replace(Month,Month=="Jan",1),
                      Month=replace(Month,Month=="Feb",2),
                      Month=replace(Month,Month=="Mar",3),
                      Month=replace(Month,Month=="Apr",4),
                      Month=replace(Month,Month=="May",5),
                      Month=replace(Month,Month=="Jun",6),
                      Month=replace(Month,Month=="Jul",7),
                      Month=replace(Month,Month=="Aug",8),
                      Month=replace(Month,Month=="Sep",9),
                      Month=replace(Month,Month=="Oct",10),
                      Month=replace(Month,Month=="Nov",11),
                      Month=replace(Month,Month=="Dec",12),
                      Month=replace(Month,Month=="January",1),
                      Month=replace(Month,Month=="February",2),
                      Month=replace(Month,Month=="March",3),
                      Month=replace(Month,Month=="April",4),
                      Month=replace(Month,Month=="May",5),
                      Month=replace(Month,Month=="June",6),
                      Month=replace(Month,Month=="July",7),
                      Month=replace(Month,Month=="August",8),
                      Month=replace(Month,Month=="September",9),
                      Month=replace(Month,Month=="October",10),
                      Month=replace(Month,Month=="November",11),
                      Month=replace(Month,Month=="December",12))

View(DF4)

# Re-order the columns to get the Date fields back together and to re-title some of the titles
DF5 = DF4 %>% select(S., "Day of Week", Day, Month, Year, Islamic.Date, Blast.Day.Type, Holiday.Type,
                     Time, City, Latitude, Longitude, Province, Location, Location.Category,
                     Location.Sensitivity,Open.Closed.Space, Influencing.Event.Event,
                     Target.Type, "Target.Sect.If.Any"=Targeted.Sect.if.any, Killed.Min, Killed.Max,
                     Injured.Min, Injured.Max, "No.of.Suicide.Blasts"=No..of.Suicide.Blasts,
                     "Explosive.Weight.Max"=Explosive.Weight..max.,Hospital.Names, 
                     "Temperature.C"=Temperature.C., "Temperature.F"=Temperature.F.)
View(DF5)


# Let's convert the Month, Day, and Year into numeric variables...
DF6 <- DF5 %>% mutate_at(c(3,4,5), as.numeric)



# Using pipes to do most of the last bit at once...
DF_cleaned <- DF2 %>% separate(col=Date,into=c("Month", "Day")," ",extra="merge") %>% 
  mutate(Month=replace(Month,Month=="Jan",1),
         Month=replace(Month,Month=="Feb",2),
         Month=replace(Month,Month=="Mar",3),
         Month=replace(Month,Month=="Apr",4),
         Month=replace(Month,Month=="May",5),
         Month=replace(Month,Month=="Jun",6),
         Month=replace(Month,Month=="Jul",7),
         Month=replace(Month,Month=="Aug",8),
         Month=replace(Month,Month=="Sep",9),
         Month=replace(Month,Month=="Oct",10),
         Month=replace(Month,Month=="Nov",11),
         Month=replace(Month,Month=="Dec",12),
         Month=replace(Month,Month=="January",1),
         Month=replace(Month,Month=="February",2),
         Month=replace(Month,Month=="March",3),
         Month=replace(Month,Month=="April",4),
         Month=replace(Month,Month=="May",5),
         Month=replace(Month,Month=="June",6),
         Month=replace(Month,Month=="July",7),
         Month=replace(Month,Month=="August",8),
         Month=replace(Month,Month=="September",9),
         Month=replace(Month,Month=="October",10),
         Month=replace(Month,Month=="November",11),
         Month=replace(Month,Month=="December",12)) %>% 
  select(S., "Day of Week", Day, Month, Year, Islamic.Date, Blast.Day.Type, Holiday.Type,
         Time, City, Latitude, Longitude, Province, Location, Location.Category,
         Location.Sensitivity,Open.Closed.Space, Influencing.Event.Event,
         Target.Type, "Target.Sect.If.Any"=Targeted.Sect.if.any, Killed.Min, Killed.Max,
         Injured.Min, Injured.Max, "No.of.Suicide.Blasts"=No..of.Suicide.Blasts,
         "Explosive.Weight.Max"=Explosive.Weight..max.,Hospital.Names, 
         "Temperature.C"=Temperature.C., "Temperature.F"=Temperature.F.) %>%
  mutate_at(c(3,4,5), as.numeric) 
View(DF_cleaned)

# Using filter()to subset
DF_holidays <- DF_cleaned %>% filter(Blast.Day.Type=="Holiday")
View(DF_holidays)

# Using arrange()to sort
DF_sorted <- DF_cleaned %>% arrange(Target.Type,desc(Injured.Max))
View(DF_sorted)

# To convert Injured.Max to numeric, use mutate_at()...
str(DF_cleaned$Injured.Max)
DF_cleaned <- DF_cleaned %>% mutate_at(vars(Injured.Max), as.integer)
str(DF_cleaned$Injured.Max)

# Rerunning the sort...
DF_sorted <- DF_cleaned %>% arrange(Target.Type,desc(Injured.Max))
View(DF_sorted)

# Using summarise()
DF_cleaned %>% group_by(Target.Type) %>% 
  summarise(mean=mean(Injured.Max), n=n())

# Using sample_n() and sample_frac()
SampleN <- sample_n(DF_cleaned, 20)
View(SampleN)
SampleP <- sample_frac(DF_cleaned, .1)
View(SampleP)
