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

df_pos <- read.csv('125_pos_groundPlane_participantData_for_lme.csv')
df_pos$subjID <- factor(df_pos$subjID) 
df_pos$duration <- factor(df_pos$duration)
df_pos$stimulus <- factor(df_pos$stimulus) 
df_pos_grouped <- read.csv('125_pos_groundPlane_participantData_grouped_for_lme.csv')

df_neg <- read.csv('125_neg_groundPlane_participantData_for_lme.csv')
df_neg$subjID <- factor(df_neg$subjID) 
df_neg$duration <- factor(df_neg$duration)
df_neg$stimulus <- factor(df_neg$stimulus) 
df_neg_grouped <- read.csv('125_neg_groundPlane_participantData_grouped_for_lme.csv')

sort(unique(df_pos$duration))

# mod_pos <- lmer(pos_s_residual ~ groundPlane + (1|subjID) + (1|actual_depth), data=df_pos)
# summary(mod_pos)
# 
# mod_neg <- lmer(neg_s_residual ~ groundPlane + (1|subjID) + (1|actual_depth), data=df_neg)
# summary(mod_neg)


mod_pos <- lmer(pos_s_residual ~ groundPlane + (1|actual_depth), data=df_pos)
summary(mod_pos)

mod_neg <- lmer(neg_s_residual ~ groundPlane + (1|actual_depth), data=df_neg)
summary(mod_neg)


sjPlot::plot_model(mod_pos,
                   show.values=TRUE, show.p=TRUE, 
                   title="")
sjPlot:: tab_model(mod_pos)

anova(mod_pos)

sjPlot::plot_model(mod_neg,
                   show.values=TRUE, show.p=TRUE, 
                   title="")
sjPlot:: tab_model(mod_neg)

anova(mod_neg)

gp_effects_pos <- effects::effect(term= "groundPlane", mod= mod_pos)
summary(gp_effects_pos) #output of what the values are

# Save the effects values as a df:
gp_effects_pos_df <- as.data.frame(gp_effects_pos)

gp_effects_neg <- effects::effect(term= "groundPlane", mod= mod_neg)
summary(gp_effects_neg) #output of what the values are

# Save the effects values as a df:
gp_effects_neg_df <- as.data.frame(gp_effects_neg)

#1
groundPlane_plot <- ggplot() + 
  theme_minimal() +  # Removes background and grid
  theme(
    panel.grid = element_blank(),  # Removes grid lines
    panel.background = element_blank(),  # Removes background
    axis.text = element_text(size = 12),  # Increase axis tick label font size
    axis.title = element_text(size = 14),  # Increase axis label font size
    axis.line = element_line(color = "black")  # Sets the color of axis spines
  ) +
  
  #2
  geom_point(data = subset(df_pos_grouped), aes(groundPlane, pos_s_residual)) + 
  #3
  geom_point(data = gp_effects_pos_df, aes(x = groundPlane, y = fit), color = "darkgreen") +
  #4
  geom_line(data = gp_effects_pos_df, aes(x = groundPlane, y = fit), color = "darkgreen") +
  #5
  geom_ribbon(data = gp_effects_pos_df, aes(x = groundPlane, ymin = lower, ymax = upper), alpha = 0.3, fill = "darkgreen") +
  
  #2
  geom_point(data = subset(df_neg_grouped), aes(groundPlane, neg_s_residual)) + 
  #3
  geom_point(data = gp_effects_neg_df, aes(x = groundPlane, y = fit), color = "darkgreen") +
  #4
  geom_line(data = gp_effects_neg_df, aes(x = groundPlane, y = fit), color = "darkgreen") +
  #5
  geom_ribbon(data = gp_effects_neg_df, aes(x = groundPlane, ymin = lower, ymax = upper), alpha = 0.3, fill = "darkgreen") +
  
  #6
  labs(x = "Complete Ground Plane", y = "Residuals") 
#7
# scale_y_continuous(limits = c(0.35, 1.1))

# Display the plot
print(groundPlane_plot)

