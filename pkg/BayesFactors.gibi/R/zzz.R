.onLoad <- function(libname, pkgname)
{
	# define version numbers
	allPackages = installed.packages()

	assignInNamespace(".pluginVersion", allPackages[which(allPackages[,1]==pkgname),3], pkgname)
#	assignInNamespace(".gibiVersion", allPackages[which(allPackages[,1]=="gibi"),3], pkgname)
	assignInNamespace(".gibiVersion", 0.001, pkgname)
	assignInNamespace(".pluginName", pkgname, pkgname)

	
}
