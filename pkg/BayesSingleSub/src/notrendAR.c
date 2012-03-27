#include "utility.h"
#include "notrendAR.h"


SEXP RMCTwoSampleAR(SEXP yR, SEXP NR, SEXP tR, SEXP rscaleR, SEXP alphaThetaR, SEXP betaThetaR, SEXP iterationsR)
{
	int iterations = INTEGER_VALUE(iterationsR);
	int N = INTEGER_VALUE(NR);
	double rscale = NUMERIC_VALUE(rscaleR);
	double alphaTheta = NUMERIC_VALUE(alphaThetaR);
	double betaTheta = NUMERIC_VALUE(betaThetaR);
	double *y = REAL(yR);
	double *t = REAL(tR);
	
	SEXP logBFR;
	PROTECT(logBFR = allocVector(REALSXP, 1));
	double *logBF = REAL(logBFR);

	logBF[0] = MCTwoSampleAR(y, N, t, rscale, alphaTheta, betaTheta, iterations);
	
	UNPROTECT(1);
	
	return(logBFR);
}

double MCTwoSampleAR(double *y, int N, double *t, double rscale, double alphaTheta, double betaTheta, int iterations)
{
	int i=0, j=0, m=0, Nsqr = N*N, iOne=1;
	double theta,g,rscsq=rscale*rscale,mLike;
	double ones[N],dOne=1,dZero=0;
	double invPsi[Nsqr],invPsi0[Nsqr],invPsi1[Nsqr];
	double tempV[N];
	double tOnePsiOne,ttPsi0t;
	double tempS, devs, logmlike[iterations];
	
	AZERO(invPsi,Nsqr);
	
	
	for(i=0;i<N;i++)
	{
		ones[i] = 1;
	}

	GetRNGstate();
	
	for(m=0;m<iterations;m++)
	{
		g = 1/rgamma(0.5,2/rscsq);
		theta = rbeta(alphaTheta,betaTheta);
		
		for(i=0;i<N;i++)
		{
			invPsi[i + N*i] = 1/(1-theta*theta);		
			for(j=0;j<i;j++)
			{
				invPsi[i + N*j] = invPsi[i + N*i] * pow(theta,abs(i-j));
				invPsi[j + N*i] = invPsi[i + N*j];
			}
		}
		
		
		InvMatrixUpper(invPsi, N);
		internal_symmetrize(invPsi, N);

		Memcpy(invPsi0,invPsi,Nsqr);
		
		tOnePsiOne = quadform(ones, invPsi, N, 1, N);
		tempS = -1/tOnePsiOne;
		
		F77_NAME(dsymv)("U", &N, &dOne, invPsi, &N, ones, &iOne, &dZero, tempV, &iOne);
		F77_NAME(dsyr)("U", &N, &tempS, tempV, &iOne, invPsi0, &N);
		
		Memcpy(invPsi1,invPsi0,Nsqr);

		ttPsi0t = quadform(t, invPsi0, N, 1, N) + 1/g;
		tempS = -1/ttPsi0t;
		
		F77_NAME(dsymv)("U", &N, &dOne, invPsi0, &N, t, &iOne, &dZero, tempV, &iOne);
		F77_NAME(dsyr)("U", &N, &tempS, tempV, &iOne, invPsi1, &N);
		
		devs = quadform(y,invPsi1,N,1,N);
		
		logmlike[m] = -0.5*(1.0*N-1)*log(devs) - 0.5*log(tOnePsiOne) - 0.5*log(ttPsi0t) +
					0.5*matrixDet(invPsi, N, N, 1) - 0.5*log(g);
		
	}

	PutRNGstate();
	
	return(logMeanExpLogs(logmlike,iterations));
	
}


SEXP RgibbsTwoSampleAR(SEXP yR, SEXP NR, SEXP tR, SEXP rscaleR, SEXP alphaThetaR, SEXP betaThetaR, SEXP loAreaR, SEXP upAreaR, SEXP iterationsR, SEXP sdmetR, SEXP progressR, SEXP pBar, SEXP rho)
{
	int npars = 7,iterations = INTEGER_VALUE(iterationsR);
	int N = INTEGER_VALUE(NR), progress = INTEGER_VALUE(progressR);
	double rscale = NUMERIC_VALUE(rscaleR);
	double alphaTheta = NUMERIC_VALUE(alphaThetaR);
	double betaTheta = NUMERIC_VALUE(betaThetaR);
	double sdmet = NUMERIC_VALUE(sdmetR);
	double *y = REAL(yR);
	double *t = REAL(tR);
	double loArea = REAL(loAreaR)[0];
	double upArea = REAL(upAreaR)[0];
	
	SEXP chainsR;
	PROTECT(chainsR = allocMatrix(REALSXP, npars, iterations));

	gibbsTwoSampleAR(y, N, t, rscale, alphaTheta, betaTheta, loArea, upArea, iterations, sdmet, REAL(chainsR), progress, pBar, rho);
	
	UNPROTECT(1);
	
	return(chainsR);
}


