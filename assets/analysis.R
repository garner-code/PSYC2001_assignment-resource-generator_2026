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
capture.output(paired_t_test_result, 
               file = "Output/paired_t_test_v1_v2.txt")

###############################################################################
# 
independent_t_test_v1_group <- t.test(v1 ~ group, data = dat, var.equal=TRUE)
independent_t_test_v1_group
capture.output(independent_t_test_v1_group, 
               file = "Output/independent_t_test_v1_group.txt")

###############################################################################
# 
one_sample_t_test_v1 <- t.test(dat$v1, mu = 0)
one_sample_t_test_v1
capture.output(one_sample_t_test_v1, 
               file = "Output/one_sample_t_test_v1.txt")

###############################################################################
# 
correlation_v1_v2 <- cor.test(dat$v1, dat$v2)
correlation_v1_v2
capture.output(correlation_v1_v2, 
               file = "Output/correlation.txt")

###############################################################################
# 
bp_paired <- dat %>%
  pivot_longer(cols = c(v1, v2), names_to = "variable", values_to = "value") %>%
  ggplot(aes(x = variable, y = value)) +
  geom_boxplot(fill = "lightblue", col = "black") +
  labs(x = "Variable", y = "Value") +
  theme_classic()
ggsave("Output/paired_boxplot.png", bp_paired)
bp_paired

###############################################################################
# 
bp_grp_v1 <- dat %>%
  ggplot(aes(x = group, y = v1, fill = group)) +
  geom_boxplot() +
  labs(x = "Group", y = "v1 values") +
  scale_fill_manual(values = c("Group 1" = "lightblue", "Group 2" = "lightcoral")) +
  theme_classic()
ggsave("Output/group_v1_boxplot.png", bp_grp_v1)
bp_grp_v1

###############################################################################
# 
bp_one_samp <- dat %>%
  ggplot(aes(x = "", y = v1)) +
  geom_boxplot(fill = "lightblue", col = "black") +
  labs(x = "", y = "v1 values") +
  theme_classic()
ggsave("Output/onesample_boxplot.png", bp_one_samp)
bp_one_samp

###############################################################################
# 
scatter <- dat %>%
  ggplot(aes(x = v1, y = v2)) +
  geom_point(colour = "orange") +
  labs(x = "v1 values", y = "v2 values") +
  theme_classic()
ggsave("Output/scatter.png", scatter)
scatter
