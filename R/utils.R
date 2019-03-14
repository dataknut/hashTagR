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

