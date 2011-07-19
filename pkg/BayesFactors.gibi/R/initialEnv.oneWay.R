initialEnvironment.oneWay <- function()
{
	
  ifc <- new.env(parent=baseenv())

  ifc$data <- new.env(parent=baseenv())

  ifc$data$vars <- list(dv="dependent variable") 
  ifc$data$cols <- list(categorical="categorical")

  ifc$data$check <- check.temp

  ifc$models <- new.env(parent=baseenv())

  ifc$models$create.default <- BayesFactors.gibi:::create.model
  ifc$models$create.description <- BayesFactors.gibi:::create.description

  ifc$pluginVersion = .pluginVersion
  ifc$gibiVersion = .gibiVersion
  ifc$pluginName = .pluginName


  return(ifc)
}


create.description <- function(model) 
{
  
  if(!is.null(model$anls))
	{
  		list("IV" = model$mdl$level.one[["Location"]][[1]],
  			 "Levels" = nlevels(as.factor(model$data$independent)),
			 "BF" = model$out$rslt$inferentials[[1]],
			 "post. mean mu" = model$out$rslt$posteriorMeans[,1],
			 "post. sd delta" = model$out$rslt$posteriorSD[,1],
			 #"MC error delta" = model$out$rslt$MCerror[,1]
			 "scale" = model$mdl$priors$rscale
			 )
			 
	}else{
	  		list("IV" = model$mdl$level.one[["Location"]][[1]],
  			 "Levels" = nlevels(as.factor(model$data$independent)),
			 "BF" = "",
			 "post. mean delta" = "",
			 "post. sd delta" = "",
			 #"MC error delta" = "
			 "scale" = ""
			 )

	
	}


}

create.model <- function() {

  list(
    level.one = list("Location"=list()),
    prior     = list("Effect size"=list("scale"=1))
  )
}





initialEnvironment.oneWay.old <- function(pluginEnv)
{
	pluginEnv$pluginVersion = .pluginVersion
	pluginEnv$gibiVersion = .gibiVersion
	pluginEnv$pluginName = .pluginName
	
	pluginEnv$ifc <- list(
						intro <- list(
								
								),
						data <- list(
									require <- list(
											response <- list(
															name<-"Dependent",
															short<-"Dependent Variable",
															long<-"The dependent, or response, variable is...",
															checkFunc <- .checkNumConvert,
															checkFuncArgs=list()
														)
									),
									interest <- list(
											maxElements <- Inf,
											minElements <- 1,
											types <- list(
															independent<-list(
																			name="Independent",
																			short="Independent Variable",
																			long="The independent, or predictor, variable is...",
																			checkFunc <- .checkNumLevels,
																			checkFuncArgs=list(minLevs=2)
															)								
											)
									)
									
								),
						mdl <- list(
									# The effectsListFunc() function will take the columns of interest as an argument
									# and return a list of possible effects.
									effectsListFunc <- .pluginEffectsList,
									priors <- list(
											scale <- list(
														parameter="delta",
														name="Scale (r)",
														short="Effect size scale",
														long="The scale on the Cauchy prior on effect size.",
														optionsList=NULL,
														sliderRange=NULL,
														default=1,
														checkFunc <- .checkPositive,
														checkFuncArgs=list()
											)
									),
									# List of parameters 
									delta <- list(
											togglable=FALSE,
											name="delta",
											short="Effect size",
											long="Effect size (mu/sigma)",
											maxElements=1,
											minElements=1,
											checkFunc <- .pluginDeltaCheck,
											checkFuncArgs=list(),
											# addFrom determines where the effects are moved from 
											addFrom=".internalEffects",
											# addAction determines how the effects are grouped
											# other possible option is "group"
											addAction="plus"
									)
								
								),
						anls <- list(
									integrate <- list(						
												name="Method",
												short="Integration method",
												long="The type of integration method. MCMC is slow, but provides estimates of marginal posteriors. Quadrature is fast, but only provides the Bayes factor.",
												exclusiveGroup=list(
																MCMC <- list(
																		name="MCMC",
																		short="MCMC Options",
																		long="Settings related to MCMC sampling",
																		checkFunc <- .pluginCheckMCMC,
																		checkFuncArgs <- list(),
																		sortPriority=1,
																		group=list(				
																				iterations <- list(
																								name="Iterations",
																								short="Number of MCMC iterations",
																								long="Number of MCMC iterations (0 for no MCMC; only the Bayes factor will be computed).",
																								default <- 1000,
																								checkFunc <- .checkNonNegative,
																								checkFuncArgs=list(),
																								sortPriority=1
																				),
																				burnin <- list(
																								name="Burn-in",
																								short="Number of burn-in iterations",
																								long="Number of initial iterations to throw away",
																								default <- 100,
																								checkFunc <- .checkNonNegative,
																								checkFuncArgs=list(),
																								sortPriority=2													
																				)
																		)			

																),
																quadrature <- list(
																		name="Quadrature",
																		short="Gaussian quadrature",
																		long="No settings available for Gaussian quadrature method."
																)
																
												)
									),
									tone <- list(
											name="Tone",
											short="Tone when done?",
											long="Sound a tone when the analysis is finished?",
											default="yes",
											optionsList=c("yes","no"),
											checkFunc <- NULL,
											checkFuncArgs=list(),
											sortPriority=2
									)
								),
						diag <- list(

								),
						rslt <- list(
						
								),
						plt <- list(
						
								),
						save <- list(
								
								)
					)

	pluginEnv$usr <- list(
						data=list(),	
						mdls=list()			
					)
} # end initialEnvironment