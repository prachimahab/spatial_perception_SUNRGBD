# load LME package
library('lme4')
library(nlme)
library('lmerTest')
library('partR2') # https://cran.r-project.org/web/packages/partR2/vignettes/Using_partR2.html
library(AICcmodavg)
library(MuMIn)
library(multilevel) 
library('r2glmm')

library(tidyverse) #for all data wrangling
library(cowplot) #for manuscript ready figures
library(sjPlot) #for plotting lmer and glmer mods
library(sjmisc) 
library(effects)
library(sjstats) #use for r2 functions

# Load data
setwd("/Users/prachimahableshwarkar/Documents/GW/Depth_MTurk/spatial_perception_SUNRGBD/joint_analyses/cues/")
df_125 <- read.csv('125_pos_groundPlane_participantData_for_lme.csv')
df_125$subjID <- factor(df_125$subjID) 
df_125$duration <- factor(df_125$duration)
df_125$stimulus <- factor(df_125$stimulus) 
df_grouped_125 <- read.csv('125_pos_groundPlane_participantData_grouped_for_lme.csv')

mod_main_pos_125 <- lmer(s_residual ~ groundPlane + (1|actual_depth), data=df_125)
summary(mod_main_pos_125)

df_250 <- read.csv('250_pos_groundPlane_participantData_for_lme.csv')
df_250$subjID <- factor(df_250$subjID) 
df_250$duration <- factor(df_250$duration)
df_250$stimulus <- factor(df_250$stimulus) 
df_grouped_250 <- read.csv('250_pos_groundPlane_participantData_grouped_for_lme.csv')

mod_main_pos_250 <- lmer(s_residual ~ groundPlane + (1|actual_depth), data=df_250)
summary(mod_main_pos_250)

df_1000 <- read.csv('1000_pos_groundPlane_participantData_for_lme.csv')
df_1000$subjID <- factor(df_1000$subjID) 
df_1000$duration <- factor(df_1000$duration)
df_1000$stimulus <- factor(df_1000$stimulus) 
df_grouped_1000 <- read.csv('1000_pos_groundPlane_participantData_grouped_for_lme.csv')

mod_main_pos_1000 <- lmer(s_residual ~ groundPlane + (1|actual_depth), data=df_1000)
summary(mod_main_pos_1000)

# sjPlot::plot_model(mod_main,
#                    show.values=TRUE, show.p=TRUE, 
#                    title="")
# sjPlot:: tab_model(mod_main)
# 
# sjPlot::plot_model(mod_main_abs,
#                    show.values=TRUE, show.p=TRUE, 
#                    title="")
# sjPlot:: tab_model(mod_main_abs)

# Plotting code: https://lmudge13.github.io/sample_code/mixed_effects.html

gp_effects_pos_125 <- effects::effect(term= "groundPlane", mod= mod_main_pos_125)
summary(gp_effects_pos_125) #output of what the values are

# Save the effects values as a df:
gp_effects_pos_df_125 <- as.data.frame(gp_effects_pos_125)

gp_effects_pos_250 <- effects::effect(term= "groundPlane", mod= mod_main_pos_250)
summary(gp_effects_pos_250) #output of what the values are

# Save the effects values as a df:
gp_effects_pos_df_250 <- as.data.frame(gp_effects_pos_250)

gp_effects_pos_1000 <- effects::effect(term= "groundPlane", mod= mod_main_pos_1000)
summary(gp_effects_pos_1000) #output of what the values are

# Save the effects values as a df:
gp_effects_pos_df_1000 <- as.data.frame(gp_effects_pos_1000)

neg_df_125 <- read.csv('125_neg_groundPlane_participantData_for_lme.csv')
neg_df_125$subjID <- factor(neg_df_125$subjID) 
neg_df_125$duration <- factor(neg_df_125$duration)
neg_df_125$stimulus <- factor(neg_df_125$stimulus) 
neg_df_grouped_125 <- read.csv('125_neg_groundPlane_participantData_grouped_for_lme.csv')

mod_main_neg_125 <- lmer(s_residual ~ groundPlane + (1|actual_depth), data=neg_df_125)
summary(mod_main_neg_125)

neg_df_250 <- read.csv('250_neg_groundPlane_participantData_for_lme.csv')
neg_df_250$subjID <- factor(neg_df_250$subjID) 
neg_df_250$duration <- factor(neg_df_250$duration)
neg_df_250$stimulus <- factor(neg_df_250$stimulus) 
neg_df_grouped_250 <- read.csv('250_neg_groundPlane_participantData_grouped_for_lme.csv')

