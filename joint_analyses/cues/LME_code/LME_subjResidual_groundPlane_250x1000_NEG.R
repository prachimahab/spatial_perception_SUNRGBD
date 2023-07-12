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
df_250 <- read.csv('250_neg_groundPlane_participantData_for_lme.csv')
df_250$subjID <- factor(df_250$subjID) 
df_250$duration <- factor(df_250$duration)
df_250$stimulus <- factor(df_250$stimulus) 

df_grouped_250 <- read.csv('250_neg_groundPlane_participantData_grouped_for_lme.csv')

df_1000 <- read.csv('1000_neg_groundPlane_participantData_for_lme.csv')
df_1000$subjID <- factor(df_1000$subjID) 
df_1000$duration <- factor(df_1000$duration)
df_1000$stimulus <- factor(df_1000$stimulus) 

df_grouped_1000 <- read.csv('1000_neg_groundPlane_participantData_grouped_for_lme.csv')

df <- rbind(df_250, df_1000)

df_grouped <- rbind(df_grouped_250, df_grouped_1000)

sort(unique(df$duration))

mod_main <- lmer(s_residual ~ groundPlane + duration + (1|subjID) + (1|actual_depth), data=df)
summary(mod_main)

anova(mod_main)
