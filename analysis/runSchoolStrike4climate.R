# ### ----- About ----
# Master (make) file for documentation
####

# --- load libraries ---
library(hashTagR)
library(dkUtils)

# libs required by this code (.Rmd will call others needed there)
reqLibs <- c("rmarkdown", "bookdown", "rtweet", "lubridate", "data.table")

print(paste0("Loading the following libraries: ", reqLibs))
# Use Luke's function to require/install/load
dkUtils::loadLibraries(reqLibs)

# --- set params ----
projLoc <- dkUtils::findParentDirectory("hashTagR")
refresh <- 1 # 0 to skip data refresh
goGit <- 0 # 0 to skip git commit - breaks on UoS RStudio

projLoc <- myUtils::findParentDirectory("hashTagR") # <- project location

# XX things you need to edit ----

hashtags <- c("schoolstrike4climate") # a list of the hashtags to search for - see ?search_tweets
ofile <- "schoolStrike4Climate_Report.html" # <- html output file
explHashTag <- paste0("https://www.schoolstrike4climate.com/") # <- explanatory link for the hashtag

# XX end of things you need to edit ----

# do not edit anything below this ----

# > create search string ----
searchString <- hashTagR::createSearchFromTags(hashtags)

# > set input/output files ----
rmdFile <- paste0(projLoc, "/analysis/genericHashTagReport.Rmd") # <- the Rmd code to render
pubUrl <- paste0("https://dataknut.github.io/hashTagR/", ofile) # <- where the results are published


# > run the data refresh if set ----

if(refresh){
  oDfile <- paste0("~/Data/twitter/tw_", searchString,"_", lubridate::now(),".csv") # <- data file
  dt <- hashTagR::saveTweets(searchString, oDfile)
  message("Retreived ", nrow(dt), " tweets and saved them to ", oDfile)
}

# > render rmd ----
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(hashTags = hashtags, 
                                searchString = searchString,
                                explHashTag = explHashTag, 
                                pubUrl = pubUrl),
                  output_file = paste0(projLoc, "/docs/", ofile)
)

# > comit & push to git if set ----

if(goGit){
  # construct git commit
  cmsg <- paste0("'Latest #", searchString ," data refresh & replot: ", lubridate::now(), "'")
  gc <- paste0("git commit -a -m ", cmsg)
  try(system(gc))
  gpl <- "git pull"
  try(system(gpl))
  gpu <- "git push origin refs/heads/master"
  try(system(gpu))
}