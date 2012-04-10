\name{ttest.MCGQ.AR}
\alias{ttest.MCGQ.AR}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Obtain Bayesian t test for single case data
}
\description{
This function computes a Bayes factor for the mean difference between two phases of a single subject data sequence, 
using monte carlo integration.
}
\usage{
ttest.MCGQ.AR(before, after, iterations = 10000, r.scale = 1, alphaTheta = 1, betaTheta = 5)
}
\arguments{
  \item{before}{
A vector of observations, in time order, taken in Phase 1 (e.g., before the treatment).
}
  \item{after}{
A vector of observations, in time order, taken in Phase 2 (e.g., after the treatment). 
}
  \item{iterations}{
Number of Gibbs sampler iterations to perform.
}
  \item{r.scale}{
Prior scale for delta (see Details below).
}
\item{alphaTheta}{
The alpha parameter of the beta prior on theta (see Details below).
}
 \item{betaTheta}{
The beta parameter of the beta prior on theta (see Details below).
}
}
\details{
This function computes a Bayes factor for the mean difference between two data sequences from a single subject,
 using monte carlo integration. The Bayes factor compares the null hypothesis of no true mean difference against the 
alternative hypothesis of a true mean difference. A Bayes factor larger than 1 supports the null hypothesis,
 a Bayes factor smaller than 1 supports the alternative hypothesis. Auto-correlation of the errors is modeled by a first
 order auto-regressive process.

A Cauchy prior is placed on the standardized mean difference delta. The \code{r.scale} argument controls the scale of
 this Cauchy prior, with \code{r.scale=1} yielding a standard Cauchy prior. A noninformative Jeffreys prior is 
placed on the variance of the random shocks of the auto-regressive process. A beta prior is placed on the auto-correlation
 theta. The \code{alphaTheta} and \code{betaTheta} arguments control the form of this beta prior.
}
\value{
\item{logbf}{A monte carlo estimate of the log Bayes factor.}
}
\references{
Perception and Cognition Lab (University of Missouri): Bayes factor calculators. \url{http://pcl.missouri.edu/bayesfactor}
}
\author{
Richard D. Morey and Rivka de Vries
}
\note{
To obtain posterior distributions and interval null Bayes factors, see \code{\link{ttest.Gibbs.AR}}.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{ttest.Gibbs.AR}}, \code{\link{trendtest.Gibbs.AR}}, \code{\link{trendtest.MC.AR}}
}
\examples{
## Define data
data = c(87.5, 82.5, 53.4, 72.3, 94.2, 96.6, 57.4, 78.1, 47.2,
 80.7, 82.1, 73.7, 49.3, 79.3, 73.3, 57.3, 31.7, 50.4, 77.8,
 67, 40.5, 1.6, 38.6, 3.2, 24.1)

## Obtain log Bayes factor
logBF = ttest.MCGQ.AR(data[1:10], data[11:25])

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{htest}
\keyword{models}