void gibbsTwoSampleAR(double *y, int N, double *t, double rscale, double alphaTheta, double betaTheta, double loArea, double upArea, int iterations, double sdmet, double *chains, int progress, SEXP pBar, SEXP rho)
{
	int i=0, j=0, m=0,Nsqr=N*N,iOne=1;
	double varMu, meanMu, varDelta, meanDelta, aSig2, bSig2, ag, bg, rscsq=rscale*rscale;
	double mu = 0, sig2=0, delta = 0, theta = 0, g = 1, ldensDelta;
	double tOnePsiOne,psiOne[N],dZero=0,dOne=1;
	double ttPsit,psit[N],loglikeTheta;
	double nullArea;
	
	double tempV[N];
	double ones[N];
	double invPsi[Nsqr];
	AZERO(invPsi,Nsqr);

	for(i=0;i<N;i++)
	{
		ones[i]=1;
		mu += y[i]/(N*1.0);
		sig2 += y[i]*y[i];
	}
	sig2 = (sig2 - N*mu*mu)/(N*1.0-1);
	

	// progress stuff
	SEXP sampCounter, R_fcall;
	int *pSampCounter;
    PROTECT(R_fcall = lang2(pBar, R_NilValue));
	PROTECT(sampCounter = NEW_INTEGER(1));
	pSampCounter = INTEGER_POINTER(sampCounter);

	GetRNGstate();

	for(m=0;m<iterations;m++)
	{

		R_CheckUserInterrupt();
	
		//Check progress
		if(progress && !((m+1)%progress)){
			pSampCounter[0]=m+1;
			SETCADR(R_fcall, sampCounter);
			eval(R_fcall, rho); //Update the progress bar
		}

		// Build invPsi matrix
		invPsi[0] = 1;
		invPsi[N*N-1] = 1;
		invPsi[1] = -theta;
		invPsi[N] = -theta;
		
		for(i=1;i<(N-1);i++)
		{
			invPsi[i + N*i] = (1 + theta*theta);
			invPsi[i + N*(i+1)] = -theta; 
			invPsi[(i+1) + N*i] = -theta; 			
		}
	

		//mu
		tOnePsiOne = quadform(ones, invPsi, N, 1,N);
		F77_NAME(dsymv)("U", &N, &dOne, invPsi, &N, ones, &iOne, &dZero, psiOne, &iOne);

		meanMu = 0;
		varMu = sig2/tOnePsiOne;
		for(i=0;i<N;i++)
		{
			meanMu += (y[i] - delta*t[i])*psiOne[i];
		}
		meanMu = meanMu/tOnePsiOne;
		mu = rnorm(meanMu,sqrt(varMu));
		
		//delta
		ttPsit = quadform(t, invPsi, N, 1,N);
		F77_NAME(dsymv)("U", &N, &dOne, invPsi, &N, t, &iOne, &dZero, psit, &iOne);

		meanDelta = 0;
		varDelta = sig2/(ttPsit + 1/g);
		for(i=0;i<N;i++)
		{
			meanDelta += (y[i] - mu)*psit[i];
		}
		meanDelta = meanDelta/(ttPsit + 1/g);
		delta = rnorm(meanDelta, sqrt(varDelta));

		//deltaDens
		varDelta = 1/(ttPsit + 1/g);
		meanDelta = meanDelta/sqrt(sig2);
		ldensDelta = dnorm(0,meanDelta, sqrt(varDelta), 1);		
		
		//area
		nullArea = pnorm(upArea,meanDelta, sqrt(varDelta), 1, 0) -
		pnorm(loArea,meanDelta, sqrt(varDelta), 1, 0);	
		
		//sig2
		aSig2 = 0.5*(N+1);
		for(i=0;i<N;i++)
		{
			tempV[i] = (y[i] - mu - delta*t[i]);
		}
		bSig2 = 0.5*(quadform(tempV,invPsi,N,1,N) + delta*delta/g);
		sig2 = 1/rgamma(aSig2,1/bSig2);
		
		//g
		ag = 1;
		bg = 0.5*(delta*delta/sig2 + rscsq);
		g = 1/rgamma(ag,1/bg);
		
		//theta
		theta = sampThetaAR(theta, mu, delta, sig2, g, y, N, t, alphaTheta, betaTheta, sdmet);
	
		// write chain
		chains[0*iterations + m] = mu;
		chains[1*iterations + m] = delta;
		chains[2*iterations + m] = ldensDelta;
		chains[3*iterations + m] = sig2;
		chains[4*iterations + m] = g;
		chains[5*iterations + m] = theta;
		chains[6*iterations + m] = nullArea;
		
	
	}

	UNPROTECT(2);
	PutRNGstate();
}


double sampThetaAR(double theta, double mu, double delta, double sig2, double g, double *y, int N, double *t, double alphaTheta, double betaTheta , double sdmet)
{
	// sample theta with Metropolis-Hastings
	double cand, likeRat, b;
	
	cand = theta + rnorm(0,sdmet);
	
	if(cand<0 || cand>1)
	{
		return(theta);
	}
	b = log(runif(0,1));
	likeRat = thetaLogLikeAR(cand, mu, delta, sig2, g, y, N, t, alphaTheta, betaTheta) - thetaLogLikeAR(theta, mu, delta, sig2, g, y, N, t, alphaTheta, betaTheta);
	
	if(b>likeRat){
		return(theta);
	}else{
		return(cand);
	}
}

double thetaLogLikeAR(double theta, double mu, double delta, double sig2, double g, double *y, int N, double *t, double alphaTheta, double betaTheta)
{
	int i;
	double loglike=0,tempV[N],invPsi[N*N],det;
	
	AZERO(invPsi,N*N);
	
	// Build invPsi matrix	
	invPsi[0] = 1;
	invPsi[N*N-1] = 1;
	invPsi[1] = -theta;
	invPsi[N] = -theta;
	for(i=0;i<N;i++)
	{
		tempV[i] = y[i] - mu - delta*t[i];
		
		if(i>0 && i<(N-1)){
			invPsi[i + N*i] = (1 + theta*theta);
			invPsi[i + N*(i+1)] = -theta; 
			invPsi[(i+1) + N*i] = -theta; 			
		}
	}
	det = log(1-theta*theta);

	loglike = 0.5 * det - 0.5/sig2 * quadform(tempV,invPsi,N,1,N) + (alphaTheta-1)*log(theta) + (betaTheta-1)*log(1-theta);
	
	return(loglike);
}

