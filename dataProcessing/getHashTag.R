## search for n tweets using the hashtag

library(lubridate)
library(data.table)
library(hashTagR)
library(rtweet)

string <- "#schoolstrike4climate"
# "#birdoftheyear OR #boty" # see ?search_tweets - capitals are ignored (I think)

# set up access tokens
source(path.expand("˜/twitterAuthHashTagR.R"))

ofile <- paste0("~/Data/twitter/tw_", string,"_", lubridate::now(),".csv")

tweetsDT <- hashTagR::saveTweets(string, ofile, n = 20000)

message("Retreived ", nrow(tweetsDT), " tweets and saved them to ", ofile)
