############ Nonlinear regression (for dataset DNase) ###########
attach(DNase)
th.start=c(theta1=3,theta2=0,theta3=1)
n=nrow(DNase);p=length(th.start)
plot(conc,density,xlab="Concentration",ylab="Optical density") # plot of dataset
form=as.formula(density~theta1/(1+exp((theta2-log(conc))/theta3)))
nmodel=nls(form,DNase,start=th.start) 
nmodel # contains the estimates of the parameter and RSS
hat.th=coef(nmodel); hat.th ## the LSE estimates of theta's  
summary(nmodel) # more informative output

# Finding initial values for dens.start
fn=function(theta=c(0,0,0),x1,x2,x3){
  y1=theta[1]/(1+exp((theta[2]-log(x1))/theta[3]))
  y2=theta[1]/(1+exp((theta[2]-log(x2))/theta[3]))
  y3=theta[1]/(1+exp((theta[2]-log(x3))/theta[3]))
  return(c(y1,y2,y3))}
# Take x1=0.05, x2=3.125, x3=12.5 for 3 values of the variable conc; 
# corresponding (approx.) values of variable density: y1=0.01, y2=1, y3=1.72
fn2=function(theta) crossprod(fn(theta,0.05,3.125,12.5)-c(0.01,1,1.72))
th0=optim(c(1,1,1),fn2)$par; th0 # the initial th.start
nmod2=nls(form,DNase,start=c(theta1=th0[1],theta2=th0[2],theta3=th0[3]));nmod2
###########################################

# residual sum of squares S(hat.th)=RSS=sum(residuals(nmodel)^2) # the same as
RSS=deviance(nmodel);RSS # the same as residual sum-of-squares in nmodel
hat.var=RSS/(n-p); hat.var # the estimate of the error variance 
se=sqrt(hat.var);se  # residual standard error, the same as in summary(nmodel)
# the estimates of the variances of theta's: diag(vcov(nmodel))
# sqrt(diag(vcov(nmodel))) # the same as Std.Error's in summary(nmodel) 

## nonlinear regression function
f=function(x,theta)return(theta[1]/(1+exp((theta[2]-log(x))/theta[3])))
coef(nmodel) # estimates for theta
x=seq(from=0.1,to=13,by=0.1)
lines(x,f(x,coef(nmodel)),col="red")  # fitted curve
# or: lines(x,predict(nmodel,newdata=data.frame(conc=x)),col="red")

# the estimated covariance matrix for hat.theta
cov.est=vcov(nmodel);cov.est

# CI's for coordinates of theta can be computed by R: confint(nmodel)
# (or confint(nmodel,level=0.95,method="asymptotic")) which gives different 
# intervals as compared with directly computed CI's below,
# possibly because the method in confint(nmodel) is based on F-statistics.
# Indeed, the CI's produced by confint(nmodel) are not symmetric around 
# coef(nmodel) and shifted to the right. We compute the CI's directly
lb=numeric(3); ub=numeric(3); # rownames(lb)=names(coef(nmodel))
for(i in 1:3) {lb[i]=coef(nmodel)[i]-qt(0.975,n-length(coef(nmodel)))*sqrt(cov.est[i,i])
ub[i]=coef(nmodel)[i]+qt(0.975,n-length(coef(nmodel)))*sqrt(cov.est[i,i])}
ci=cbind(lb,ub); rownames(ci)=names(coef(nmodel)); ci

for(i in 1:3) {lb[i]=coef(nmodel)[i]-qnorm(0.975)*sqrt(cov.est[i,i])
ub[i]=coef(nmodel)[i]+qnorm(0.975)*sqrt(cov.est[i,i])}
ci=cbind(lb,ub); rownames(ci)=names(coef(nmodel)); ci


## estimate of the mean response f(4,theta)
f4=f(4,coef(nmodel));f4  
## or f4=predict(nmodel,newdata=data.frame(conc=4))

## 90%-confidence interval for the mean response f(4,theta)
# first compute the gradient function (represented as column)

grad<-function(x,theta){rbind(1/(1+exp((theta[2]-log(x))/theta[3])),
                              -(theta[1]*exp((theta[2]-log(x))/theta[3])/theta[3])/(1+exp((theta[2]-log(x))/theta[3]))^2,
                              (theta[1]*exp((theta[2]-log(x))/theta[3])*(theta[2]-log(x))*(theta[3]^(-2))/(1+exp((theta[2]-log(x))/theta[3]))^2))}
gradvec=grad(4,coef(nmodel))

# this can also be done by using deriv() function as follows
df=deriv(y~th1/(1+exp((th2-log(x))/th3)),c("th1","th2","th3"),
         function(th1,th2,th3,x=4){}) 
# compute the gradient (as row) at x=4 and hat.th
vx=attr(df(hat.th[1],hat.th[2],hat.th[3]),"gradient") #gradvec==t(vx) #indeed, the same

se=sqrt(t(gradvec)%*%vcov(nmodel)%*%gradvec) #0.006986284
lb=f4-qt(0.95,n-length(coef(nmodel)))*se #1.156622
ub=f4+qt(0.95,n-length(coef(nmodel)))*se #1.179728
c(lb,ub) # approximate confidence interval for f(4,theta)


## estimates and 90%-confidence approximate intervals 
## the mean responses for many x's from (0,13]
x=seq(0.1,13,by=0.1)
# estimates for f(x,theta) for x from (0,13]
fe=f(x,coef(nmodel)) # or: fe=predict(nmodel,newdata=data.frame(conc=x))
mygrad=grad(x,coef(nmodel)) # estimated gradients for x's from (0,13]
se<-sqrt(apply(mygrad,2,function(xx) t(xx)%*%vcov(nmodel)%*%xx))
lb<-fe-qt(0.95,n-length(coef(nmodel)))*se 
ub<-fe+qt(0.95,n-length(coef(nmodel)))*se
# plot of confidence intervals for all c from (0,13]
plot(conc,density,xlab="Concentration",ylab="Optical density") # data
lines(x,fe,t="l",lwd=0.5,col="red") # fitted curve
segments(x,lb,x,ub,col="grey") # confidence intervals
# another plot of confidence intervals for all x from (0,13]
plot(conc,density,xlab="Concentration",ylab="Optical density") 
polygon(c(x,rev(x)),c(lb,rev(ub)),col="grey",border=NA)
lines(x,fe,lwd=0.5,col="red")

## Validity of model assumptions
# residuals against the fitted values
plot(fitted(nmodel),resid(nmodel));abline(h=0,lty=3) # not good
# qq-plot to check normality although normality is not required for nonlin models
qqnorm(resid(nmodel)); qqline(resid(nmodel),col="red") # not good  
hist(resid(nmodel))   # not good

# Comparing nested models
form2=as.formula(density~theta1/(1+exp((-log(conc))/theta3)))
nmodel2=nls(form2,DNase,start=c(theta1=3,theta3=1)) # reduced model omega with theta2=0
anova(nmodel2,nmodel) # conclusion: reduced model is not adequate
# Let us derive this also directly
RSSq=sum(resid(nmodel)^2); RSSq # RSS for the big model # also: deviance(nmodel)
RSSp=sum(resid(nmodel2)^2); RSSp # RSS for the small model
n=length(resid(nmodel)); q=length(coef(nmodel)); p=length(coef(nmodel2)) 
f=((RSSp-RSSq)/(q-p))/(RSSq/(n-q));f  # f-statistic, now p-value 
1-pf(f,q-p,n-q) # H0 is rejected, the small model is not good 
