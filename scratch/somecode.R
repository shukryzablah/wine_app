require(mosaic)
directory <- "../poems-processed"

files <- list.files(directory)
n <- length(files)

index <- c(1:n)

getTitle <- function(index) {
  lines <- readLines(paste(directory, "/", files[index], sep=""))
  return(toString(lines[3]))
}

title <- character(length(index))

for (i in 1:length(index)) {
  title[i] <- getTitle(i)
}


df <- data.frame(index, files, title)

save(df, file = "titledata.rda")

