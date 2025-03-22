##################################################################
# When does the order of the factors in anova/ancova model matter?  
##################################################################
# y=rnorm(16) # some fictive response variable
# f1=factor(rep(c(1,1,1,1,2,2,2,2),2)) 
# f2=factor(rep(c(1,2,3,4),4)) # balanced design: 2 obs. per cell

y=rnorm(8) # some fictive response variable
f1=factor(c(1,1,1,1,2,2,2,2)) # factor f1 
f2=factor(c(1,2,3,4,1,2,3,4)) # factor f2, 1 obs per cell
mod1=lm(y~f1+f2)
mod2=lm(y~f2+f1)
anova(mod1) # balanced design for anova
anova(mod2) # order of factors doesn't matter

## unbalanced design in anova
#f1=factor(c(1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2))  # or f1=sample(f1)
#f2a=factor(c(1,1,1,1,1,2,3,4,1,2,3,4,1,2,3,4))  # or f2=sample(f2)

f1=factor(c(1,1,1,1,2,2,2,2)) # the same factor f1 
f2a=factor(c(1,2,3,1,2,3,1,2)) # new factor f2, leading to unbalanced design
mod3=lm(y~f1+f2a) # here the same MeanSq for f1 as in anova(lm(y~f1)) 
mod4=lm(y~f2a+f1) # unbalanced additive anova
anova(mod3) # the p-value for f2a (second factor in the formula) is correct
anova(mod4) # the p-value for f1 (second factor in the formula) is correct
## we see that the order of factors in unbalance anova matters
# for mod3: the first line f1 is test omega1(f1) within Omega(f1+f2) 
# the second line f2a is the test omega2(f2\f1) within Omega(f1+f2)
# the second line f2a is the right test for f2, with f1 taken into account 
# (in some sense purified (from f1) contribution of f2 to model f1+f2)
# for unbalanced designs omega2(f2\f1) is not the same as omega2(f2)
# the best way to perform the test for f2 is 
modf1=lm(y~f1); anova(modf1,mod3) # or anova(modf1,mod4) 

# consider balanced design in ancova
x3=rnorm(8,0.2,0.8). #x3=rnorm(16,0.2,0.8)
mod1a=lm(y~f1+f2+x3)
mod2a=lm(y~x3+f1+f2)
anova(mod1a) # although the design is balanced
anova(mod2a) # the order of factors always matters in ancova 

# the same relevant p-values can be derived by testing submodels within 
# the full model. The relevant p-value for x3  
mod1b=lm(y~f1+f2) # submodel (without x3) of the model mod1a=lm(y~f1+f2+x3)
anova(mod1b,mod1a) # relevant p-value for x3, anova(mod1b,mod2a) gives the same
# the relevant p-value for f2  
mod2b=lm(y~f1+x3) # create submodel without f2 inside mod2a=lm(y~x3+f1+f2)
anova(mod2b,mod2a) # relevant p-value for f2, anova(mod2b,mod1a) gives the same
# to get all relevant p-values at once (for each variable removed), just run 
drop1(mod1a,test="F") # this works for all the models anova, ancova



## Conclusions:
## order of factors does not matter in anova with balanced design
## order of factors in anova matters when design is unbalanced
## order of factors in ancova matters 
## anova(submod2,mod1) # to test whether submodel2 is as good as mod1 
## drop1(mod,test="F") # gives correct p-values for all variables in mod
