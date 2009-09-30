\name{draw.roundRect}
\Rdversion{1.1}
\alias{draw.roundRect}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
draw.roundRect(xcen, ycen, height, width, radiusFrac, prec = 7, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{xcen}{
%%     ~~Describe \code{xcen} here~~
}
  \item{ycen}{
%%     ~~Describe \code{ycen} here~~
}
  \item{height}{
%%     ~~Describe \code{height} here~~
}
  \item{width}{
%%     ~~Describe \code{width} here~~
}
  \item{radiusFrac}{
%%     ~~Describe \code{radiusFrac} here~~
}
  \item{prec}{
%%     ~~Describe \code{prec} here~~
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
function (xcen, ycen, height, width, radiusFrac, prec = 7, ...) 
{
    realRad = radiusFrac * 0.5 * min(height, width)
    lineWidth = width - 2 * realRad
    lineHeight = height - 2 * realRad
    segments(xcen - width/2, ycen - lineHeight/2, xcen - width/2, 
        ycen + lineHeight/2, ...)
    segments(xcen + width/2, ycen - lineHeight/2, xcen + width/2, 
        ycen + lineHeight/2, ...)
    segments(xcen - lineWidth/2, ycen + height/2, xcen + lineWidth/2, 
        ycen + height/2, ...)
    segments(xcen - lineWidth/2, ycen - height/2, xcen + lineWidth/2, 
        ycen - height/2, ...)
    theta = seq(0, pi/2, len = 2^floor(prec) + 1)
    y = realRad * sin(theta) + (height/2) - realRad + ycen
    x = realRad * cos(theta) + (width/2) - realRad + xcen
    lines(x, y, ...)
    theta = seq(pi/2, pi, len = 2^floor(prec) + 1)
    y = realRad * sin(theta) + (height/2) - realRad + ycen
    x = realRad * cos(theta) - (width/2) + realRad + xcen
    lines(x, y, ...)
    theta = seq(pi, 3 * pi/2, len = 2^floor(prec) + 1)
    y = realRad * sin(theta) - (height/2) + realRad + ycen
    x = realRad * cos(theta) - (width/2) + realRad + xcen
    lines(x, y, ...)
    theta = seq(3 * pi/2, 2 * pi, len = 2^floor(prec) + 1)
    y = realRad * sin(theta) - (height/2) + realRad + ycen
    x = realRad * cos(theta) + (width/2) - realRad + xcen
    lines(x, y, ...)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
