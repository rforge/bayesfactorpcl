.checkBalanced(v,...)
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
