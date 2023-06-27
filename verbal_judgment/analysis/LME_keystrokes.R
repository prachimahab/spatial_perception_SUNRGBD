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
setwd("/Users/prachimahableshwarkar/Documents/GW/Depth_MTurk/spatial_perception_SUNRGBD/verbal_judgment/analysis/")
df_subj <- read.csv('keystrokes_participantData_for_lme.csv')
df_subj$subjID <- factor(df_subj$subjID) 
df_subj$duration <- factor(df_subj$duration)
df_subj$stimulus <- factor(df_subj$stimulus) 


mod_main <- lmer(trial_RT ~ actual_depth + duration + actual_depth*duration + (1|subjID), data=df_subj)
summary(mod_main)

mod_keystrokes <- lmer(trial_RT ~ actual_depth + duration + actual_depth*duration + (1|subjID) + (1|keystrokes), data=df_subj)
summary(mod_keystrokes)


sjPlot:: tab_model(mod_main)
sjPlot:: tab_model(mod_keystrokes)


anova(mod_main)
anova(mod_keystrokes)


# Plotting code: https://lmudge13.github.io/sample_code/mixed_effects.html
# 
# Use the effects package --> effect function. term= the fixed effect you want to get data on, mod= name of your model.
gp_effects <- effects::effect(term= "groundPlane", mod= mod_main)
summary(gp_effects) #output of what the values are

# Save the effects values as a df:
gp_effects_df <- as.data.frame(gp_effects)

#1
groundPlane_plot <- ggplot() + 
  #2
  geom_point(data=subset(df_grouped), aes(groundPlane, s_residual)) + 
  #3
  geom_point(data=gp_effects_df, aes(x=groundPlane, y=fit), color="blue") +
  #4
  geom_line(data=gp_effects_df, aes(x=groundPlane, y=fit), color="blue") +
  #5
  geom_ribbon(data= gp_effects_df, aes(x=groundPlane, ymin=lower, ymax=upper), alpha= 0.3, fill="blue") +
  #6
  labs(x="groundPlane", y="Residuals")

groundPlane_plot

gp_effects_abs <- effects::effect(term= "groundPlane", mod= mod_main_abs)
summary(gp_effects_abs) #output of what the values are

# Save the effects values as a df:
gp_effects_abs_df <- as.data.frame(gp_effects_abs)

#1
groundPlane_plot <- ggplot() + 
  #2
  geom_point(data=subset(df_grouped), aes(groundPlane, abs_s_residual)) + 
  #3
  geom_point(data=gp_effects_abs_df, aes(x=groundPlane, y=fit), color="blue") +
  #4
  geom_line(data=gp_effects_abs_df, aes(x=groundPlane, y=fit), color="blue") +
  #5
  geom_ribbon(data= gp_effects_abs_df, aes(x=groundPlane, ymin=lower, ymax=upper), alpha= 0.3, fill="blue") +
  #6
  labs(x="groundPlane", y="Abs(Residuals)")

groundPlane_plot


