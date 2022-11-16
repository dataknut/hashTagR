## generic search for n tweets using the hashtag and save the results

library(hashTagR) # this package

library(lubridate)
library(data.table)
library(readr)
library(rtweet)

string <- "#SavingSessions"
# "#birdoftheyear OR #boty" # see ?search_tweets - capitals are ignored (I think)

# set up access tokens
#source(path.expand("˜/twitterAuthHashTagR.R")) # why does source fail to find the file?

path <- "~/Dropbox/data/twitter/" # set this to whatever works for you

if(dir.exists(path)){
  ofile <- path.expand(paste0(path, "tw_", string,"_", lubridate::now(),".csv"))
  tweetsDT <- hashTagR::getTweets(string, n = 20000) # calls rtweet::search_tweets & returns a data.table
  #data.table::fwrite(tweetsDT, file = ofile) # data.table doesn't like the listy bits 
  readr::write_csv(tweetsDT, file = ofile) # works but mangles the list columns (such as 'entitites') 
  # rtweet::save_as_csv(tweetsDT, file_name = ofile) #  seems to be deprecated
  message("Retreived ", nrow(tweetsDT), " tweets and saved them to ", ofile)
} else {
  message("Data path not found")
}

# now load all the tweet files we have matching that string

dt <- hashTagR::loadTweets(path = path,
                           pattern = string)

u_dt <- hashTagR::processTweets(dt) # process & make unique

# hashtags are found in entities$hashtags
