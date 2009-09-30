\name{plot.klauer}
\Rdversion{1.1}
\alias{plot.klauer}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
plot.klauer(KT, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{KT}{
%%     ~~Describe \code{KT} here~~
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
function (KT, ...) 
{
    plot(KT@X, KT@Y, ...)
    abline(h = 0, col = "gray")
    abline(v = 0, col = "gray")
    segments(0, KT@intercept.est[2], max(KT@X), KT@intercept.est[2] + 
        KT@gen.parest[2, 5] * max(KT@X), col = "red")
    points(0, KT@intercept.est[2], col = "red", pch = 19)
    arrows(0, KT@intercept.est[1], 0, KT@intercept.est[3], angle = 90, 
        code = 3, col = "red", len = 0.15)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
