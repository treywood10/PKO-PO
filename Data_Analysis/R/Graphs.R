# Make Graphs ----

# Packages ----
require(ggplot2)
require(tidyverse)
require(haven)
require(broom)
require(gridExtra)
require(ggpubr)
require(labelVector)

# Set WD ----
setwd("/Users/treywood/Dropbox/Projects/Active_Projects/PKO_and_PO/Data_Analysis/R")


# H1 Plot ----

# Import dataset #
M1 <- read_dta("M1.dta")


# Rename varaibles #
M1 <- M1 %>%
  mutate(est = `_margin`,
         CI_L = `_ci_lb`,
         CI_U = `_ci_ub`,
         Vol = as.factor(`_m1`),
         Conf = as.factor(`_at2`)) %>%
  select(est, CI_L, CI_U, Vol, Conf)


# Subset dataframe for easier to read graphs #
M1_sub <- subset(M1, Conf == 1 | Conf == 4)


# Make graph #
coef1 <- ggplot(data = M1_sub, aes(shape = Conf)) + 
  geom_pointrange(data = M1_sub, aes(x = Vol, y = est, ymin = CI_L, ymax = CI_U, size = 20),
                  lwd = 1/2, position = position_dodge(width = 0.8),
                  fill = "WHITE", fatten = 25) +
  geom_linerange(aes(x = Vol, ymin = CI_L, ymax = CI_U), size = 3, position = position_dodge(width = 0.8)) +
  scale_x_discrete(labels = c("0" = "Not a Volunteer",
                              "1" = "Volunteer")) +
  scale_shape_discrete(labels = c("None at All", "A Great Deal")) +
  guides(shape = guide_legend(title = "Confidence in the UN", override.aes = list(size = 1.5))) +
  ylab("Probability of UN Preference") +
  ggtitle("Effect of Confidence and HR Volunteer Status on UN Preference") +
theme(plot.title = element_text(hjust = 0.5, size = 45, margin = margin(10, 0, 10, 0)),
      plot.subtitle = element_text(hjust = 0.5, size = 30),
      axis.title = element_text(size = 30),
      axis.title.x = element_blank(),
      axis.title.y = element_text(size = 40, margin = margin(0, 20, 0, 0)),
      legend.title = element_text(size = 40, margin = margin(5, 0, 5, 0)),
      legend.text = element_text(size = 40),
      legend.key.size = unit(2, "cm"),
      axis.text.x = element_text(size = 40),
      axis.text.y = element_text(size = 40),
      text = element_text(family = "Times New Roman"),
      plot.margin = margin(0, 3, 0, 0, "cm"),
      axis.ticks.length = unit(.8, "cm"))
ggsave(filename = "coef_m1.jpg", path = "/Users/treywood/Dropbox/Projects/Active_Projects/PKO_and_PO/Paper", width = 22, height = 15, dpi = 500)


# Make graph with all levels of variables for appendix #
coef1_2 <- ggplot(data = M1, aes(shape = Conf)) + 
  geom_pointrange(data = M1, aes(x = Vol, y = est, ymin = CI_L, ymax = CI_U, size = 20),
                  lwd = 1/2, position = position_dodge(width = 0.8),
                  fill = "WHITE", fatten = 25) +
  geom_linerange(aes(x = Vol, ymin = CI_L, ymax = CI_U), size = 3, position = position_dodge(width = 0.8)) +
  scale_x_discrete(labels = c("0" = "Not a Volunteer",
                              "1" = "Volunteer")) +
  scale_shape_discrete(labels = c("None at All", "Not Very Much", "Quite a Lot", "A Great Deal")) +
  guides(shape = guide_legend(title = "Confidence in the UN", override.aes = list(size = 1.5))) +
  ylab("Probability of UN Preference") +
  ggtitle("Effect of Confidence and HR Volunteer Status on UN Preference") +
  theme(plot.title = element_text(hjust = 0.5, size = 45, margin = margin(10, 0, 10, 0)),
        plot.subtitle = element_text(hjust = 0.5, size = 30),
        axis.title = element_text(size = 30),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 40, margin = margin(0, 20, 0, 0)),
        legend.title = element_text(size = 40, margin = margin(5, 0, 5, 0)),
        legend.text = element_text(size = 40),
        legend.key.size = unit(2, "cm"),
        axis.text.x = element_text(size = 40),
        axis.text.y = element_text(size = 40),
        text = element_text(family = "Times New Roman"),
        plot.margin = margin(0, 3, 0, 0, "cm"),
        axis.ticks.length = unit(.8, "cm"))
ggsave("coef_m1_full.jpg", path = "/Users/treywood/Dropbox/Projects/Active_Projects/PKO_and_PO/Paper", width = 22, height = 15, dpi = 500)


