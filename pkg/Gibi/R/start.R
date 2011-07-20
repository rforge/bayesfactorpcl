
Gibi <- function() {

  library("R.rsp")
  library("rjson")

  daemon <- HttpDaemon()
  path.to.html <- gsub("\\\\", "/", paste(installed.packages()["Gibi","LibPath"], "Gibi", "rsp", sep="/"))
  setRootPaths(daemon, path.to.html)
  start(daemon)

  browseURL("http://localhost:8080/Gibi.html")

}
