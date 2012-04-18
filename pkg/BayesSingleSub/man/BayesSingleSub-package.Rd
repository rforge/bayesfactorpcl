\name{BayesSingleSub-package}
\alias{BayesSingleSub-package}
\alias{BayesSingleSub}
\docType{package}
\title{
Functions to obtain Bayes factor hypothesis tests and posterior samples of parameters for single case data.
}
\description{
This package contains functions to compute Bayes factors for the mean difference, trend difference, and intercept 
difference in single case data sequences. Some functions also provide posterior samples of parameters and interval 
null Bayes factors.
}
\details{
\tabular{ll}{
Package: \tab BayesSingleSub\cr
Type: \tab Package\cr
Version: \tab 0.6\cr
Date: \tab 2012-03-28\cr
License: \tab GPL 2.0\cr
LazyLoad: \tab yes\cr
}
The following functions are currently implemented, with more to follow:

ttest.Gibbs.AR(): Compute Bayes factor for mean difference using Gibbs sampling and obtain posterior samples of parameters
ttest.MCGQ.AR(): Compute Bayes factor for mean difference using monte carlo integration
trendtest.Gibbs.AR(): Compute Bayes factors for trend and intercept differences using Gibbs sampling and obtain posterior samples of parameters
trendtest.MC.AR(): Compute Bayes factors for trend and intercept differences using monte carlo integration

}
\author{
Richard D. Morey and Rivka de Vries

Maintainer: Richard D. Morey <richarddmorey@gmail.com>
}
\references{
De Vries, R. M. \& Morey, R. D. (submitted). Bayesian hypothesis testing Single-Subject Data. Psychological Methods.

Perception and Cognition Lab (University of Missouri): Bayes factor calculators. \url{http://pcl.missouri.edu/bayesfactor}
}
\keyword{htest}
\examples{
## See specific functions for examples
}
