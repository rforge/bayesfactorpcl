analyzeModelList <- function(modelList, data, activeAnalysis, globalProgress = NULL, singleProgress = NULL)
	{

		modelList = lapply(modelList, .cleanModel)
		if(activeAnalysis=="oneWayAov"){
			modelList = lapply(modelList, analysisOneWay, data = data, singleProgress = NULL)
		}
		return(modelList)
		# increment progress?
	}

.cleanModel <- function(model)
{
	model$data <- NULL
	model$out <- NULL
	model$hasResults = FALSE
	model$flag = NULL
	model$error = NULL
}

