# debugging data
library(hashTagR)
library(data.table)
library(readr)

hashtags <- c("birdoftheyear", "boty") # a list of the hashtags to search for - see ?search_tweets
searchString <- hashTagR::createSearchFromTags(hashtags)
path <- "~/Data/twitter/boty2018/"
iPath <- path.expand(paste0(path, "raw/"))
timeZone <- "Pacific/Auckland"

fileList <- list.files(path = iPath, pattern = searchString, # use to filter e.g. 1m from 30s files
                       recursive = FALSE)

length(fileList)
head(fileList)

message("Number of data files: ", length(fileList))

# this code checks the files all load OK

if(length(fileList) > 0){
  fListDT <- data.table::as.data.table(fileList)
  fListDT <- fListDT[, fullPath := path.expand(paste0(iPath, fileList))]
  fListDT$nRow <- NA
  fListDT$nCol <- NA
  nTweets <- 0
  for(f in fListDT$fullPath){
    message("Loading ", f)
    dt <- data.table::as.data.table(readr::read_csv(f,
                    progress = FALSE)) # switch off progress
    fListDT <- fListDT[fullPath == f, nRow := nrow(dt)]
    fListDT <- fListDT[fullPath == f, nCol := ncol(dt)]
    nTweets <- nTweets + nrow(dt)
    message("N rows:", nrow(dt))
    message("N cols:", ncol(dt))
    message("Loaded OK")
  }
  message("N tweets: ", nTweets)
}

# this code uses the function to load them
raw_twDT <- hashTagR::loadTweets(iPath,searchString)
# process them
twDT <- hashTagR::processTweets(raw_twDT)
