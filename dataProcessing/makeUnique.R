# repeated Twitter API searches can produce duplicates
# This script creates a 'final' dataset of unique rows of data.

# Note that this may include repeated tweet IDs because twitter data is dynamic - the re-tweeted
# attritbutes may change over time (for example)

library(data.table)
library(readr)
library(hashTagR)
library(myUtils)


hashtags <- c("birdoftheyear", "boty") # a list of the hashtags to search for - see ?search_tweets
searchString <- hashTagR::createSearchFromTags(hashtags)
path <- "~/Data/twitter/boty2018/"
iPath <- path.expand(paste0(path, "raw/"))
oPath <- path.expand(paste0(path, "extracts/"))

message("Load from pre-collected data stored in ", iPath ," using: ", searchString)

# this code uses the function to load them
raw_twDT <- hashTagR::loadTweets(iPath,searchString)

# process them
twDT <- hashTagR::processTweets(raw_twDT)

message("Retained ", myUtils::tidyNum(nrow(twDT)), " unique search results of the ", 
        myUtils::tidyNum(nrow(raw_twDT)) , " downloaded" )

# save unique search results ----
oFile <- path.expand(paste0(oPath, searchString, "_noDups.csv")) # set output file name

data.table::fwrite(twDT, oFile) # save data
cmd <- paste0("gzip -f '", oFile,"'")

try(system(cmd)) # include ' or it breaks on spaces

# save the unique set of tweets (ignoring dynamic attributes such as likes etc) ----
utwDT <- unique(twDT, by = c("status_id") ) # drop duplicates

oFile <- path.expand(paste0(oPath, searchString, "_uniqueTweets.csv")) # set output file name

data.table::fwrite(utwDT, oFile) # save data
cmd <- paste0("gzip -f '", oFile,"'")

try(system(cmd)) # include ' or it breaks on spaces

message("Done")