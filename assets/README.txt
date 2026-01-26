##################################################
# The data

Your dataset contains 4 variables. Column A is the subject number, Column B is a grouping variable (group 1 and group 2), Columns C & D contain observations from a continuous scale of measurement.  

subID - subject id
group - 1 or 2 (grouping variable)
v1 - continuous variable 1
v2 - continuous variable 2

On the basis of your new experimental hypothesis, make up your own labels for the relevant variables in your dataset. For example, if your hypothesis is about a correlation between two continuous variables, then you will need to decide what the data in the two columns with continuous variables (v1 and v2) represent. The group column would not be relevant to your design, so you could ignore it in this case. 

##################################################
# Your analysis task

Also in the folder is a script called 'all_analysis.R'.

The script contains all the code required to load the data, perform visualisations, run a paired sample t-test between v1 and v2, run a between groups t-test for v1, as well as a correlation analysis between v1 and v2.

Your task is to make a new script called 'my_analysis.R'. Make sure it is saved in your working folder.

You must copy and paste only the code you need to perform your chosen analysis into the script called 'my_analysis.R'. 
You must also add comments to the code you copy and paste over that explains what the code does.

The code you need to perform your chosen analysis includes all the steps you would take - e.g. loading and visualising the data as well as the code for the specific analysis that you have chosen and the specific graph that relates to the result.

Note that good answers will copy only the required code to perform the steps of the analysis that has been chosen. Excellent answers will show cogent commenting of the code and will customise visualisations.

You may relabel the columns in your data frame so that they better match your proposed variables, if you like. However, this is not necessary to complete the assignment.

##################################################
# Other things to know about the data

The continuous variables have been normalised between 0 and 1, so they lend themselves to being DVs of a range of common psychological measurement - e.g. RT, accuracy, % on a scale of measurement. However, if your own experimental design does not readily match a value between 0 and 1, you can just state that your variables were scaled between 0 and 1. This will not affect your marks. 
