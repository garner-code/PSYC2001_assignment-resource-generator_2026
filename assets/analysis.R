# PSYC2001 Assignment Data Analysis Script
# This script analyzes the data generated for the PSYC2001 assignment

# Load required packages
library(tidyverse)

# Load the data
dat <- read.csv("data.csv")

# 1. Remove any missing values
dat <- na.omit(dat)

# 2. Relabel the group column (1s and 2s) as a factor
dat <- dat %>%
  mutate(group = recode_factor(group, `1` = "Group 1", `2` = "Group 2"))

# 3. Create histograms of the data in columns c (v1) and d (v2)
# Histogram for v1
ggplot(dat, aes(x = v1)) +
  geom_histogram(fill = "lightblue", color = "black", bins = 30) +
  labs(title = "Histogram of v1", x = "v1 values", y = "Frequency") +
  theme_minimal()

# Histogram for v2
ggplot(dat, aes(x = v2)) +
  geom_histogram(fill = "lightgreen", color = "black", bins = 30) +
  labs(title = "Histogram of v2", x = "v2 values", y = "Frequency") +
  theme_minimal()

# 4. Perform a paired t-test on the observations from c (v1) and d (v2)
t_test_result <- t.test(dat$v1, dat$v2, paired = TRUE)
print("Paired t-test results:")
print(t_test_result)

# 5. Perform a correlation analysis on the observations from c (v1) and d (v2)
correlation_result <- cor.test(dat$v1, dat$v2)
print("Correlation analysis results:")
print(correlation_result)
