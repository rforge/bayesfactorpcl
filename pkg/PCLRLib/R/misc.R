#This file is for R functions which do not fit into other categories.


removeNA<-function(y)
replace(y,is.na(y),0)

#Next three functions are support functions for computing Shannon information.
plog2p<-function(p) ifelse(p<=0|is.na(p),0,p*log2(p))

SITinfResp<-function(m) -sum(plog2p(colSums(as.matrix(m),na.rm=T)/sum(colSums(as.matrix(m),na.rm=T))))

SITequivResp<-function(m) -sum((rowSums(as.matrix(m),na.rm=T)/sum(rowSums(as.matrix(m),na.rm=T)))*(plog2p(t(t(as.matrix(m))/rowSums(as.matrix(m),na.rm=T)))))

#compute the Shannon information in bits in aconfusion matrix m
SITtotal<-function(m) SITinfResp(m)-SITequivResp(m)


thinplot=function(x,y,prop=.50,to=NULL){
x=make.1d(x)
y=make.1d(y)
if(!is.null(to)){ 
s=c(rep(1,to),rep(0,length(x)-to))
}else{
s=c(rep(1,length(x)*prop),rep(0,length(x)*(1-prop)))
}
sample(s,length(s))
ret=list(x=x[as.logical(s)],y=y[as.logical(s)])
ret
}

make.1d=function(m){
m=as.matrix(m)
dim(m)=c(1,prod(dim(m)))
m
}



klauer.test=function(X,Y,rel.start=5,CIconf=.95,EXsig=NULL,...){
ow=options("warn")
options(warn=-1)

N=length(Y)

output=new("Klauer.test")
output@X=X
output@Y=Y
output@rel.start=rel.start
output@CIconf=CIconf

start.alp=lm(Y~X)[[1]][1]
start.beta=lm(Y~X)[[1]][2]
start.mu=mean(X)
start.sig=sd(X)
start.EYsig=sd(Y)/rel.start

if(is.null(EXsig)){
output@EXsig=-1
start.EXsig=sd(X)/rel.start
par=c(start.mu,log(start.sig),log(start.EXsig),log(start.EYsig),start.beta,start.alp)
res.par=c(start.mu,log(start.sig),log(start.EXsig),log(start.EYsig),start.beta)

output@starting.values=par

g=nlm(jointloglike,par,X=X,Y=Y,hessian=T,...)
g.res=nlm(res.jointloglike,res.par,X=X,Y=Y,hessian=T,...)

output@code.gen=g$code
output@code.res=g.res$code

output@BICgen=2*g$minimum + 6*log(N)
output@BICres=2*g.res$minimum + 5*log(N)

output@loglike.gen=-g$minimum
output@loglike.res=-g.res$minimum

output@X2=2*(g.res$minimum-g$minimum)
output@p.val=1-pchisq(output@X2,1)


est.mu=g$estimate[1]
est.sig=exp(g$estimate[2])
est.EXsig=exp(g$estimate[3])
est.EYsig=exp(g$estimate[4])
est.beta = g$estimate[5]
est.alp=g$estimate[6]

estpars=c(est.mu,g$estimate[2],g$estimate[3],g$estimate[4],est.beta,est.alp)

output@CIsize=sqrt(1/diag(g$hessian))*-qnorm(.5*(1-CIconf))

est.up=estpars+output@CIsize
est.lo=estpars-output@CIsize


estpars[2:4]=exp(estpars[2:4])
est.up[2:4]=exp(est.up[2:4])
est.lo[2:4]=exp(est.lo[2:4])

parmat=rbind(est.up,estpars,est.lo)

labs=c("muTX","sigmaTX","sigEX","sigEY","slope","intercept")
dimnames(parmat)[[2]]=labs
dimnames(parmat)[[1]]=c("Upper CI Limit","Estimate","Lower CI Limit")


output@gen.parest=parmat
output@intercept.est=parmat[,6]

}else{
output@EXsig=EXsig
par=c(start.mu,log(start.sig),log(start.EYsig),start.beta,start.alp)
res.par=c(start.mu,log(start.sig),log(start.EYsig),start.beta)

output@starting.values=par

g=nlm(jointloglike.EXsig,par,X=X,Y=Y,EXsig=EXsig,hessian=T,...)
g.res=nlm(res.jointloglike.EXsig,res.par,X=X,Y=Y,EXsig=EXsig,hessian=T,...)

output@code.gen=g$code
output@code.res=g.res$code

output@BICgen=2*g$minimum + 5*log(N)
output@BICres=2*g.res$minimum + 4*log(N)

output@loglike.gen=-g$minimum
output@loglike.res=-g.res$minimum

output@X2=2*(g.res$minimum-g$minimum)
output@p.val=1-pchisq(output@X2,1)


est.mu=g$estimate[1]
est.sig=exp(g$estimate[2])
est.EYsig=exp(g$estimate[3])
est.beta = g$estimate[4]
est.alp=g$estimate[5]

estpars=c(est.mu,g$estimate[2],g$estimate[3],est.beta,est.alp)

output@CIsize=sqrt(1/diag(g$hessian))*-qnorm(.5*(1-CIconf))

est.up=estpars+output@CIsize
est.lo=estpars-output@CIsize


estpars[2:3]=exp(estpars[2:3])
est.up[2:3]=exp(est.up[2:3])
est.lo[2:3]=exp(est.lo[2:3])

parmat=rbind(est.up,estpars,est.lo)

labs=c("muTX","sigmaTX","sigEY","slope","intercept")
dimnames(parmat)[[2]]=labs
dimnames(parmat)[[1]]=c("Upper CI Limit","Estimate","Lower CI Limit")


output@gen.parest=parmat
output@intercept.est=parmat[,5]

}

options(ow)

output
}

