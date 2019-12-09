# Course3ProgrammingAssignment

Hello. The focus of this code is on two dataframes, desiredData and newData. The former is a selection
from the dataframe allData, which congegates all the relevant data from the zip file
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

The run_analysis script constructs desiredData using the dplyr package to make a selection,
as well as renaming columns. The columns are assigned names based on the "features" document.

The script constructs newData by executing group_by and summarize functions. The grouping is according
to the subject and activity (or y_test and y_train) files. The summarize function was used to calculate the 
mean for all data under each feature for each subject and each activity pair.

For clarification on any of these terms, check the documentation in the zip file!
