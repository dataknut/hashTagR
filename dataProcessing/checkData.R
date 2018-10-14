# debugging data
library(hashTagR)
library(data.table)
library(readr)
# some of the tweet extracts appear to be malformed. But which?
hashtags <- c("birdoftheyear", "boty") # a list of the hashtags to search for - see ?search_tweets
searchString <- hashTagR::createSearchFromTags(hashtags)
path <- "~/Data/twitter/"

fileList <- list.files(path = path, pattern = pattern, # use to filter e.g. 1m from 30s files
                       recursive = recursive)

length(fileList)
head(fileList)

if(length(fileList) > 0){
  fListDT <- data.table::as.data.table(fileList)
  fListDT <- fListDT[, fullPath := paste0(path, fileList)]
  for(f in fListDT$fullPath){
    message("Loading ", f)
    tbl <- readr::read_csv(path.expand(f),
                    progress = FALSE) # switch off progress
  }
}