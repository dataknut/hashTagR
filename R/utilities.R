#' Get dateTime
#'
#' \code{getRunDateTime} returns a formated run dateTime.
#'
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#'
getRunDateTime <- function(){
  runDate <- paste0(Sys.time(), " (", Sys.timezone(), ")")
  return(runDate)
}

#' Get duration
#'
#' \code{getDuration} takes a timediff created using (e.g.)
#'
#'    startTime <- proc.time()
#'    .....
#'    endTime <- proc.time()
#'    t <- endTime - startTime
#'
#'    and returns a formrated extraction of seconds & minutes for use in feedback.
#'
#' @param t a duration
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#'
getDuration <- function(t){
  elapsed <- t[[3]]
  msg <- paste0(round(elapsed,2),
                     " seconds ( ",
                     round(elapsed/60,2),
                     " minutes)"
  )
  return(msg)
}

#' Tidy long numbers
#'
#' \code{tidyNum} reformats long numbers to include commas and prevents scientific formats
#'
#' @param number an input number or list
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#'
tidyNum <- function(number) {
  format(number, big.mark=",", scientific=FALSE)
}

#' Find the path to Parent Directory
#'
#' Equivalent of \code{findParentDirectory}. Is useful for running a project
#'   across multiple computers where the project is stored in different directories.
#'
#' @param Parent the name of the directory to which the function should track back.
#' Should be the root of the GitHub repository
#'
#' @author Mikey Harper, \email{m.harper@@soton.ac.uk}
#' @export
#'
findParentDirectory <- function(Parent){
  directory <-getwd()
  while(basename(directory) != Parent){
    directory <- dirname(directory)

  }
  return(directory)
}

#' Installs and loads packages
#'
#' \code{loadLibraries} checks whether the package is already installed,
#'   installing those which are not preinstalled. All the libraries are then loaded.
#'
#'   Especially useful when running on virtual machines where package installation
#'   is not persistent (Like UoS sve). It will fail if the packages need to be
#'   installed but there is no internet access.
#'
#'   NB: in R 'require' tries to load a package but throws a warning & moves on if it's not there
#'   whereas 'library' throws an error if it can't load the package. Hence 'loadLibraries'
#'   https://stackoverflow.com/questions/5595512/what-is-the-difference-between-require-and-library
#' @param ... A list of packages
#' @param repo The repository to load functions from. Defaults to "https://cran.rstudio.com"
#' @importFrom  utils install.packages
#'
#' @author Luke Blunden, \email{lsb@@soton.ac.uk} (original)
#' @author Michael Harper \email{m.harper@@soton.ac.uk} (revised version)
#' @export
#'
loadLibraries <- function(..., repo = "https://cran.rstudio.com"){

  packages <- c(...)

  # Check if package is installed
  newPackages <- packages[!(packages %in% utils::installed.packages()[,1])]

  # Install if required
  if (length(newPackages)){utils::install.packages(newPackages, dependencies = TRUE)}

  # Load packages
  sapply(packages, require, character.only = TRUE)
}

#' Tidy long numbers
#'
#' \code{tidyNum} reformats long numbers to include commas and prevents scientific formats,
#'  making them suitable for printing within R Markdown reports and inline text.
#'
#' @param number an input number or list
#'
#' @examples
#' tidyNum(123456789)
#' tidyNum(10^6)
#' tidyNum(c(10^6, 10^7, 10^8))
#'
#' @author Ben Anderson, \email{banderson@@soton.ac.uk}
#' @export
#' @family Utilities

tidyNum <- function(number) {
  format(number, big.mark=",", scientific=FALSE)
}

#' Gzip a file
#'
#' \code{gzipIt} gzips a file, over-writing automatically.
#'
#' @param file file to gzip
#'
#' @author Michael Harper
#' @author Ben Anderson, \email{banderson@@soton.ac.uk}
#' @export
#' @family Utilities

gzipIt <- function(file) {
    # Path of output file
    gz <- paste0(file, ".gz")

    # Gzip it
    # in case it fails (it will on windows - you will be left with a .csv file)
    try(system( paste0("gzip -f '", file,"'"))) # include ' or it breaks on spaces
    message("Gzipped ", file)
}

#' deMacron a string
#'
#' No, \code{deMacron} doesn't remove French politicians. It replaces all examples of macron vowels
#' in a string with the 'anglicised' equivalents. This is useful for analysing
#' strings such as hashtags where users might mix them but we want kakī == kaki for example. Macron
#' vowels are common in Māori - see https://kupu.maori.nz/about/macrons-keyboard-setup
#'
#' @param string string to de-macron
#'
#' @author Ben Anderson, \email{banderson@@soton.ac.uk}
#' @author David Hood
#' @export
#' @family Utilities

deMacron <- function(original){
  # with thanks to https://twitter.com/Thoughtfulnz/status/1047648312810033152
  macron <- c("ā", "ē", "ī", "ō", "ū") # set macron vowels https://kupu.maori.nz/about/macrons-keyboard-setup
  nonMacron <- c("a", "e", "i", "o", "u") # roman equiv
  return(nonMacron[which(original == macron)])
}

#' Report current hardware profile - only works on Linux (not Mac OS X etc)
#'
#'
#' @author Ben Anderson, \email{banderson@@soton.ac.uk}
#' @export
#' @family Utilities

getLinuxMemProfile <- function(){
  system("cat /proc/meminfo")
  system("cat /proc/cpuinfo")
}