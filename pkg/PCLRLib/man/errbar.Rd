\name{errbar}
\Rdversion{1.1}
\alias{errbar}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
errbar(x, y, sd, xlen = -1, col = par("fg"), lwd = par("lwd"), lty = 1, type = 0)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
%%     ~~Describe \code{x} here~~
}
  \item{y}{
%%     ~~Describe \code{y} here~~
}
  \item{sd}{
%%     ~~Describe \code{sd} here~~
}
  \item{xlen}{
%%     ~~Describe \code{xlen} here~~
}
  \item{col}{
%%     ~~Describe \code{col} here~~
}
  \item{lwd}{
%%     ~~Describe \code{lwd} here~~
}
  \item{lty}{
%%     ~~Describe \code{lty} here~~
}
  \item{type}{
%%     ~~Describe \code{type} here~~
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
function (x, y, sd, xlen = -1, col = par("fg"), lwd = par("lwd"), 
    lty = 1, type = 0) 
{
    inperunx <- par("pin")[1]/(par("usr")[2] - par("usr")[1])
    inperuny <- par("pin")[2]/(par("usr")[4] - par("usr")[3])
    if (xlen == -1) 
        xlen = min(inperunx * min(diff(x))/3, inperuny * min(sd/3))/inperunx
    xlenin <- xlen * inperunx
    if (type \%in\% c(0, 2)) 
        arrows(x, y, x, y - sd, angle = 90, col = col, lwd = lwd, 
            lty = lty, length = xlenin/2)
    if (type \%in\% c(0, 1)) 
        arrows(x, y, x, y + sd, angle = 90, col = col, lwd = lwd, 
            lty = lty, length = xlenin/2)
    return(data.frame(xlen))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
