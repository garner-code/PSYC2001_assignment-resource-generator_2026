# PSYC2001 Assignment Data Analysis Script
# This script analyzes the data for the PSYC2001 assignment
###############################################################################

# 
library(here) 
library(tidyverse)

###############################################################################
# 
dat <- read.csv(file = here("data.csv"))

###############################################################################
# 
dat <- dat %>%
  mutate(group = factor(group, levels = c(1, 2), labels = c("Group 1", "Group 2"))) 

###############################################################################
# 
dat %>%
  ggplot(aes(x = v1)) +
  geom_histogram(col = "black", fill = "lightblue") +
  labs(x = "v1 values", y = "Count") +
  theme_classic()

###############################################################################
# 
dat %>%
  ggplot(aes(x = v2)) +
  geom_histogram(col = "black", fill = "lightgreen") +
  labs(x = "v2 values", y = "Count") +
  theme_classic()

###############################################################################
# 
t_test_result <- t.test(dat$v1, dat$v2, paired = TRUE)
print("Paired t-test results:")
print(t_test_result)

###############################################################################
# 
t_test_v1_between <- t.test(v1 ~ group, data = dat)
print("Between-subjects t-test results for v1:")
print(t_test_v1_between)

###############################################################################
# 
t_test_v2_between <- t.test(v2 ~ group, data = dat)
print("Between-subjects t-test results for v2:")
print(t_test_v2_between)

###############################################################################
# 
correlation_result <- cor.test(dat$v1, dat$v2)
print("Correlation analysis results:")
print(correlation_result)
