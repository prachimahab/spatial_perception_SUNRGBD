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
df <- read.csv('participantData_for_lme.csv')
df$subjID <- factor(df$subjID) 
df$duration <- factor(df$duration)
df$stimulus <- factor(df$stimulus) 

df_grouped <- read.csv('participantData_grouped_for_lme.csv')


sort(unique(df$duration))
m6 <- lmer(abs_error ~ clutter + groundPlane + duration + clutter*groundPlane*duration + (1|subjID), data=df)
summary(m6)

m7 <- lmer(abs_error ~ clutter + groundPlane + duration + clutter*groundPlane*duration + (1|subjID) + (1|actual_depth), data=df)
summary(m7)

sjPlot::plot_model(m6,
                   show.values=TRUE, show.p=TRUE,
                   title="")
sjPlot:: tab_model(m6)

sjPlot::plot_model(m7,
                   show.values=TRUE, show.p=TRUE,
                   title="")
sjPlot:: tab_model(m7)

# Plotting code: https://lmudge13.github.io/sample_code/mixed_effects.html

# Use the effects package --> effect function. term= the fixed effect you want to get data on, mod= name of your model.
gp_effects <- effects::effect(term= "groundPlane", mod= m7)
summary(gp_effects) #output of what the values are

c_effects <- effects::effect(term= "clutter", mod= m7)
summary(c_effects) #output of what the values are

# Save the effects values as a df:
gp_effects_df <- as.data.frame(gp_effects)
c_effects_df <- as.data.frame(c_effects)

#1
groundPlane_plot <- ggplot() + 
  #2
  geom_point(data=subset(df_grouped), aes(groundPlane, abs_error)) + 
  #3
  geom_point(data=gp_effects_df, aes(x=groundPlane, y=fit), color="blue") +
  #4
  geom_line(data=gp_effects_df, aes(x=groundPlane, y=fit), color="blue") +
  #5
  geom_ribbon(data= gp_effects_df, aes(x=groundPlane, ymin=lower, ymax=upper), alpha= 0.3, fill="blue") +
  #6
  labs(x="groundPlane", y="Abs(Estimate-Actual)")

groundPlane_plot

clutter_plot <- ggplot() + 
  #2
  geom_point(data=subset(df_grouped), aes(clutter, abs_error)) + 
  #3
  geom_point(data=c_effects_df, aes(x=clutter, y=fit), color="darkgreen") +
  #4
  geom_line(data=c_effects_df, aes(x=clutter, y=fit), color="darkgreen") +
  #5
  geom_ribbon(data= c_effects_df, aes(x=clutter, ymin=lower, ymax=upper), alpha= 0.3, fill="darkgreen") +
  #6
  labs(x="clutter", y="Abs(Estimate-Actual)")

clutter_plot



# model comparison
anova(m0,m1,m2,m3,m4,m5,m6)

BIC(m0,m1,m2,m3,m4,m5,m6)


# https://github.com/bcjaeger/r2glmm#r2glmm
r2 <- r2beta(m6, method = 'sgv', partial = T, data = df)
plot(x=r2)
