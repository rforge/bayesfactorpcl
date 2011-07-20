parse.receive <- function(json) {

  fromJSON(json)

}

format.to.send <- function(data) {

  library("rjson")
  
  return(paste('{
    "status"    : "OK",
    "data.name"  : "',
    names(data)[1],
    '", "data" : ',
    toJSON(data),
    '}',
    sep=""
  ))
}

format.error <- function(error.type="Terminal", error.code="1", error.message="An unexpected error occured") {
  
  error.message <- gsub("\n", " ", error.message)
  error.message <- gsub('"', "'", error.message)
  
  return(paste('{
    "status"    : "Error",
    "error.data" : {
      "error.type" : "', error.type, '",
      "error.code" : "', error.code, '",
      "error.message" : "', error.message, '"
    }
  }', sep=""))
  
}

