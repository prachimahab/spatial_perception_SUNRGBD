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
df <- read.csv('groundPlane_participantData_for_lme.csv')
df$subjID <- factor(df$subjID) 
df$duration <- factor(df$duration)
df$stimulus <- factor(df$stimulus) 

df_grouped <- read.csv('groundPlane_participantData_grouped_for_lme.csv')

# Create models 
# fixed effect only:
m_dur<- lm(abs_s_residual ~ duration, data=df)
summary(m_dur)

m_stim<- lm(abs_s_residual ~ stimulus, data=df)
summary(m_stim)


sort(unique(df$duration))

mod_main <- lmer(abs_s_residual ~ groundPlane + duration + groundPlane*duration + (1|subjID) + (1|actual_depth), data=df)
summary(mod_main)


sjPlot::plot_model(mod_main,
                   show.values=TRUE, show.p=TRUE, 
                   title="")
sjPlot:: tab_model(mod_main)

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
  geom_point(data=subset(df_grouped), aes(groundPlane, abs_s_residual)) + 
  #3
  geom_point(data=gp_effects_df, aes(x=groundPlane, y=fit), color="blue") +
  #4
  geom_line(data=gp_effects_df, aes(x=groundPlane, y=fit), color="blue") +
  #5
  geom_ribbon(data= gp_effects_df, aes(x=groundPlane, ymin=lower, ymax=upper), alpha= 0.3, fill="blue") +
  #6
  labs(x="groundPlane", y="Abs(Residuals)")

groundPlane_plot

ggplot(df_grouped, aes(x=duration, y=abs_s_residual, group = interaction(duration, groundPlane))) +
  geom_smooth(method="lm")

# Use the effects package --> effect function. term= the fixed effect you want to get data on, mod= name of your model.
dur_effects <- effects::effect(term= "duration", mod= mod_main)
summary(dur_effects) #output of what the values are

# Save the effects values as a df:
dur_effects_df <- as.data.frame(dur_effects)

#1
dur_plot <- ggplot() + 
  #2
  geom_point(data=subset(df), aes(duration, abs_s_residual)) + 
  #3
  geom_point(data=dur_effects_df, aes(x=duration, y=fit), color="yellow") +
  #4
  geom_line(data=dur_effects_df, aes(x=duration, y=fit), color="yellow") +
  #5
  geom_ribbon(data= dur_effects_df, aes(x=duration, ymin=lower, ymax=upper), alpha= 0.3, fill="yellow") +
  #6
  labs(x="duration", y="Abs(Residuals)")

dur_plot

# https://rdrr.io/cran/lmerTest/man/plot.ls_means.html
(lsm <- ls_means(mod_main))

# Multi-frame plot of the LS-means
plot(lsm)

# Compute list of 'single frame' plots:
res <- plot(lsm, mult=FALSE)

# Display each plot separately:
plot(res[[1]])
plot(res[[2]])

# Example with pairwise differences of LS-means:
(lsm <- ls_means(model, pairwise = TRUE))
plot(lsm, which="Temp")

# model comparison
anova(mod_main)

BIC()


# https://github.com/bcjaeger/r2glmm#r2glmm
r2 <- r2beta(m6, method = 'sgv', partial = T, data = df)
plot(x=r2)
