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
#'   Note that list.files() is recursive by default. This can lead to large search times if you start it at
#'   the top of a file structure. Use wisely.
#'
#' @param path place to look for saved file - gets passed to list.files()
#' @param pattern the pattern to match - passed to list.files()
#' @param recursive use recursively (default = TRUE)
#'
#' @import readr
#' @import data.table
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#' @family tweets
#'

loadTweets <- function(path, pattern, recursive = TRUE){
  fileList <- list.files(path = path, pattern = pattern, # use to filter e.g. 1m from 30s files
                      recursive = recursive)
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
    fb <-paste0("Found ", nrow(fListDT), " files matching ",
                pattern, " in ",
            path)
    print(fb)
    return(data.table::as.data.table(tbl))
  } else {
    fb <- paste0("Didn't find any files matching ",
            string, " in ",
            path)
    print(fb)
  }
}

#' Convert a list of hashtags to a Twitter search string
#' 
#' It's usually easier to keep the hashtags you want to search for in an R list. This function
#' creates a proper API search using the operator you specify.
#' 
#' Do not include # in the list elements as this will be added automatically
#' 
#' @param ht the list of tags created using (e.g.) hashTags <- c("tag1", "tag2")
#' @param op how to combine hashtag strings, default = OR
#'
#' @author Ben Anderson, \email{banderson@@soton.ac.uk}
#' @export
#' @family tweets

createSearchFromTags <- function(ht, op = "OR"){
  if(length(ht) == 0){
    message("Nothing in the hasthtag list")
  } else { # at least 1 hashtag
    ss <- paste0("#",ht[1])
    if(length(ht) > 1){ # at least 2
      for(n in 2:length(ht)){
        ss <- paste0(ss, " ", op, " #", ht[n]) 
      }
    }
    return(ss)
  }
}