mod_main_neg_250 <- lmer(s_residual ~ groundPlane + (1|actual_depth), data=neg_df_250)
summary(mod_main_neg_250)

neg_df_1000 <- read.csv('1000_neg_groundPlane_participantData_for_lme.csv')
neg_df_1000$subjID <- factor(neg_df_1000$subjID) 
neg_df_1000$duration <- factor(neg_df_1000$duration)
neg_df_1000$stimulus <- factor(neg_df_1000$stimulus) 
neg_df_grouped_1000 <- read.csv('1000_neg_groundPlane_participantData_grouped_for_lme.csv')

mod_main_neg_1000 <- lmer(s_residual ~ groundPlane + (1|actual_depth), data=neg_df_1000)
summary(mod_main_neg_1000)

# Plotting code: https://lmudge13.github.io/sample_code/mixed_effects.html

gp_effects_neg_125 <- effects::effect(term= "groundPlane", mod= mod_main_neg_125)
summary(gp_effects_neg_125) #output of what the values are

# Save the effects values as a df:
gp_effects_neg_df_125 <- as.data.frame(gp_effects_neg_125)

gp_effects_neg_250 <- effects::effect(term= "groundPlane", mod= mod_main_neg_250)
summary(gp_effects_neg_250) #output of what the values are

# Save the effects values as a df:
gp_effects_neg_df_250 <- as.data.frame(gp_effects_neg_250)

gp_effects_neg_1000 <- effects::effect(term= "groundPlane", mod= mod_main_neg_1000)
summary(gp_effects_neg_1000) #output of what the values are

# Save the effects values as a df:
gp_effects_neg_df_1000 <- as.data.frame(gp_effects_neg_1000)

#1
#1
groundPlane_plot_pos <- ggplot() + 
  theme_minimal() +  # Removes background and grid
  theme(
    panel.grid = element_blank(),  # Removes grid lines
    panel.background = element_blank(),  # Removes background
    axis.text = element_text(size = 15),  # Increase axis tick label font size
    axis.title = element_text(size = 17),  # Increase axis label font size
    axis.line = element_line(color = "black"),  # Sets the color of axis spines
    # Add tick marks
    axis.ticks = element_line(color = "black"),
    panel.border = element_blank()  # Remove panel border
  ) +
  #pos
  geom_line(data = gp_effects_pos_df_125, aes(x = groundPlane, y = fit), color = "darkgreen") +
  geom_ribbon(data = gp_effects_pos_df_125, aes(x = groundPlane, ymin = lower, ymax = upper), alpha = 0.2, fill = "darkgreen") +

  geom_line(data = gp_effects_pos_df_1000, aes(x = groundPlane, y = fit), color = "darkviolet") +
  geom_ribbon(data = gp_effects_pos_df_1000, aes(x = groundPlane, ymin = lower, ymax = upper), alpha = 0.2, fill = "darkviolet") +

  geom_line(data = gp_effects_pos_df_250, aes(x = groundPlane, y = fit), color = "chocolate") +
  geom_ribbon(data = gp_effects_pos_df_250, aes(x = groundPlane, ymin = lower, ymax = upper), alpha = 0.2, fill = "chocolate") +
  
  #neg
  geom_line(data = gp_effects_neg_df_125, aes(x = groundPlane, y = fit), color = "darkgreen") +
  geom_ribbon(data = gp_effects_neg_df_125, aes(x = groundPlane, ymin = lower, ymax = upper), alpha = 0.2, fill = "darkgreen") +
  
  geom_line(data = gp_effects_neg_df_1000, aes(x = groundPlane, y = fit), color = "darkviolet") +
  geom_ribbon(data = gp_effects_neg_df_1000, aes(x = groundPlane, ymin = lower, ymax = upper), alpha = 0.2, fill = "darkviolet") +
  
  geom_line(data = gp_effects_neg_df_250, aes(x = groundPlane, y = fit), color = "chocolate") +
  geom_ribbon(data = gp_effects_neg_df_250, aes(x = groundPlane, ymin = lower, ymax = upper), alpha = 0.2, fill = "chocolate") +
  
  #6
  labs(x = "Complete Ground Plane", y = "Residuals") +
  #7
  scale_y_continuous(limits = c(-.95, .95))

# Display the plot
print(groundPlane_plot_pos)

