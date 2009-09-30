\name{jointloglike.EXsig}
\Rdversion{1.1}
\alias{jointloglike.EXsig}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
jointloglike.EXsig(par, X, Y, EXsig)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{par}{
%%     ~~Describe \code{par} here~~
}
  \item{X}{
%%     ~~Describe \code{X} here~~
}
  \item{Y}{
%%     ~~Describe \code{Y} here~~
}
  \item{EXsig}{
%%     ~~Describe \code{EXsig} here~~
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
function (par, X, Y, EXsig) 
{
    mu = par[1]
    sig = exp(par[2])
    EYsig = exp(par[3])
    beta = par[4]
    alp = par[5]
    nu = (EYsig * sig)^2 + (beta * EXsig * sig)^2 + (EXsig * 
        EYsig)^2
    xi = 1/sqrt(nu) * (X * EYsig * sig/EXsig + beta * (Y - alp) * 
        EXsig * sig/EYsig + mu * EXsig * EYsig/sig)
    gamma = X^2/EXsig^2 + (Y - alp)^2/EYsig^2 + mu^2/sig^2
    lf = log(1/(2 * pi * sqrt(nu)) * exp(-0.5 * (gamma - xi^2)) * 
        (1 - pnorm(-xi)) + (2 * pi * EXsig * EYsig)^-1 * exp(-0.5 * 
        (gamma - (mu/sig)^2)) * pnorm(-mu/sig))
    -sum(lf)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
