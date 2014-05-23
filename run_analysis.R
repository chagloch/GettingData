##load required packages
library(sqldf)
library(reshape2)

wd <- getwd()

##read in the text files to datasets 
subject_test <- read.table("~/test/subject_test.txt")
subject_train <- read.table("~/train/subject_train.txt")
y_test <- read.table("~/test/y_test.txt")
y_train <- read.table("~/train/y_train.txt")
act_label <- read.table("~/activity_labels.txt")
x_test <- read.table("~/test/x_test.txt")
x_train <- read.table("~/train/X_train.txt")
features <- read.table("~/features.txt")


##rename the columns to something more descriptive
names(subject_test)[1] <- "Subject"
names(subject_train)[1] <- "Subject"
names(y_test)[1] <- "Activity"
names(y_train)[1] <- "Activity"
names(act_label)[1] <- "Act_Num"
names(act_label)[2] <- "Act_Desc"
names(x_test) <- features$V2
names(x_train) <- features$V2

##Creates a dataframe with the Activity Number replaced with the Actvity Description
act_descdf_test <- sqldf("select b.Act_Desc from y_test a, act_label b where a.Activity = b.Act_Num")
act_descdf_train <- sqldf("select b.Act_Desc from y_train a, act_label b where a.Activity = b.Act_Num")

##Creates a dataframe that combines Activity Description with Person Number
act_persondf_test <- sqldf("select a.Act_Desc, b.Subject from act_descdf_test a, subject_test b where a.rowid = b.rowid")
act_persondf_train <- sqldf("select a.Act_Desc, b.Subject from act_descdf_train a, subject_train b where a.rowid = b.rowid")

##gets the column numbers where the description is like mean() or std()
datacols <- sqldf("select * from features where V2 like '%mean()%' or V2 like '%std%'")

##puts column numbers into a vector to be used to subset x_test
datacols_vec <- as.vector(datacols$V1)

##subsetting just the means and std cols
x_test <- x_test[,datacols_vec]
x_train <- x_train[,datacols_vec]


##Creates a dataframe that combines person & descritive activity with accel data
test_data <- sqldf("select a.*, b.* from act_persondf_test a, x_test b where a.rowid = b.rowid")
train_data <- sqldf("select a.*, b.* from act_persondf_train a, x_train b where a.rowid = b.rowid")

##Union test and training dataset together
tidy_data <- sqldf("select * from test_data union all select * from train_data")

##write tidy data to disk 
write.csv(tidy_data,"~/tidydata.csv")

##This section creates the average file
melt_data <- melt(tidy_data, id.var = c("Subject", "Act_Desc"))
avg_data <- dcast(melt_data, Subject + Act_Desc~variable, mean)

##write tidy data to disk 
write.csv(avg_data,"~/avgdata.csv")

