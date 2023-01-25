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
#' @param noisy do we give feedback or not (default = FALSE)
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

loadTweets <- function(path, pattern, noisy = FALSE){
  fileList <- list.files(path = path, pattern = pattern) # assume 
  if(length(fileList) > 0){
    fListDT <- data.table::as.data.table(fileList)
    fListDT <- fListDT[, fullPath := path.expand(paste0(path, fileList))]
    # fread stops mid-way through some files
    # dt <- rbindlist(lapply(fListDT$fullPath, data.table::fread), use.names=TRUE, fill=TRUE) # mega fast but no fancy data type parsing
    dt <- rbindlist(lapply(fListDT$fullPath,
                           function(f)
                             data.table::as.data.table(readr::read_csv(f,
                                                                       progress = FALSE,
                                                                       show_col_types = FALSE) # turn off the message
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
    if(noisy){print(fb)}
    return(dt)
  } else {
    fb <- paste0("Didn't find any files matching ",
                 pattern, " in ",
                 path)
    print(fb) # always print this to flag error
  }
}