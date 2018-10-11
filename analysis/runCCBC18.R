# ### ----- About ----
# Master (make) file for documentation
####

# --- load libraries ---
library(myUtils)

# libs required by this code (.Rmd will call others needed there)
reqLibs <- c("rmarkdown", "bookdown", "rtweet", "lubridate", "data.table", "hashTagR")

print(paste0("Loading the following libraries: ", reqLibs))
# Use Luke's function to require/install/load
myUtils::loadLibraries(reqLibs)

# --- set params ----
refresh <- 1 # 0 to skip data refresh
goGit <- 1 # 0 to skip git commit

projLoc <- myUtils::findParentDirectory("hashTagR") # <- project location
hashtags <- c("edsclimatechat","ccbc18", "ccbc2018") # a list of the hashtags to search for - see ?search_tweets
searchString <- hashTagR::createSearchFromTags(hashtags)

oDfile <- paste0("~/Data/twitter/tw_", searchString,"_", lubridate::now(),".csv") # <- data file
ofile <- paste0(projLoc, "/docs/ccbc2018.html") # <- html output file
explHashTag <- "www.climateandbusiness.com" # <- explanatory link for the hashtag
pubUrl <- paste0("https://dataknut.github.io/hashTagR/", ofile) # <- where the results are published
rmdFile <- paste0(projLoc, "/analysis/genericHashTagReport.Rmd") # <- the Rmd code to render


# --- code ---

if(refresh){
  dt <- hashTagR::saveTweets(searchString, oDfile)
  message("Retreived ", nrow(dt), " tweets and saved them to ", oDfile)
}

rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(hashTags = hashtags, 
                                searchString = searchString,
                                explHashTag = explHashTag, 
                                pubUrl = pubUrl),
                  output_file = ofile
)

if(goGit){
  # construct git commit
  cmsg <- paste0("'Latest #ccbc2018 data refresh & replot: ", lubridate::now(), "'")
  gc <- paste0("git commit -a -m ", cmsg)
  try(system(gc))
  gpl <- "git pull"
  try(system(gpl))
  gpu <- "git push origin refs/heads/master"
  try(system(gpu))
}
