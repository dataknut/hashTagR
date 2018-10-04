## search for 18000 tweets using the hashtag

library(lubridate)
library(data.table)
library(hashTagR)
library(rtweet)

string <- "#birdoftheyear OR #boty" # see ?search_tweets - capitals are ignored (I think)
ofile <- paste0("~/Data/twitter/tw_", string,"_", lubridate::now(),".csv")

botyDT <- hashTagR::saveTweets(string, ofile)

message("Retreived ", nrow(botyDT), " tweets and saved them to ", ofile)
