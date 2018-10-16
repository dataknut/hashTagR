# repeated Twitter API searches can produce duplicates
# This script creates a 'final' dataset of unique rows of data.

# Note that this may include repeated tweet IDs because twitter data is dynamic - the re-tweeted
# attritbutes may change over time (for example)

library(data.table)
library(readr)
library(hashTagR)
library(myUtils)

# some of the tweet extracts appear to be malformed. But which?
hashtags <- c("birdoftheyear", "boty") # a list of the hashtags to search for - see ?search_tweets
searchString <- hashTagR::createSearchFromTags(hashtags)
path <- "~/Data/twitter/boty2018/"

message("Load from pre-collected data")

raw_twDT <- hashTagR::loadTweets(path, searchString) # we like data.tables


rn <- nrow(raw_twDT)
twDT <- unique(raw_twDT) # drop any exact duplicates
un <- nrow(twDT)

message("Retained ", myUtils::tidyNum(un), " unique tweets of the ", myUtils::tidyNum(rn) , " downloaded" )

message("There are ",  myUtils::tidyNum(uniqueN(twDT$status_id)), " unique status_ids in this dataset")

message("If there are more unique status_ids than tweets then we have duplicated tweets. This is usually because the tweet id record has been updated in some way")

oFile <- path.expand(paste0(path, searchString, "_unique.csv")) # set output file name

data.table::fwrite(twDT, oFile) # save data
cmd <- paste0("gzip -f '", oFile,"'")

try(system(cmd)) # include ' or it breaks on spaces

#myUtils::gzipIt(oFile)




