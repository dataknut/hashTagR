## search for 18000 tweets using the hashtag

library(lubridate)
library(data.table)
library(hashTagR)
library(rtweet)

string <- "#schoolstrike4climate"
# "#birdoftheyear OR #boty" # see ?search_tweets - capitals are ignored (I think)

# set up access tokens
source("˜/twitterAuthHashTagR.R")

ofile <- paste0("~/Data/twitter/tw_", string,"_", lubridate::now(),".csv")

tweetsDT <- hashTagR::saveTweets(string, ofile)

message("Retreived ", nrow(tweetsDT), " tweets and saved them to ", ofile)
