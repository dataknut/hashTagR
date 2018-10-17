# Analysis for Forest & Bird
# Request from Kimberly Collins
library(data.table)
library(readr)
library(lubridate)
library(hashTagR)
library(myUtils)

# some of the tweet extracts appear to be malformed. But which?
hashtags <- c("birdoftheyear", "boty") # a list of the hashtags to search for - see ?search_tweets
searchString <- hashTagR::createSearchFromTags(hashtags)
path <- "~/Data/twitter/boty2018/"
timeZone <- "Pacific/Auckland"

message("Load from pre-collected data")

iFile <- path.expand(paste0(oPath, searchString, "_uniqueTweets.csv.gz")) # set input file name to saved data

origDT <- data.table::as.data.table(readr::read_csv(iFile))

origDT <- origDT[, created_at_local := lubridate::with_tz(created_at, tzone = timeZone)] # beware - running this outside NZ will lead to strange graphs

# If we just select the period from 29/9/2018 to 16/10/2018:

dt <- origDT[lubridate::date(created_at_local) >= "2018-09-29" &
             lubridate::date(created_at_local) <= "2018-10-16"]

message(tidyNum(nrow(dt)), " tweets (including ", 
        tidyNum(nrow(dt[is_quote == "TRUE"])), " quotes and ",
        tidyNum(nrow(dt[is_retweet == "TRUE"])), " re-tweets) from ", 
        tidyNum(uniqueN(dt$screen_name)), " tweeters")

# table of hashtag mentions per day
dailyHtDT <- origDT[, .(count = .N), keyby = .(lubridate::date(created_at_local))]
oFile <- path.expand(paste0(path, "extracts/", searchString, "_hashTagsByNZDate.csv")) # set output file name

data.table::fwrite(dailyHtDT, oFile) # save data