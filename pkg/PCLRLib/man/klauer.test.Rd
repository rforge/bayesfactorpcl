\name{klauer.test}
\Rdversion{1.1}
\alias{klauer.test}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
klauer.test(X, Y, rel.start = 5, CIconf = 0.95, EXsig = NULL, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{X}{
%%     ~~Describe \code{X} here~~
}
  \item{Y}{
%%     ~~Describe \code{Y} here~~
}
  \item{rel.start}{
%%     ~~Describe \code{rel.start} here~~
}
  \item{CIconf}{
%%     ~~Describe \code{CIconf} here~~
}
  \item{EXsig}{
%%     ~~Describe \code{EXsig} here~~
}
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (X, Y, rel.start = 5, CIconf = 0.95, EXsig = NULL, ...) 
{
    ow = options("warn")
    options(warn = -1)
    N = length(Y)
    output = new("Klauer.test")
    output@X = X
    output@Y = Y
    output@rel.start = rel.start
    output@CIconf = CIconf
    start.alp = lm(Y ~ X)[[1]][1]
    start.beta = lm(Y ~ X)[[1]][2]
    start.mu = mean(X)
    start.sig = sd(X)
    start.EYsig = sd(Y)/rel.start
    if (is.null(EXsig)) {
        output@EXsig = -1
        start.EXsig = sd(X)/rel.start
        par = c(start.mu, log(start.sig), log(start.EXsig), log(start.EYsig), 
            start.beta, start.alp)
        res.par = c(start.mu, log(start.sig), log(start.EXsig), 
            log(start.EYsig), start.beta)
        output@starting.values = par
        g = nlm(jointloglike, par, X = X, Y = Y, hessian = T, 
            ...)
        g.res = nlm(res.jointloglike, res.par, X = X, Y = Y, 
            hessian = T, ...)
        output@code.gen = g$code
        output@code.res = g.res$code
        output@BICgen = 2 * g$minimum + 6 * log(N)
        output@BICres = 2 * g.res$minimum + 5 * log(N)
        output@loglike.gen = -g$minimum
        output@loglike.res = -g.res$minimum
        output@X2 = 2 * (g.res$minimum - g$minimum)
        output@p.val = 1 - pchisq(output@X2, 1)
        est.mu = g$estimate[1]
        est.sig = exp(g$estimate[2])
        est.EXsig = exp(g$estimate[3])
        est.EYsig = exp(g$estimate[4])
        est.beta = g$estimate[5]
        est.alp = g$estimate[6]
        estpars = c(est.mu, g$estimate[2], g$estimate[3], g$estimate[4], 
            est.beta, est.alp)
        output@CIsize = sqrt(1/diag(g$hessian)) * -qnorm(0.5 * 
            (1 - CIconf))
        est.up = estpars + output@CIsize
        est.lo = estpars - output@CIsize
        estpars[2:4] = exp(estpars[2:4])
        est.up[2:4] = exp(est.up[2:4])
        est.lo[2:4] = exp(est.lo[2:4])
        parmat = rbind(est.up, estpars, est.lo)
        labs = c("muTX", "sigmaTX", "sigEX", "sigEY", "slope", 
            "intercept")
        dimnames(parmat)[[2]] = labs
        dimnames(parmat)[[1]] = c("Upper CI Limit", "Estimate", 
            "Lower CI Limit")
        output@gen.parest = parmat
        output@intercept.est = parmat[, 6]
    }
    else {
        output@EXsig = EXsig
        par = c(start.mu, log(start.sig), log(start.EYsig), start.beta, 
            start.alp)
        res.par = c(start.mu, log(start.sig), log(start.EYsig), 
            start.beta)
        output@starting.values = par
        g = nlm(jointloglike.EXsig, par, X = X, Y = Y, EXsig = EXsig, 
            hessian = T, ...)
        g.res = nlm(res.jointloglike.EXsig, res.par, X = X, Y = Y, 
            EXsig = EXsig, hessian = T, ...)
        output@code.gen = g$code
        output@code.res = g.res$code
        output@BICgen = 2 * g$minimum + 5 * log(N)
        output@BICres = 2 * g.res$minimum + 4 * log(N)
        output@loglike.gen = -g$minimum
        output@loglike.res = -g.res$minimum
        output@X2 = 2 * (g.res$minimum - g$minimum)
        output@p.val = 1 - pchisq(output@X2, 1)
        est.mu = g$estimate[1]
        est.sig = exp(g$estimate[2])
        est.EYsig = exp(g$estimate[3])
        est.beta = g$estimate[4]
        est.alp = g$estimate[5]
        estpars = c(est.mu, g$estimate[2], g$estimate[3], est.beta, 
            est.alp)
        output@CIsize = sqrt(1/diag(g$hessian)) * -qnorm(0.5 * 
            (1 - CIconf))
        est.up = estpars + output@CIsize
        est.lo = estpars - output@CIsize
        estpars[2:3] = exp(estpars[2:3])
        est.up[2:3] = exp(est.up[2:3])
        est.lo[2:3] = exp(est.lo[2:3])
        parmat = rbind(est.up, estpars, est.lo)
        labs = c("muTX", "sigmaTX", "sigEY", "slope", "intercept")
        dimnames(parmat)[[2]] = labs
        dimnames(parmat)[[1]] = c("Upper CI Limit", "Estimate", 
            "Lower CI Limit")
        output@gen.parest = parmat
        output@intercept.est = parmat[, 5]
    }
    options(ow)
    output
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