# H2 Plot ----

# Import dataset #
M2 <- read_dta("M2.dta")


# Rename varaibles #
M2 <- M2 %>%
  mutate(est = `_margin`,
         CI_L = `_ci_lb`,
         CI_U = `_ci_ub`,
         Mem = as.factor(`_m1`),
         Conf = as.factor(`_at2`)) %>%
  select(est, CI_L, CI_U, Mem, Conf)


# Subset dataframe for easier to read graphs #
M2_sub <- subset(M2, Conf == 1 | Conf == 4)


# Make graph #
coef2 <- ggplot(data = M2_sub, aes(shape = reorder(Conf, desc(Conf)))) + 
  geom_pointrange(data = M2_sub, aes(x = reorder(Mem, desc(Mem)), y = est, ymin = CI_L, ymax = CI_U),
                  lwd = 1/2, position = position_dodge(width = 0.8),
                  fill = "WHITE", fatten = 25) +
  geom_linerange(aes(x = Mem, ymin = CI_L, ymax = CI_U), size = 3, position = position_dodge(width = 0.8)) +
  scale_x_discrete(labels = c("0" = "Not a Member",
                              "1" = "Inactive Member",
                              "2" = "Active Member")) +
  scale_y_continuous(n.breaks = 7) +
  scale_shape_discrete(labels = c("A Great Deal", "None at All" )) +
  guides(shape = guide_legend(title = "Confidence in the UN", reverse = TRUE, override.aes = list(size = 1.5))) +
  scale_linetype_manual(guide = guide_legend(reverse = TRUE)) +
  ylab("Marginal Effect of PKO on Probability of UN Preference") +
  ggtitle("Effect of Confidence, Membership, and PKO Experience on UN Preference") +
  geom_hline(yintercept = 0) + 
  theme(plot.title = element_text(hjust = 0.5, size = 45, margin = margin(10, 0, 10, 0)),
        plot.subtitle = element_text(hjust = 0.5, size = 30),
        axis.title = element_text(size = 30),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 40, margin = margin(15, 0, 0, 0)),
        legend.title = element_text(size = 40, margin = margin(15, 0, 5, 0)),
        legend.text = element_text(size = 40),
        legend.key.size = unit(2, "cm"),
        axis.text.x = element_text(size = 40),
        axis.text.y = element_text(size = 40),
        text = element_text(family = "Times New Roman"),
        plot.margin = margin(0, 3, 0, 0, "cm"),
        axis.ticks.length = unit(.8, "cm")) +
  coord_flip()
ggsave("coef_m2.jpg", width = 22, height = 15, dpi = 500)


# Make graph with all levels of variables for appendix #
coef2_2 <- ggplot(data = M2, aes(shape = reorder(Conf, desc(Conf)))) + 
  geom_pointrange(data = M2, aes(x = reorder(Mem, desc(Mem)), y = est, ymin = CI_L, ymax = CI_U, size = 20),
                  lwd = 1/2, position = position_dodge(width = 0.8),
                  fill = "WHITE", fatten = 25) +
  geom_linerange(aes(x = Mem, ymin = CI_L, ymax = CI_U), size = 3, position = position_dodge(width = 0.8)) +
  scale_x_discrete(labels = c("0" = "Not a Member",
                              "1" = "Inactive Member",
                              "2" = "Active Member")) +
  scale_shape_discrete(labels = c("A Great Deal", "Quite a Lot", "Not Very Much", "None at All" )) +
  guides(shape = guide_legend(title = "Confidence in the UN", reverse = TRUE, override.aes = list(size = 1.5))) +
  scale_linetype_manual(guide = guide_legend(reverse = TRUE)) +
  ylab("Marginal Effect of PKO on Probability of UN Preference") +
  ggtitle("Effect of Confidence, Membership, and PKO Experience on UN Preference") +
  geom_hline(yintercept = 0) + 
  theme(plot.title = element_text(hjust = 0.5, size = 45, margin = margin(10, 0, 10, 0)),
        plot.subtitle = element_text(hjust = 0.5, size = 30),
        axis.title = element_text(size = 30),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 40, margin = margin(10, 0, 0, 0)),
        legend.title = element_text(size = 40, margin = margin(10, 0, 5, 0)),
        legend.text = element_text(size = 40),
        legend.key.size = unit(2, "cm"),
        axis.text.x = element_text(size = 40),
        axis.text.y = element_text(size = 40),
        text = element_text(family = "Times New Roman"),
        plot.margin = margin(0, 3, 0, 0, "cm"),
        axis.ticks.length = unit(.8, "cm")) +
  coord_flip()
ggsave("coef_m2_full.jpg", width = 22, height = 15, dpi = 500)
