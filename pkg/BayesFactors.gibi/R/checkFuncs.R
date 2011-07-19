.checkBalanced<-function(v,...)
	{
		freqs = table(v)		
		# Check to make sure they are all identical, and not equal to 1.
		if( !all(freqs==1) & all(freqs[1] == freqs))
		{
			return(TRUE)
		}else{
			return(FALSE)
		}
	}


check.temp <- function(assignments) {

  if (assignments[["response"]] == "")
    return(FALSE)

  if (assignments[["change"]] == "")
    return(FALSE)

  if (assignments[["set size"]] == "")
    return(FALSE)

  if (length(assignments[["categorical"]]) < 1)
    return(FALSE)

  if (length(assignments[["continuous"]]) < 1)
    return(FALSE)

  TRUE
}