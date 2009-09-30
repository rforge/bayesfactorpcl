#This file is for R code which pertains to different distributions.

#ExGaussian Needed Here
dexg<-function(t,mu,sigma,tau)
{
temp1=(mu/tau)+((sigma*sigma)/(2*tau*tau))-(t/tau)
temp2=((t-mu)-(sigma*sigma/tau))/sigma
(exp(temp1)*pnorm(temp2))/tau
}

dexg.lss=function(t,loc,scale,shape) dexg(t,loc,scale,(shape*scale))


#Wald Needed Here

#Truncated Normal, truncated below at t1 and above at t2
rtruncnorm.pcl<-function(N,mu=0,sigma=1,t1,t2)
{
u=runif(N,pnorm(t1,mu,sigma),pnorm(t2,mu,sigma))
qnorm(u,mu,sigma)
}

dtruncnorm.pcl<-function(x,mu=0,sigma=1,t1,t2)
{
normalize=pnorm(t2,mu,sigma)-pnorm(t1,mu,sigma)
as.integer(x<t2 & x>t1)*dnorm(x,mu,sigma)/normalize
}

qtruncnorm.pcl<-function(p,mu=0,sigma=1,t1,t2)
{
p[p<0 | p>1]=NA
b=pnorm(t2,mu,sigma)
a=pnorm(t1,mu,sigma)
q=(b-a)*p+a
qnorm(q,mu,sigma)
}

ptruncnorm.pcl<-function(x,mu=0,sigma=1,t1,t2)
{
normalize=pnorm(t2,mu,sigma)-pnorm(t1,mu,sigma)
integrate=(pnorm(x,mu,sigma)-pnorm(t1,mu,sigma))/normalize
integrate[integrate>1]=1
integrate
}


