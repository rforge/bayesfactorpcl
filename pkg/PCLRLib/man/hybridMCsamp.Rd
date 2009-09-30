\name{hybridMCsamp}
\Rdversion{1.1}
\alias{hybridMCsamp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
hybridMCsamp(startPars, Ex, dEx, eps, Lsteps = 100, sig = 1, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{startPars}{
%%     ~~Describe \code{startPars} here~~
}
  \item{Ex}{
%%     ~~Describe \code{Ex} here~~
}
  \item{dEx}{
%%     ~~Describe \code{dEx} here~~
}
  \item{eps}{
%%     ~~Describe \code{eps} here~~
}
  \item{Lsteps}{
%%     ~~Describe \code{Lsteps} here~~
}
  \item{sig}{
%%     ~~Describe \code{sig} here~~
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
function (startPars, Ex, dEx, eps, Lsteps = 100, sig = 1, ...) 
{
    N = length(startPars)
    e = Ex(startPars, ...)
    g = dEx(startPars, ...)
    m = rnorm(N, 0, sig)
    H = sum(m^2/(2 * sig^2)) + e
    tempg = g
    tempx = startPars
    for (l in 1:Lsteps) {
        m = m - 0.5 * eps * tempg
        tempx = tempx + eps * m
        tempg = dEx(tempx, ...)
        m = m - 0.5 * eps * tempg
    }
    tempe = Ex(tempx, ...)
    tempH = sum(m^2/(2 * sig^2)) + tempe
    if (-log(runif(1)) > (tempH - H)) {
        returnx = tempx
    }
    else {
        returnx = startPars
    }
    returnx
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