jointloglike=function(par,X,Y){
mu    = par[1]
sig   = exp(par[2])
EXsig = exp(par[3])
EYsig = exp(par[4])
beta  = par[5]
alp   = par[6]
nu = (EYsig*sig)^2 + (beta*EXsig*sig)^2 + (EXsig*EYsig)^2
xi = 1/sqrt(nu)*(X*EYsig*sig/EXsig + beta*(Y-alp)*EXsig*sig/EYsig + mu*EXsig*EYsig/sig)
gamma = X^2/EXsig^2 + (Y-alp)^2/EYsig^2 + mu^2/sig^2
lf = log(1/(2*pi*sqrt(nu))*exp(-.5*(gamma-xi^2))*(1-pnorm(-xi)) 
    + (2*pi*EXsig*EYsig)^-1*exp(-.5*(gamma-(mu/sig)^2))*pnorm(-mu/sig))
-sum(lf)
}


res.jointloglike=function(par,X,Y){
mu    = par[1]
sig   = exp(par[2])
EXsig = exp(par[3])
EYsig = exp(par[4])
beta  = par[5]
alp   = 0
nu = (EYsig*sig)^2 + (beta*EXsig*sig)^2 + (EXsig*EYsig)^2
xi = 1/sqrt(nu)*(X*EYsig*sig/EXsig + beta*(Y-alp)*EXsig*sig/EYsig + mu*EXsig*EYsig/sig)
gamma = X^2/EXsig^2 + (Y-alp)^2/EYsig^2 + mu^2/sig^2
lf = log(1/(2*pi*sqrt(nu))*exp(-.5*(gamma-xi^2))*(1-pnorm(-xi)) 
    + (2*pi*EXsig*EYsig)^-1*exp(-.5*(gamma-(mu/sig)^2))*pnorm(-mu/sig))
-sum(lf)
}


jointloglike.EXsig=function(par,X,Y,EXsig){
mu    = par[1]
sig   = exp(par[2])
EYsig = exp(par[3])
beta  = par[4]
alp   = par[5]
nu = (EYsig*sig)^2 + (beta*EXsig*sig)^2 + (EXsig*EYsig)^2
xi = 1/sqrt(nu)*(X*EYsig*sig/EXsig + beta*(Y-alp)*EXsig*sig/EYsig + mu*EXsig*EYsig/sig)
gamma = X^2/EXsig^2 + (Y-alp)^2/EYsig^2 + mu^2/sig^2
lf = log(1/(2*pi*sqrt(nu))*exp(-.5*(gamma-xi^2))*(1-pnorm(-xi)) 
    + (2*pi*EXsig*EYsig)^-1*exp(-.5*(gamma-(mu/sig)^2))*pnorm(-mu/sig))
-sum(lf)
}


res.jointloglike.EXsig=function(par,X,Y,EXsig){
mu    = par[1]
sig   = exp(par[2])
EYsig = exp(par[3])
beta  = par[4]
alp   = 0
nu = (EYsig*sig)^2 + (beta*EXsig*sig)^2 + (EXsig*EYsig)^2
xi = 1/sqrt(nu)*(X*EYsig*sig/EXsig + beta*(Y-alp)*EXsig*sig/EYsig + mu*EXsig*EYsig/sig)
gamma = X^2/EXsig^2 + (Y-alp)^2/EYsig^2 + mu^2/sig^2
lf = log(1/(2*pi*sqrt(nu))*exp(-.5*(gamma-xi^2))*(1-pnorm(-xi)) 
    + (2*pi*EXsig*EYsig)^-1*exp(-.5*(gamma-(mu/sig)^2))*pnorm(-mu/sig))
-sum(lf)
}

hybridMCsamp=function(startPars,Ex,dEx,eps,Lsteps=100,sig=1,...)
{
	N=length(startPars)

	e=Ex(startPars,...)
	g=dEx(startPars,...)

	m=rnorm(N,0,sig)
	H=sum(m^2/(2*sig^2)) + e

	tempg=g
	tempx=startPars
	
	for(l in 1:Lsteps){
		m=m-.5*eps*tempg
		tempx=tempx+eps*m
		tempg=dEx(tempx,...)
		m=m-.5*eps*tempg
	}
	
	tempe=Ex(tempx,...)
	tempH=sum(m^2/(2*sig^2)) + tempe
	
	if(-log(runif(1))>(tempH-H)){
		returnx=tempx
	}else{
		returnx=startPars
	}
returnx
}



