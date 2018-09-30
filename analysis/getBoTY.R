## search for 18000 tweets using the hashtag

library(lubridate)
library(data.table)
library(hashTagR)

string <- "#birdoftheyear OR #boty" # see ?search_tweets - capitals are ignored (I think)
ofile <- paste0("~/Data/twitter/tw_", string,"_", lubridate::today(),".csv")

botyDT <- hashTagR::saveTweets(string, ofile)

skimr::skim(botyDT)

message("Retreived ", nrow(botyDT), " tweets and saved them to ", ofile)
