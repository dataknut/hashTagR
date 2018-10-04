#' Sends a DM from the app
#'
#' \code{sendDM} takes a string and matches it to recent tweets
#'
#' Puts the results into a tbl and saves it to ofile. Returns the tbl for further fun.
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
#'
sendDM <- function(text,user){
  rtweet::post_message(text, user, media = NULL, token = NULL)
}
