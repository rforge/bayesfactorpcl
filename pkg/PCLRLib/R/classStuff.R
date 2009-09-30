



setClass("Klauer.test",
	representation(
			X="numeric",
			Y="numeric",
			intercept.est="numeric",
			BICgen="numeric",
			BICres="numeric",
			X2="numeric",
			p.val="numeric",
			loglike.gen="numeric",
			loglike.res="numeric",
			gen.parest="matrix",
			CIconf="numeric",
			starting.values="numeric",
			CIsize="numeric",
			rel.start="numeric",
			code.gen="numeric",
			code.res="numeric",
			EXsig="numeric"
	),
contains="list")


KlauerShow=function(object){
BICstring=ifelse(object@BICgen<object@BICres,"*BIC favors nonzero intercept*\n","*BIC favors null intercept*\n")
genCode=ifelse((object@code.gen %in% c(1,2)),"",paste("*Warning: General model failed to converge. NLM Code:",object@code.gen,"*\n",sep=""))
resCode=ifelse((object@code.res %in% c(1,2)),"",paste("*Warning: Restricted model failed to converge. NLM Code:",object@code.res,"*\n",sep=""))
EXsigstr=ifelse(object@EXsig[1]==-1,"","EXsig was given.\n")
display=paste(
			"Klauer Errors-in-Variables test\n",
			"-------------------------------\n",
			"Intercept Estimate           : ",zapsmall(object@intercept.est[2])," (",100*object@CIconf,"% CI: ",zapsmall(object@intercept.est[3]),",",zapsmall(object@intercept.est[1]),")\n",
			"Chi-square(1) test statistic : ",zapsmall(object@X2)," (p=",zapsmall(object@p.val),")\n",
			"Nonzero Intercept BIC        : ",zapsmall(object@BICgen),"\n",
			"Null intercept BIC           : ",zapsmall(object@BICres),"\n",
			BICstring,genCode,resCode,EXsigstr,
		
		"\n\n",sep="")
cat(noquote(display))

}

plot.klauer=function(KT,...){
plot(KT@X,KT@Y,...)
abline(h=0,col="gray")
abline(v=0,col="gray")
segments(0,KT@intercept.est[2],max(KT@X),KT@intercept.est[2]+KT@gen.parest[2,5]*max(KT@X),col="red")
points(0,KT@intercept.est[2],col="red",pch=19)
arrows(0,KT@intercept.est[1],0,KT@intercept.est[3],angle=90,code=3,col="red",len=.15)
}

setMethod("show", "Klauer.test", KlauerShow)


setMethod("plot", signature(x = "Klauer.test", y = "missing"),
	function(x,...){
		plot(slot(x,"X"),slot(x,"Y"),...)
		slopenum=ifelse(slot(x,"EXsig")[1]==-1,5,4)
		abline(h=0,col="gray")
		abline(v=0,col="gray")
		segments(0,slot(x,"intercept.est")[2],max(slot(x,"X")),slot(x,"intercept.est")[2]+slot(x,"gen.parest")[2,slopenum]*max(slot(x,"X")),col="red")
		points(0,slot(x,"intercept.est")[2],col="red",pch=19)
		arrows(0,slot(x,"intercept.est")[1],0,slot(x,"intercept.est")[3],angle=90,code=3,col="red",len=.15)
	}
)


