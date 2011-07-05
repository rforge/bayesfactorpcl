.onLoad <- function(libname, pkgname)
{
	# define version numbers
	allPackages = installed.packages()

	.pluginVersion <<- allPackages[which(allPackages[,1]==pkgname),3]
	.gibiVersion <<- allPackages[which(allPackages[,1]=="gibi"),3]
	.pluginName <<- pkgname	 
	
	
	.pluginEnv <<- new.env(parent=baseenv())
	initialEnvironment(.pluginEnv)
	.pluginProvides <- list(
						oneWayAov <- list(
								name="One-way ANOVA",
								short="One-way analysis of variance",
								long="One-way analysis of variance as described by Morey, Rouder, Pratte, and Speckman (in press)."
						)
	)
	
	c("ttest")

}
