
SEXP RMCTwoSampleAR(SEXP yR, SEXP NR, SEXP tR, SEXP rscaleR, SEXP alphaThetaR, SEXP betaThetaR, SEXP iterationsR);

double MCTwoSampleAR(double *y, int N, double *t, double rscale, double alphaTheta, double betaTheta, int iterations);

SEXP RgibbsTwoSampleAR(SEXP yR, SEXP NR, SEXP tR, SEXP rscaleR, SEXP alphaThetaR, SEXP betaThetaR, SEXP loAreaR, SEXP upAreaR, SEXP iterationsR, SEXP sdmetR, SEXP progressR, SEXP pBar, SEXP rho);

void gibbsTwoSampleAR(double *y, int N, double *t, double rscale, double alphaTheta, double betaTheta, double loArea, double upArea, int iterations, double sdmet, double *chains, int progress, SEXP pBar, SEXP rho);

double sampThetaAR(double theta, double mu, double delta, double sig2, double g, double *y, int N, double *t, double alphaTheta, double betaTheta , double sdmet);

double thetaLogLikeAR(double theta, double mu, double delta, double sig2, double g, double *y, int N, double *t, double alphaTheta, double betaTheta);


