
get.available.analyses <- function() {

  packages         <- installed.packages()
  search.paths     <- paste(packages[,'LibPath'], packages[,'Package'], "etc/gibi.txt", sep="/")
  gibi.plugins     <- subset(packages, file.exists(search.paths))
  
  analysis.types <- list()

  for (plugin.name in gibi.plugins[,1]) {

    plugin <- gibi.plugins[plugin.name,]
    descriptors.path <- paste(plugin['LibPath'], plugin['Package'], "etc/gibi.txt", sep="/")
    descriptors <- read.table(descriptors.path, as.is=T, col.names=c("name", "nice.name", "short.desc", "long.desc", "init.func"))

    for (i in 1:length(descriptors[,1]))
      analysis.types[[length(analysis.types)+1]] <- as.list(descriptors[i,])
  }

  analysis.types
}