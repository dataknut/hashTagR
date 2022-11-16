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
  lDT <- data.table::melt(wDT, id=keepVars)
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