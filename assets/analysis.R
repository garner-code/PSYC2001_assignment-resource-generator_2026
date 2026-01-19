# PSYC2001 Assignment Data Analysis Script
# This script analyzes the data generated for the PSYC2001 assignment

# Load required packages
library(here) # loads in the specified package
library(tidyverse)

# Load the data using here package
dat <- read.csv(file = here("data.csv")) # reads in CSV files

# 1. Relabel the group column (1s and 2s) as a factor using tidyverse
dat <- dat %>%
  mutate(group = factor(group, levels = c(1, 2), labels = c("Group 1", "Group 2"))) # changes the group variable to a factor with levels Group 1 and Group 2

# 2. Create histograms of the data in columns c (v1) and d (v2) using ggplot2
# Histogram for v1
dat %>%
  ggplot(aes(x = v1)) + # ggplot uses aesthetic (aes()) to map axes
  geom_histogram(col = "black", fill = "lightblue") + # creates a histogram
  labs(x = "v1 values", y = "Count") + # short for "labels", use to label axes and titles
  theme_classic() # changes the theme of the plot to a classic theme. makes it prettier!

# Histogram for v2
dat %>%
  ggplot(aes(x = v2)) + # ggplot uses aesthetic (aes()) to map axes
  geom_histogram(col = "black", fill = "lightgreen") + # creates a histogram
  labs(x = "v2 values", y = "Count") + # short for "labels", use to label axes and titles
  theme_classic() # changes the theme of the plot to a classic theme. makes it prettier!

# 3. Perform a paired t-test on the observations from c (v1) and d (v2)
t_test_result <- t.test(dat$v1, dat$v2, paired = TRUE)
print("Paired t-test results:")
print(t_test_result)

# 4. Perform a correlation analysis on the observations from c (v1) and d (v2)
correlation_result <- cor.test(dat$v1, dat$v2)
print("Correlation analysis results:")
print(correlation_result)
