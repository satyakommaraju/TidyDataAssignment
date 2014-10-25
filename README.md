TidyDataAssignment
==================

Repository for the mobile tidy data assignment 
The script is divided into functions for resuability. After sourcing the file into working directory running spruce.data() will write the tidy data as a text file in the working directory.

spruce.data(): Function that combines/calls the individual functions for merging,measuring,describing,cleaning and writing a tidy txt.file.
merge.trainandtestdatasets(): Merges the Training and test data.Reads data from the working directory where the unzipped dataset exists.
extract.meanandstd():Extracts only the measurements of the mean and standard deviation for each variable.
name.act():Name activities Use descriptive column name for subjects
bind.dataxysubjects():Combine mean-std values (x), activities (y) and subjects into one dataframe.
make.tidy.datset(): Create tidy dataset
write.table(tidy, "UCIHARSpruced.txt", row.names=FALSE): Write tidy dataset as txt
