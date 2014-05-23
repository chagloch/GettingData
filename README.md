GettingData
===========
Required packages (sqldf & reshape2)

Required files (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
 - these need to be stored in the working directory (files in /test and /train need to stay in their directory)

Files Read
/test/subject_test.txt   - (Subject the data in x_test was collected from)
/train/subject_train.txt - (Subject the data in x_train was collected from)  
test/y_test.txt          - (Numeric representation of the activity performed)
train/y_train.txt        - (Numeric representation of the activity performed)
test/x_test.txt          - (588 columns of data collected) 
train/X_train.txt        - (588 columns of data collected)
features.txt             - (Descriptive Column names for the data from x_test and x_train)
activity_labels.txt      - (2 column file that translates activity # to activity description)

Process
-Files are read in and stored in dataframes
-Column names are changed to make them easier to understand
-y_train and y_test are translated from activity number to activity description
-The translated activity description is merged with subject_train and subject_test
 the result is a 2 dataframes with subject number and activity description
-features.txt is parsed to look for values that have mean() or std() in them
-features.txt values are used to rename the columns in the x_test and x_train dataframes
-The columns found to have meand() or std() are then used to subset the x_test and x_train data leaving only 
 columns that include mean() or std() in the name
-The Subject and Activity Description data is merge into the data values from x_test and x_train
-The dataframes from the previous step are unioned together to create the finalized tidy dataset
-The dataset is written out

-The average file is then created by melting the tidy dataset based on Subject and Activity Description
-This previous data is then dcasted to get the means of data grouped by Subject and Activity Description
-the dataset is written out
