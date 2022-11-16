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
  twDT <- twDT[, ba_created_at_dateTime := lubridate::as_datetime(created_at)] # this will auto-convert to local time
  twDT <- twDT[, ba_created_at_date := lubridate::date(created_at)]
  twDT <- twDT[, ba_created_at_hms := hms::as.hms(created_at)] # this will auto-convert to local time
  twDT <- twDT[, ba_created_at_dateHour := lubridate::floor_date(ba_created_at_dateTime, unit = "hours")] # useful for plots
  
  # twDT <- twDT[, ba_tweetType := "Tweet"] # add tweet type
  # twDT <- twDT[is_retweet == TRUE, ba_tweetType := "Re-tweet"]
  # twDT <- twDT[is_quote == TRUE, ba_tweetType := "Quote"]
  return(twDT)
  
}