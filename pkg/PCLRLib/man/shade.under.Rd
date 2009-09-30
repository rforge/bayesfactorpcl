\name{shade.under}
\Rdversion{1.1}
\alias{shade.under}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
shade.under(fn, range = c(-Inf, Inf), precision = 100, addaxis = TRUE, border = NULL, density = NULL, angle = 45, col = NULL, lty = NULL, xpd = NULL, redraw = FALSE, col.redraw = par("fg"), prec.redraw = NULL, lty.redraw = par("lty"), lwd.redraw = par("lwd"), ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{fn}{
%%     ~~Describe \code{fn} here~~
}
  \item{range}{
%%     ~~Describe \code{range} here~~
}
  \item{precision}{
%%     ~~Describe \code{precision} here~~
}
  \item{addaxis}{
%%     ~~Describe \code{addaxis} here~~
}
  \item{border}{
%%     ~~Describe \code{border} here~~
}
  \item{density}{
%%     ~~Describe \code{density} here~~
}
  \item{angle}{
%%     ~~Describe \code{angle} here~~
}
  \item{col}{
%%     ~~Describe \code{col} here~~
}
  \item{lty}{
%%     ~~Describe \code{lty} here~~
}
  \item{xpd}{
%%     ~~Describe \code{xpd} here~~
}
  \item{redraw}{
%%     ~~Describe \code{redraw} here~~
}
  \item{col.redraw}{
%%     ~~Describe \code{col.redraw} here~~
}
  \item{prec.redraw}{
%%     ~~Describe \code{prec.redraw} here~~
}
  \item{lty.redraw}{
%%     ~~Describe \code{lty.redraw} here~~
}
  \item{lwd.redraw}{
%%     ~~Describe \code{lwd.redraw} here~~
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
function (fn, range = c(-Inf, Inf), precision = 100, addaxis = TRUE, 
    border = NULL, density = NULL, angle = 45, col = NULL, lty = NULL, 
    xpd = NULL, redraw = FALSE, col.redraw = par("fg"), prec.redraw = NULL, 
    lty.redraw = par("lty"), lwd.redraw = par("lwd"), ...) 
{
    range = range[1:2]
    if (range[2] < range[1]) {
        range = rev(range)
    }
    if (range[1] == -Inf) {
        range[1] = par("usr")[1]
    }
    if (range[2] == Inf) {
        range[2] = par("usr")[2]
    }
    precision = diff(range)/precision
    x = seq(range[1], range[2], precision)
    y = fn(x, ...)
    x1 = c(x, rev(x))
    y1 = c(y, y * 0)
    polygon(x1, y1, border = border, density = density, angle = angle, 
        col = col, lty = lty, xpd = xpd)
    if (redraw) {
        if (is.null(prec.redraw)) {
            x.redraw = seq(par("usr")[1], par("usr")[2], precision)
        }
        else {
            x.redraw = seq(par("usr")[1], par("usr")[2], diff(par("usr")[1:2])/prec.redraw)
        }
        lines(x.redraw, fn(x.redraw, ...), col = col.redraw, 
            lty = lty.redraw, lwd = lwd.redraw)
        if (addaxis) {
            abline(h = 0, col = par("fg"), lty = par("lty"))
        }
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
