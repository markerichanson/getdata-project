getdata-project
===============
This readme exists to explain how the script written for this assignment works.

Here are the steps from run_analysis.R explained
1. Read the activity_labels.txt from the dataset for later use. While reading, assign meaningful column names.
2. Read the features.txt for later use. Each row of this file corresponds to a column in the X_train and X_test files.
3. Define a function to be called on the test and train data to read them into a useable form. That function does the following:
  1. read the Y_ file. Each row defines the activity from which the corresponding X_ file row was measured. While reading, assign a meaningful column name.
  2. read the X_ file. Use the features information read in step 2 to define meaninful column names while reading.
  3. clean up the resulting column names (removing "." introduced when converting the text from the dataset to acceptable column names)
  4. read the subject_ file. Each row defines the subject performing the activity from the corresponding row in the X_ file.
  5. combine the subject, activity, and measurement (subject, Y_, and X_) data into a single data frame.
  6. Merge in the activity labels based on the match of activity ID between the activity_labels and Y_ data.
4. The above function is called once for the test data and once for the training data.
5. The results are combined into a single data frame.
6. The "measurements on the mean and standard deviation for each measurement" are extracted using subset and a pattern match to identify the appropriate columns from the broader dataset (select those that have "mean" or "std" in the name, without picking up those meanFrequency.
7. Note: descriptive activity names and meaningful variable labels have been included in the result by way of the earlier construction of the data frame.
8. Use ddply to construct the means for each column per subject per activity. The result is a dataset described in the included codebook.
9. Use write.table to dump the result to a text file for submission. 
   Note: the read.table command to read in the data is included in the source file run_analysis.R.

Coursera getdata-004 course project
