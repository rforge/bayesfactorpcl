\name{draw.square}
\Rdversion{1.1}
\alias{draw.square}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
draw.square(xcen, ycen, radius, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{xcen}{
%%     ~~Describe \code{xcen} here~~
}
  \item{ycen}{
%%     ~~Describe \code{ycen} here~~
}
  \item{radius}{
%%     ~~Describe \code{radius} here~~
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
function (xcen, ycen, radius, ...) 
{
    theta = seq(pi/4, 9 * pi/4, len = 5)
    y = sqrt(2) * radius * sin(theta) + ycen
    x = sqrt(2) * radius * cos(theta) + xcen
    polygon(x, y, ...)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
