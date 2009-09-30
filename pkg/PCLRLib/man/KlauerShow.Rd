\name{KlauerShow}
\Rdversion{1.1}
\alias{KlauerShow}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
KlauerShow(object)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{
%%     ~~Describe \code{object} here~~
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
function (object) 
{
    BICstring = ifelse(object@BICgen < object@BICres, "*BIC favors nonzero intercept*\n", 
        "*BIC favors null intercept*\n")
    genCode = ifelse((object@code.gen \%in\% c(1, 2)), "", paste("*Warning: General model failed to converge. NLM Code:", 
        object@code.gen, "*\n", sep = ""))
    resCode = ifelse((object@code.res \%in\% c(1, 2)), "", paste("*Warning: Restricted model failed to converge. NLM Code:", 
        object@code.res, "*\n", sep = ""))
    EXsigstr = ifelse(object@EXsig[1] == -1, "", "EXsig was given.\n")
    display = paste("Klauer Errors-in-Variables test\n", "-------------------------------\n", 
        "Intercept Estimate           : ", zapsmall(object@intercept.est[2]), 
        " (", 100 * object@CIconf, "\% CI: ", zapsmall(object@intercept.est[3]), 
        ",", zapsmall(object@intercept.est[1]), ")\n", "Chi-square(1) test statistic : ", 
        zapsmall(object@X2), " (p=", zapsmall(object@p.val), 
        ")\n", "Nonzero Intercept BIC        : ", zapsmall(object@BICgen), 
        "\n", "Null intercept BIC           : ", zapsmall(object@BICres), 
        "\n", BICstring, genCode, resCode, EXsigstr, "\n\n", 
        sep = "")
    cat(noquote(display))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
