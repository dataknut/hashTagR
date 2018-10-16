# Analysis for Forest & Bird
# Request from Kimberly Collins
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

# If we just select the period from 29/9/2018 to 16/10/2018:

dt <- twDT[lubridate::date(created_at_local) >= "2018-09-29" &
             lubridate::date(created_at_local) <= "2018-10-16"]

message(tidyNum(nrow(dt)), " tweets (including ", 
        tidyNum(nrow(dt[is_quote == "TRUE"])), "quotes and ",
        tidyNum(nrow(dt[is_retweet == "TRUE"])), " re-tweets) from", 
        tidyNum(uniqueN(dt$screen_name)), " tweeters")

# table of hashtag mentions per day
twDT <- twDT[, created_at_local := lubridate::with_tz(created_at, tzone = timeZone)] # beware - running this outside NZ will lead to strange graphs
twDT <- twDT[, ba_obsDateLocal := lubridate::date(created_at_local)]
twDT <- twDT[, ba_obsTimeLocal := hms::as.hms(created_at)] # this will auto-convert to local time
dailyHtDT <- twDT[, .(count = .N), keyby = .(ba_obsDateLocal)]
oFile <- path.expand(paste0(path, searchString, "_hashTagsByNZDate.csv")) # set output file name

data.table::fwrite(dailyHtDT, oFile) # save data