
library(BayesFactor)

# one sample

t = -.29
n = 50
zz = rnorm(50)
zz = (zz - mean(zz))/sd(zz)
zz = zz + t / sqrt(n)

x1 = ttestBF(zz,nullInterval=c(0,Inf))
x2 = ttestBF(zz)

x3 = c(x1,x2)

x3
x3 / x3

plot(x3)

x2 = ttestBF(zz, mu = 1)
xx = posterior(x2, iterations = 1000)
plot(xx[,"mu"])

# paired

y1 = rnorm(10)
y2 = rnorm(10)

x1 = ttestBF(y1,y2,paired=TRUE,nullInterval = c(0,Inf))
x2 = ttestBF(y1,y2,paired=TRUE)

x3 = c(x1,x2)

##### Two sample

y1 = rnorm(1000)
y2 = rnorm(1000) + .1

x1 = ttestBF(y1,y2,nullInterval = c(0,Inf))
x2 = ttestBF(y1,y2)
x3 <- c(x1,x2)

t.test(y1,y2, var.eq=TRUE)

xx1 = posterior(x1[1], iterations = 1000)
dat = data.frame(y = c(y1,y2), grp = factor(c(rep(1,10),rep(2,10))))
xx2 = lmBF(y ~ grp, data = dat, posterior = TRUE, iterations = 1000)

##### Two sample, formula interface

y1 = rnorm(10)
y2 = rnorm(10)+.5
data = data.frame(dv = c(y1,y2),grp = c(rep("1",10),rep("2",10)))

x1a = ttestBF(formula = dv ~ grp,data=data, nullInterval = c(0,Inf))
x2a = ttestBF(formula = dv ~ grp, data = data)
x3a <- c(x1a,x2a)

x1 = ttestBF(y1,y2,nullInterval = c(0,Inf))
x2 = ttestBF(y1,y2)
x3 <- c(x1,x2)

###########
# Linear model
###########

lmBF(extra ~ group,data = sleep, whichRandom="ID")
ttestBF(formula=extra ~ group, data = sleep)

x1 = replicate(10,{
lmBF(extra ~ group + ID,data = sleep, whichRandom = "ID", iterations=1000)
}, FALSE)
x1 = do.call("c",x1)
x2 = lmBF(extra ~ ID,data = sleep, whichRandom="ID")


x3 = x1/x2
plot(x3)

anovaBF(extra ~ group + ID, data = sleep, whichRandom = "ID")


#########
# regression
N = 20
a = rnorm(N)
b = a + rnorm(N,0,.5)
y = a + rnorm(N,0,.3) + 10
data = data.frame(a=a,b=b,y=y)

x1 = lmBF(y ~ a + b,data = data)
x2 = lmBF(y ~ a,data = data)
x3 = lmBF(y ~ b, data = data)

x4 = c(x1,x2,x3)

x5 = regressionBF(formula = y ~ a+b,data = data)

plot(x5[1:2]/x5[3])

xx = posterior(x1, iterations = 1000)
colMeans(xx)
apply(xx,2,sd)

##############

data(puzzles)
x1 = anovaBF(RT ~ shape*color + ID, data = puzzles,whichRandom="ID",whichModels="withmain")

zz = posterior(x1[1],iterations = 1000)

####

# try all random
data(puzzles)
x1 = lmBF(RT ~ shape:color + ID, data = puzzles,whichRandom=c("shape","color","ID"))
z1 = posterior(x1, iterations = 100000)

x1 = lmBF(RT ~ shape*color + ID, data = puzzles,whichRandom=c("ID"))
x2 = lmBF(RT ~ ID, data = puzzles,whichRandom=c("ID"))
x1/x2

colMeans(z1[,14:17] + z1[,1])
tapply(puzzles$RT,list(puzzles$shape,puzzles$color),mean)
