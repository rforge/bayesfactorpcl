\name{as.BFBayesFactor}
\alias{as.BFBayesFactor}
\title{Function to coerce objects to the BFBayesFactor class}
\usage{
  as.BFBayesFactor(object)
}
\arguments{
  \item{object}{an object of appropriate class (for now,
  BFBayesFactorTop)}
}
\value{
  An object of class \code{BFBayesFactor}
}
\description{
  This function coerces objects to the BFBayesFactor class
}
\details{
  Function to coerce objects to the BFBayesFactor class

  Currently, this function will only work with objects of
  class \code{BFBayesFactorTop}, which are output from the
  functions \code{anovaBF} and \code{regressionBF} when the
  \code{whichModels} argument is set to \code{'top'}
}
\author{
  Richard D. Morey (\email{richarddmorey@gmail.com})
}
\seealso{
  \code{\link{regressionBF}}, \code{anovaBF} whose output
  is appropriate for use with this function when
  \code{whichModels='top'}
}
\keyword{misc}

