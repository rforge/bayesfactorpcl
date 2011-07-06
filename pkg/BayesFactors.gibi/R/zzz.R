.onLoad <- function(libname, pkgname)
{
	# define version numbers
	allPackages = installed.packages()

	.pluginVersion <<- allPackages[which(allPackages[,1]==pkgname),3]
	.gibiVersion <<- allPackages[which(allPackages[,1]=="gibi"),3]
	.pluginName <<- pkgname	 
	
	
	.pluginEnv <<- new.env(parent=baseenv())
	initialEnvironment(.pluginEnv)
	.pluginProvides <- 0#read in information from gibi.txt

}
