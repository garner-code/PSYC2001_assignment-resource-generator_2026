# PSYC2001 Assignment Data Analysis Script
# This script analyzes the data for the PSYC2001 assignment
###############################################################################

# 
library(here) 
library(tidyverse)

###############################################################################
# 
dat <- read.csv(file = here("Data", "data.csv"))
head(dat)

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
paired_t_test_result <- t.test(dat$v1, dat$v2, paired = TRUE)
paired_t_test_result

###############################################################################
# 
t_test_v1_between <- t.test(v1 ~ group, data = dat)
t_test_v1_between

###############################################################################
# 
correlation_result <- cor.test(dat$v1, dat$v2)
correlation_result

###############################################################################
# 
dat %>%
  pivot_longer(cols = c(v1, v2), names_to = "variable", values_to = "value") %>%
  ggplot(aes(x = variable, y = value)) +
  geom_boxplot(fill = "lightblue", col = "black") +
  labs(x = "Variable", y = "Value") +
  theme_classic()

###############################################################################
# 
dat %>%
  ggplot(aes(x = group, y = v1, fill = group)) +
  geom_boxplot() +
  labs(x = "Group", y = "v1 values") +
  scale_fill_manual(values = c("Group 1" = "lightblue", "Group 2" = "lightcoral")) +
  theme_classic()

###############################################################################
# 
dat %>%
  ggplot(aes(x = group, y = v2, fill = group)) +
  geom_boxplot() +
  labs(x = "Group", y = "v2 values") +
  scale_fill_manual(values = c("Group 1" = "lightgreen", "Group 2" = "lightyellow")) +
  theme_classic()

###############################################################################
# 
dat %>%
  ggplot(aes(x = v1, y = v2)) +
  geom_point(colour = "orange") +
  labs(x = "v1 values", y = "v2 values") +
  theme_classic()


