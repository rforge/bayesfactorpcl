\name{ttest.Gibbs.AR}
\alias{ttest.Gibbs.AR}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
A function to sample from the posterior distribution of parameters in one-sample designs 
}
\description{
This function samples from the posterior distributions of parameters for 
one-sample designs, using Gibbs sampling.  See details about priors in the details.
}
\usage{
ttest.Gibbs.AR(before, after, iterations = 10000, rscale = 1, progress = TRUE)
}
\arguments{
  \item{before}{
A vector of observations, in time order, taken before the treatment.
}
  \item{after}{
A vector of observations, in time order, taken after the treatment. 
}
  \item{iterations}{
Number of Gibbs sampler iterations to perform
}
  \item{rscale}{
The prior scale (see Details below)
}
  \item{progress}{
Report progress with a text progress bar?
}
}
\details{
ADD DETAILS
}
\value{
A list containing the following:
\item{chains}{A object of type MCMC containing the chains for each parameter}
\item{BF}{An MCMC estimate of the Bayes factor, computed using the Savage-Dickey method (Morey, Rouder, Pratte, and Speckman, submitted)}
}
\references{
Morey, R. D., Rouder, J. N., Pratte, M. S., \& Speckman, P. L. (2011). Conditional Marginal Density 
Estimation to Improve Bayes Factor Computation.

Perception and Cognition Lab (University of Missouri): Bayes factor calculators. \url{http://pcl.missouri.edu/bayesfactor}
}
\author{
Richard D. Morey
}
\note{
For a more accurate method of computing the Bayes factor, see \code{\link{ttest.Quad}}.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%\code{\link{t.test}}, \code{\link{ttest.Quad}}, %\code{\link{oneWayAOV.Quad}},\code{\link{oneWayAOV.Gibbs}}
}
\examples{
## Sample some random data
y = rnorm(20)

output = ttest.Gibbs.AR(before=y[1:10],after=y[11:20])

## Look at the posterior distribution of the mean
plot(output$chains[,1])
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{htest}
\keyword{models}