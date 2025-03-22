######## step-up and step-down methods for mtcars #######
mtcars
names(mtcars)
cor(mtcars) # mpg is correletaed with wt (0.87),cyl (0.85), disp(0.85) and hp(0.78)
attach(mtcars)

#vs=as.factor(vs) # can be done but not needed as there are only values 0 and 1
#am=as.factor(am) # can be done but not needed as there are only values 0 and 1

#### Step up method for mtcars##########
summary(lm(mpg~cyl))
summary(lm(mpg~disp))
summary(lm(mpg~hp))
summary(lm(mpg~drat))
summary(lm(mpg~wt))  #the biggest R2=0.75 (and p-value is small)
summary(lm(mpg~qsec)) 
summary(lm(mpg~vs))
summary(lm(mpg~am))
summary(lm(mpg~gear))
summary(lm(mpg~carb))

summary(lm(mpg~wt+cyl)) #the biggest R2=0.83 (and p-value is small)
summary(lm(mpg~wt+disp))
summary(lm(mpg~wt+hp))
summary(lm(mpg~wt+drat))
summary(lm(mpg~wt+qsec))
summary(lm(mpg~wt+vs))
summary(lm(mpg~wt+am))
summary(lm(mpg~wt+gear))
summary(lm(mpg~wt+carb))

summary(lm(mpg~wt+cyl+disp))
summary(lm(mpg~wt+cyl+hp))
summary(lm(mpg~wt+cyl+drat))
summary(lm(mpg~wt+cyl+qsec))
summary(lm(mpg~wt+cyl+vs))
summary(lm(mpg~wt+cyl+am))
summary(lm(mpg~wt+cyl+gear))
summary(lm(mpg~wt+cyl+carb))
## none of these 3 are all significant  
## so the final model is mpg=39.7-3.2wt - 1.5cyl
mod.up=lm(mpg~wt+cyl)

#### Step down method for mtcars ########
summary(lm(mpg~cyl+disp+hp+drat+wt+qsec+vs+am+gear+carb)) #remove cyl
summary(lm(mpg~disp+hp+drat+wt+qsec+vs+am+gear+carb)) #remove vs
summary(lm(mpg~disp+hp+drat+wt+qsec+am+gear+carb)) #remove carb
summary(lm(mpg~disp+hp+drat+wt+qsec+am+gear)) #remove gear
summary(lm(mpg~disp+hp+drat+wt+qsec+am)) #remove drat
summary(lm(mpg~disp+hp+wt+qsec+am)) #remove disp
summary(lm(mpg~hp+wt+qsec+am)) #remove hp
summary(lm(mpg~wt+qsec+am)) # nothing more to remove
## so the final model is mpg=9.6-3.9wt+1.2qsec+2.9am
mod.down=lm(mpg~wt+qsec+am)


################### Lasso for the data set mtcars ################
##################################################################

library(glmnet)
mtcars # dataset mtcars: mpg is the response
x=as.matrix(mtcars[,-1])
y=mtcars[,1]

train=sample(1:nrow(x),0.67*nrow(x)) # train by using 2/3 of the x rows 
x.train=x[train,]; y.train=y[train]  # data to train
x.test=x[-train,]; y.test = y[-train] # data to test the prediction quality

# Prediction by using the linear model
# first fit linear model on the train data
lm.model=lm(mpg~cyl+disp+hp+drat+wt+qsec+vs+am+gear+carb,data=mtcars,subset=train)
y.predict.lm=predict(lm.model,newdata=mtcars[-train,]) # predict for the test rows
mse.lm=mean((y.test-y.predict.lm)^2); mse.lm # prediction quality by the linear model

# Now apply lasso method for selecting the variables and prediction 
library(glmnet) 
lasso.model=glmnet(x.train,y.train,alpha=1) # alpha=1 for lasso
# more options: standardize=TRUE, intercept=FALSE,nlambda=1000
# plots
plot(lasso.model,label=T,xvar="lambda") #standardize=T,type.coef="2norm",xvar="norm") "coef"
# label="T" in plot commando is supposed to indicate which curve corresponds 
# to which coefficients. but unfortunately, it is not clearly labelled. 
# The glmnet plot shows the shrinkage of the lasso coefficients as you move from 
# the right to the left. Lasso contrasts with ridge regression, which flattens 
# out everything, but does not zero out any of the regression coefficients.

## use cross validation to derive the best lambda 
lasso.cv=cv.glmnet(x.train,y.train,alpha=1,type.measure="mse",nfolds=5)
# option nfolds=5 means 5-fold cross validation. By default, the method 
# performs 10-fold cross validation to choose the best lambda.
plot(lasso.cv) 
lambda.min=lasso.cv$lambda.min; lambda.1se=lasso.cv$lambda.1se; 
lambda.min; lambda.1se # best lambda by cross validation
coef(lasso.model,s=lasso.cv$lambda.min) # cyl,hp,wt,am and carb are relevant
coef(lasso.model,s=lasso.cv$lambda.1se) # only cyl,hp and wt are releveant

# lambda.min is the value of lambda that gives minimum mean cross-validated 
# error. The other lambda saved is lambda.1se, which gives the most regularized 
# model such that error is within one standard error of the minimum. 

lasso.pred1=predict(lasso.model,s=lambda.min,newx=x.test) 
lasso.pred2=predict(lasso.model,s=lambda.1se,newx=as.matrix(x.test))
mse1.lasso=mean((y.test-lasso.pred1)^2); mse1.lasso
mse2.lasso=mean((y.test-lasso.pred2)^2); mse2.lasso

# By default, the glmnet function standardizes all the independent 
# variables, but here the dependent variable can also be standardized 
# by the function standardize=function(x){(x-mean(x))/sd(x)}).
# Then one may want not to include an intercept in lm and glmnet models, 
# because all the variables have already been standardized to a mean of zero. 
############## end of the example mtcars #############################

