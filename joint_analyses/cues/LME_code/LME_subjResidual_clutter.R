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
df <- read.csv('clutter_participantData_for_lme.csv')
df$subjID <- factor(df$subjID) 
# df$duration <- factor(df$duration)
df$stimulus <- factor(df$stimulus) 

df_grouped <- read.csv('clutter_participantData_grouped_for_lme.csv')

# Create models 
# fixed effect only:
m_dur<- lm(abs_s_residual ~ duration, data=df)
summary(m_dur)

m_stim<- lm(abs_s_residual ~ stimulus, data=df)
summary(m_stim)


sort(unique(df$duration))

mod_main <- lmer(abs_s_residual ~ clutter + duration + clutter*duration + (1|subjID) + (1|actual_depth), data=df)
summary(mod_main)


sjPlot::plot_model(mod_main,
                   show.values=TRUE, show.p=TRUE, 
                   title="")
sjPlot:: tab_model(mod_main)

# Plotting code: https://lmudge13.github.io/sample_code/mixed_effects.html

# Use the effects package --> effect function. term= the fixed effect you want to get data on, mod= name of your model.
clutter_effects <- effects::effect(term= "clutter", mod= mod_main)
summary(clutter_effects) #output of what the values are

# Save the effects values as a df:
clutter_effects_df <- as.data.frame(clutter_effects)

#1
clutter_plot <- ggplot() + 
  #2
  geom_point(data=subset(df_grouped), aes(clutter, abs_s_residual)) + 
  #3
  geom_point(data=clutter_effects_df, aes(x=clutter, y=fit), color="darkgreen") +
  #4
  geom_line(data=clutter_effects_df, aes(x=clutter, y=fit), color="darkgreen") +
  #5
  geom_ribbon(data= clutter_effects_df, aes(x=clutter, ymin=lower, ymax=upper), alpha= 0.3, fill="darkgreen") +
  #6
  labs(x="clutter", y="Abs(Residuals)")

clutter_plot

# model comparison
anova(mod_main)

BIC()


# https://github.com/bcjaeger/r2glmm#r2glmm
r2 <- r2beta(m6, method = 'sgv', partial = T, data = df)
plot(x=r2)
