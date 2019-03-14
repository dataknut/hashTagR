#' Process a raw tweets file
#'
#' \code{processTweets} takes a data.table of tweets returned from the API and read using readTweets
#' 
#'    Removes exact duplicates
#'    
#'    Creates a date and hms from the created_at column
#'    
#'    Returns a cleaned data.table
#'
#' @param dt data.table of tweets to clean
#'
#' @import data.table
#' @import lubridate
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#' @family tweets
#'

processTweets <- function(dt){
  
  twDT <- unique(dt) # drop exact duplicates (only)
  
  twDT <- twDT[, ba_created_at_date := lubridate::date(created_at)]
  twDT <- twDT[, ba_created_at_hms := hms::as.hms(created_at)] # this will auto-convert to local time
  twDT <- twDT[, ba_created_at_dateHour := lubridate::floor_date(created_at, "hour")] # useful for plots
  
  twDT <- twDT[, ba_tweetType := "Tweet"] # add tweet type
  twDT <- twDT[is_retweet == TRUE, ba_tweetType := "Re-tweet"]
  twDT <- twDT[is_quote == TRUE, ba_tweetType := "Quote"]
  return(twDT)
  
}

#' Extract a list of unique hashtags
#'
#' \code{getHashTags} takes a data.table of processed tweets and creates a new table of unique hashtags by created_at
#' 
#'    Returns a data.table
#'
#' @param dt data.table of tweets
#' @param keep a list of the variables to keep. default = c("user_id", "status_id", "screen_name", "created_at", "ba_tweetType", "hashtags")
#'
#' @import data.table
#' @import reshape2
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#' @family tweets
#'

getHashtags <- function(dt, keepVars = c("user_id", "status_id", "screen_name", "created_at", "ba_tweetType", "hashtags")){
  
  wDT <- dt[!is.na(hashtags), .(user_id, status_id, screen_name, created_at, ba_tweetType, hashtags)] # remove any tweets without hashtags. How can there be no hashtags when we searched on hashtags?
  
  # now string split them
  # https://stackoverflow.com/questions/33200179/dynamically-assign-number-of-splits-in-data-table-tstrsplit
  splits <- max(lengths(strsplit(wDT$hashtags, "|", , fixed=T)))
  htDT <- wDT[, paste0("ht", 1:splits) := tstrsplit(hashtags, "|", fixed=T)]
  # reshape the list
  lDT <- reshape2::melt(wDT, id=keepVars)
  # remove NA
  lDT <- lDT[!is.na(value)]
  # clean up
  lDT$hashtag <- lDT$value
  lDT$value <- NULL
  lDT$hashtags <- NULL
  lDT$variable <- NULL
  
  message("We have ", nrow(lDT), " hashtags.")
  message("That's about ~ ", round(nrow(lDT)/nrow(twDT),2), " hashtags per tweet...")
  head(lDT)
  
}