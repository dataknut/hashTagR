# ### ----- About ----
# Master (make) file for documentation
####

library(hashTagR)

# libs required by this code (.Rmd will call others needed there)
reqLibs <- c("rmarkdown", "bookdown")

print(paste0("Loading the following libraries: ", reqLibs))
# Use Luke's function to require/install/load
hashTagR::loadLibraries(reqLibs)

# default code location - needed to load functions & parameters correctly so
projLoc <- hashTagR::findParentDirectory("hashTagR")

refresh <- 1 # 0 to skip data refresh

if(refresh){
  # grab the recent data & add to what we've saved before
  source(paste0(projLoc, "/dataProcessing/getBoTY.R"))
}

# --- Overview report ----
hashtag <- '#birdoftheyear OR #boty' # <- for a different string just edit this & re-run
rmdFile <- paste0(projLoc, "/analysis/birdOfTheYear2018.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(hashtag = hashtag),
                  output_file = paste0(projLoc,"/docs/birdOfTheYear2018.html")
)
