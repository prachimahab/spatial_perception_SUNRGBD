# load LME package
library('lme4')
library(nlme)
library('lmerTest')
library('partR2') # https://cran.r-project.org/web/packages/partR2/vignettes/Using_partR2.html
library(AICcmodavg)
library(MuMIn)
library(multilevel) 
library('r2glmm')

# Load data
setwd("/Users/prachimahableshwarkar/Documents/GW/Depth_MTurk/spatial_perception_SUNRGBD/joint_analyses/cues/")
df <- read.csv('data_for_lme.csv')

# df$nSub <- as.numeric(factor(df$subjID,levels=unique(df$subjID)))
# df <- subset(df, select=-c(X,keyPress,pos1,pos2,pos3,pos4,stim1,stim2,stim3,stim4,acc,respPos,respStim,pair,bin,subjID, trialNum))
# df$match <- with(df, ifelse(dist == 1, '1', '0'))

# Create models 
# fixed effect only:
m_dur<- lm(residuals ~ duration, data=df)
summary(m_dur)

m_stim<- lm(residuals ~ stimulus, data=df)
summary(m_stim)

# m0
# fixed effect: clutter
# random effect: duration
m0 <- lmer(residuals ~ clutter + (1|duration), data=df)
summary(m0)


# m1
# fixed effect: clutter
# random effect: stimulus
m1 <- lmer(residuals ~ clutter + (1|stimulus), data=df)
summary(m1)

# m2
# fixed effect: clutter
# random effect: duration, stimulus
m2 <- lmer(residuals ~ clutter + (1|duration) + (1|stimulus), data=df)
summary(m2)

#m3
# fixed effect: groundPlane
# random effect: duration
m3 <- lmer(residuals ~ groundPlane + (1|duration), data=df)
summary(m3)

#m4
# fixed effect: groundPlane
# random effect: stimulus
m4 <- lmer(residuals ~ groundPlane + (1|stimulus), data=df)
summary(m4)

#m5
# fixed effect: groundPlane
# random effect: stimulus, duration
m5 <- lmer(residuals ~ groundPlane + (1|stimulus)+ (1|duration), data=df)
summary(m5)

#m6
# fixed effects: groundPlane & clutter
# random effect: duration
m6 <- lmer(residuals ~ groundPlane + clutter + (1|duration), data=df)
summary(m6)

#m7
# fixed effects: groundPlane & clutter
# random effect: stimulus
m7 <- lmer(residuals ~ groundPlane + clutter + (1|stimulus), data=df)
summary(m7)

#m8
# fixed effects: groundPlane & clutter
# random effect: duration, stimulus
m8 <- lmer(residuals ~ groundPlane + clutter + (1|stimulus) + (1|duration), data=df)
summary(m8)

#m9
# fixed effects: groundPlane, clutter
# random effect: duration
#interaction: groundPlane * clutter
m9 <- lmer(residuals ~ groundPlane + clutter + groundPlane*clutter + (1|duration), data=df)
summary(m9)

#m10
# fixed effects: groundPlane, clutter
# random effect: stimulus
#interaction: groundPlane * clutter
m10 <- lmer(residuals ~ groundPlane + clutter + groundPlane*clutter + (1|stimulus), data=df)
summary(m10)

#m11
# fixed effects: groundPlane, clutter
# random effect: duration, stimulus
#interaction: groundPlane * clutter
m11 <- lmer(residuals ~ groundPlane + clutter + groundPlane*clutter + (1|stimulus) + (1|duration), data=df)
summary(m11)


# model comparison
anova(m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11)

BIC(m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11)

# get variance
vc <- VarCorr(m4)
print(vc,comp=c("Variance","Std.Dev."),digits=2)

vc_fixed <- as.matrix(vcov(m4))
var_fixed <- diag(vc_fixed); var_fixed

#
r.squaredGLMM(m4)

#
aov.1 <- aov(RT ~ dist, data=df)
             
ICC1(aov.1)


# https://github.com/bcjaeger/r2glmm#r2glmm
r2 <- r2beta(m4, method = 'sgv', partial = T, data = df)
plot(x=r2)