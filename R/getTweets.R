#' Gets tweets that match a given string and stores them
#'
#' \code{saveTweets} takes a string and matches it to recent tweets
#'
#' Puts the results into a data.table and saves it to ofile using data.table::fwrite (very fast). Gzips the file.
#'
#' Returns the data.table for further fun.
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
saveTweets <- function(string,ofile, n = 18000){
  message("Looking for: ", string)
  t <- rtweet::search_tweets(
    string, n = n, include_rts = TRUE
  )
  dt <- data.table::as.data.table(t)
  data.table::fwrite(dt, ofile)
  #hashTagR::gzipIt(ofile) # gzip the file (readr::read_csv can handle .gz files)
  return(dt)
}

#' Loads tweets that match a given search string from a pre-saved file
#'
#' \code{loadTweets} takes a string and loads all files in a given path which have this name using readr
#'
#'   If no matches, returns nothing but gives feedback.
#'
#'   If there are matches, rbinds them all into a tbl, gives feedback and returns the tbl as a data.table
#'   for further fun.
#'
#'   Note that list.files() is NOT recursive so it will search only in the path given.
#'
#' @param path place to look for saved file - gets passed to list.files()
#' @param pattern the pattern to match - passed to list.files()
#'
#' @import readr
#' @import data.table
#' @import R.utils
#' @import bit64
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#' @family tweets
#'

loadTweets <- function(path, pattern){
  fileList <- list.files(path = path, pattern = pattern) # assume 
  if(length(fileList) > 0){
    fListDT <- data.table::as.data.table(fileList)
    fListDT <- fListDT[, fullPath := path.expand(paste0(path, fileList))]
    # fread stops mid-way through some files
    # dt <- rbindlist(lapply(fListDT$fullPath, data.table::fread), use.names=TRUE, fill=TRUE) # mega fast but no fancy data type parsing
    dt <- rbindlist(lapply(fListDT$fullPath,
                            function(f)
                              data.table::as.data.table(readr::read_csv(f,
                                                                        progress = FALSE)
                                                        )
                            ), fill = TRUE
                     )
    # memory issue?
    # tbl <- do.call(rbind,
    #                lapply(fListDT$fullPath,
    #                       function(f)
    #                         readr::read_csv(f,
    #                                         progress = FALSE) # switch off progress
    # 
    #                )
    # )
    fb <-paste0("Found ", nrow(fListDT), " files matching ",
                pattern, " in ",
            path)
    print(fb)
    return(dt)
  } else {
    fb <- paste0("Didn't find any files matching ",
                 pattern, " in ",
            path)
    print(fb)
  }
}