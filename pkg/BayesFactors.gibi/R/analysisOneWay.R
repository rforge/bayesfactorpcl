.compileData <- function(model, data)
{
	iv = data$df.data[,model$level.one[["Location"]][[1]]]
	dv = data$df.data[,data$vars$dv]
	list(dependent=dv,independent=iv)
}

analysisOneWay <- function(model, settings, data, progress.callback = NULL,...)
	{	
		datalist = .compileData(model, data)
		dependent = datalist$dependent
		independent = as.factor(datalist$independent)
		rscale = as.numeric(model$prior[["Effect size"]]$scale)


		# Make data for MCMC; must be in matrix form
		maxN = max(table(independent))
		nlev = nlevels(independent)
		y = matrix(NA,maxN,nlev)
		listLevs = tapply(dependent,independent,c)
		for(i in 1:nlev){
			dataColumn = listLevs[[i]]
			y[1:length(dataColumn),i] = dataColumn 
		}
		
		iterations = as.numeric(settings$MCMC[['MCMC iterations']])
		burnin = as.numeric(settings$MCMC[['Burnin iterations']])
						
		# Analysis function here
		output = oneWayAOV.Gibbs(y, iterations = iterations, rscale = rscale, progress=FALSE)

		chains = output$chains[(burnin+1):iterations,]
			
			
		out = list(
							settings = list(iterations=iterations,
											burnin=burnin
									),
							diag = list(
									convergence = list()
									),
							rslt = list(
										samples = list(
										 	chains
										),
										inferentials = list("Bayes Factor for delta=0"=output$BF),
										posteriorMeans = list(
											colMeans(chains)
										),
										posteriorSD = list(
											apply(chains,2,sd)
										),
										MCerror = list(
										
										)
									),
							other = NULL,
							debug = list(data=datalist,
										 all.data=data,
										 y=y
									)
			)				

		return(out)
	}


analysisOneWay.old <- function(model, data, singleProgress = NULL)
	{	
		model$data = .compileData(model, data)	
		dependent = model$data$dependent
		independent = as.factor(model$data$independent)
		rscale = model$mdl$priors$scale

		balanced = .checkBalanced(independent)

		# Make data for MCMC; must be in matrix form
		maxN = max(table(independent))
		nlev = nlevels(independent)
		y = matrix(NA,maxN,nlev)
		listLevs = tapply(dependent,independent,c)
		for(i in 1:nlev){
			dataColumn = listLevs[[i]]
			y[1:length(dataColumn),i] = dataColumn 
		}
		Fval = summary(aov(dependent~independent))[[1]][1,4]
		
		if(!is.null(model$anls$MCMC)){
		
			iterations = model$anls$MCMC$iterations
			burnin = model$anls$MCMC$burnin
						
			# Analysis function here
			output = oneWayAOV.Gibbs(y, iterations = iterations, rscale = rscale, progress=FALSE)

			chains = output$chains[(burnin+1):iterations,]
			
			if(balanced){
				bf = oneWayAOV.Quad(F = Fval,N = maxN, J = nlev, rscale = rscale)
			}else{
				bf = output$BF
			}
			
			model$out = list(
								diag = list(
										convergence = list(),
								),
								rslt = list(
										samples = list(
											 	chains
										),
										inferentials = list("Bayes Factor for delta=0"=bf),
										posteriorMeans = list(
												colMeans(chains)
										),
										posteriorSD = list(
												apply(chains,2,sd)
										),
										MCerror = list(
									
										),
								),
								other = NULL,
								debug = list(y=y)
			)				

			model$hasResults = TRUE
			model$flag = 0
		}else if(!is.null(model$anls$quadrature) & balanced){	
			
			bf = oneWayAOV.Quad(F = Fval,N = maxN, J = nlev, rscale = rscale)
			model$out = list(
								diag = list(),
								rslt = list(
										inferentials = list("Bayes Factor for delta=0"=bf),
								),
								other = NULL,
								debug = list(F=Fval,N=maxN,J=nlev,rscale=rscale)
			)				

			model$hasResults = TRUE
			model$flag = 0
			model$error = NULL
		}else{
			model$hasResults = FALSE
			model$flag = 1
			model$error = "Model could not be analyzed. If the design is not balanced, choose MCMC rather than quadrature."
		}
		

		return(model)
	}