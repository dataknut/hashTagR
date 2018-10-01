#' Gets tweets that match a given string and stores them
#'
#' \code{saveTweets} takes a string and matches it to recent tweets
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
saveTweets <- function(string,ofile, n = 18000){
  message("Looking for: ", string)
  t <- rtweet::search_tweets(
    string, n = n, include_rts = TRUE
  )
  dt <- data.table::as.data.table(t)
  data.table::fwrite(dt, ofile)
  return(dt)
}

#' Loads tweets that match a given search string from a pre-saved file
#'
#' \code{loadTweets} takes a string and loads all files in a given path which have this name using readr
#'
#'   Assumes (but checks) files were previously created using saveTweets
#'
#'   Puts the results into a tbl and returns them.
#'
#' @param path place to look for saved file - gets passed to readr::read_csv so can be anything read_csv can readr :-)
#' @param string the string to look for
#'
#' @import readr
#' @import data.table
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#'

loadTweets <- function(path, string){
  fileList <- list.files(path = path, pattern = string, # use to filter e.g. 1m from 30s files
                      recursive = TRUE)
  if(length(fileList) > 0){
    fListDT <- data.table::as.data.table(fileList)
    fListDT <- fListDT[, fullPath := paste0(path, fileList)]
    tbl <- do.call(rbind,
                   lapply(fListDT$fullPath,
                          function(f)
                            readr::read_csv(path.expand(f),
                                            progress = FALSE) # switch off progress

                   )
    )
    return(tbl)
  } else {
    message("Didn't any files matching ",
            string, " in ",
            path)
  }
}
