#' Gets tweets that match a given string
#'
#' \code{getTweets} takes a string and matches it to recent tweets. It includes retweets.
#'
#' Puts the results into a data.table and returns the data.table for further fun.
#'
#' @param string the string to look for
#' @param ofile file to save to
#' @param n number of tweets, default = 18000 (see https://github.com/mkearney/rtweet)
#'
#' @import rtweet
#' @import data.table
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#' @family tweets
getTweets <- function(string, n = 18000){
  message("Looking for: ", string)
  t <- rtweet::search_tweets(
    string, n = n, include_rts = TRUE
  )
  dt <- data.table::as.data.table(t)
  message("Found ", nrow(dt), " tweets")
  # data.table::fwrite(dt, ofile)
  # hashTagR::gzipIt(ofile) # gzip the file (readr::read_csv can handle .gz files)
  return(dt)
}

