# PSYC2001 Assignment Data Analysis Script
# This script analyzes the data for the PSYC2001 assignment
###############################################################################

# 
library(here) 
library(tidyverse)

###############################################################################
# 
dat <- read.csv(file = here("data.csv")) # reads in CSV files

###############################################################################
# 
dat <- dat %>%
  mutate(group = factor(group, levels = c(1, 2), labels = c("Group 1", "Group 2"))) 

###############################################################################
# 
dat %>%
  ggplot(aes(x = v1)) + # ggplot uses aesthetic (aes()) to map axes
  geom_histogram(col = "black", fill = "lightblue") + # creates a histogram
  labs(x = "v1 values", y = "Count") + # short for "labels", use to label axes and titles
  theme_classic() # changes the theme of the plot to a classic theme. makes it prettier!

###############################################################################
# 
dat %>%
  ggplot(aes(x = v2)) + # ggplot uses aesthetic (aes()) to map axes
  geom_histogram(col = "black", fill = "lightgreen") + # creates a histogram
  labs(x = "v2 values", y = "Count") + # short for "labels", use to label axes and titles
  theme_classic() # changes the theme of the plot to a classic theme. makes it prettier!

# 3. Perform a paired t-test on the observations from c (v1) and d (v2)
t_test_result <- t.test(dat$v1, dat$v2, paired = TRUE)
print("Paired t-test results:")
print(t_test_result)

# 4. Perform a between-subjects t-test for v1 comparing Group 1 and Group 2
t_test_v1_between <- t.test(v1 ~ group, data = dat) # conducts an independent samples t-test to see if v1 differs by group
print("Between-subjects t-test results for v1:")
print(t_test_v1_between)

# 5. Perform a between-subjects t-test for v2 comparing Group 1 and Group 2
t_test_v2_between <- t.test(v2 ~ group, data = dat) # conducts an independent samples t-test to see if v2 differs by group
print("Between-subjects t-test results for v2:")
print(t_test_v2_between)

# 6. Perform a correlation analysis on the observations from c (v1) and d (v2)
correlation_result <- cor.test(dat$v1, dat$v2)
print("Correlation analysis results:")
print(correlation_result)
