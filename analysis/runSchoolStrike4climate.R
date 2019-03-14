# ### ----- About ----
# Master (make) file for documentation
####

# --- load libraries ---
library(hashTagR)

# libs required by this code (.Rmd will call others needed there)
reqLibs <- c("rmarkdown", "bookdown", "rtweet", "lubridate", "data.table")

print(paste0("Loading the following libraries: ", reqLibs))
# Use Luke's function to require/install/load
hashTagR::loadLibraries(reqLibs)

# --- set params ----
projLoc <- hashTagR::findParentDirectory("hashTagR")
hashtag <- "#schoolstrike4climate" # see ?search_tweets - capitals are ignored (I think)
oDfile <- paste0("~/Data/twitter/tw_", hashtag,"_", lubridate::now(),".csv")
ofile <- paste0(projLoc, "/docs/schoolstrike4climate.html")
explHashTag <- 'https://twitter.com/hashtag/schoolstrike4climate' # <- explanatory link for the hashtag
pubUrl <- paste0("https://dataknut.github.io/hashTagR/", ofile) # <- where the results are published
rmdFile <- paste0(projLoc, "/analysis/schoolstrike4climate_Report.Rmd")

refresh <- 0 # 0 to skip data refresh

# --- code ---

if(refresh){
  dt <- hashTagR::saveTweets(hashtag, oDfile)
  message("Retreived ", nrow(dt), " tweets and saved them to ", ofile)
}

rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(hashtag = hashtag, explHashTag = explHashTag, pubUrl = pubUrl),
                  output_file = ofile
)

# construct git commit - fails on UoS RStudio
# cmsg <- paste0("'Latest #schoolstrike4climate data refresh & replot: ", lubridate::now(), "'")
# gc <- paste0("git commit -a -m ", cmsg)
# try(system(gc))
# gpl <- "git pull"
# try(system(gpl))
# gpu <- "git push origin refs/heads/master"
# try(system(gpu))
