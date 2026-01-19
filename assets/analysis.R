# PSYC2001 Assignment Data Analysis Script
# This script analyzes the data generated for the PSYC2001 assignment

# Load the data
# Replace 'your_data.csv' with your actual CSV filename
data <- read.csv("your_data.csv")

# 1. Remove any missing values
data <- na.omit(data)

# 2. Relabel the group column (1s and 2s) as a factor
data$group <- factor(data$group, levels = c(1, 2), labels = c("Group 1", "Group 2"))

# 3. Create histograms of the data in columns c (v1) and d (v2)
# Histogram for v1
hist(data$v1, 
     main = "Histogram of v1", 
     xlab = "v1 values", 
     col = "lightblue", 
     border = "black")

# Histogram for v2
hist(data$v2, 
     main = "Histogram of v2", 
     xlab = "v2 values", 
     col = "lightgreen", 
     border = "black")

# 4. Perform a paired t-test on the observations from c (v1) and d (v2)
t_test_result <- t.test(data$v1, data$v2, paired = TRUE)
print("Paired t-test results:")
print(t_test_result)

# 5. Perform a correlation analysis on the observations from c (v1) and d (v2)
correlation_result <- cor.test(data$v1, data$v2)
print("Correlation analysis results:")
print(correlation_result)
