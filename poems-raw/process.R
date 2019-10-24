# Process Emily Dickinson Project Gutenberg corpus
# Nicholas Horton, nhorton@amherst.edu   October 20, 2014
location = "../app/poems-processed"
if (!file.exists(location)) {
  dir.create(location)
}

processDickinson = function(source="gutenberg1.txt") {
  ds = readLines(source)
  prefix = source
  poemnum = 1
  counter = 0
  sink(file=paste(location, "/", prefix, sprintf("%03d", poemnum), sep=""))
  for (i in 1:length(ds)) {
    if (ds[i] != "") {   # non blank text
      counter = 0     # reset counter
      cat(ds[i], "\n")  # display line
    } else if (counter <= 3) {  # not yet a poem break
      counter = counter + 1  # add one more line
      cat(ds[i],"\n")  # and display text
    } else {  # must be a new poem!
      # new poem
      poemnum = poemnum+1
      counter = 0
      sink()
      sink(file=paste(location, "/", prefix, sprintf("%03d", poemnum), sep=""))
    }
  }
  sink()
}

download.file("http://www.amherst.edu/~nhorton/Dickinson/gutenberg1.txt", "gutenberg1.txt")
download.file("http://www.amherst.edu/~nhorton/Dickinson/gutenberg2.txt", "gutenberg2.txt")
download.file("http://www.amherst.edu/~nhorton/Dickinson/gutenberg3.txt", "gutenberg3.txt")

processDickinson("gutenberg1.txt")
processDickinson("gutenberg2.txt")
processDickinson("gutenberg3.txt")

