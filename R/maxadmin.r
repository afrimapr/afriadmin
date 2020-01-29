#' return max admin level for a country
#'
#' initialy gadm but could be other sources too
#'
#' #todo vectorise
#'
#' @param country a character vector of country names
#' @param datasource data source, initial default 'gadm'
#'
#'
#' @examples
#'
#' maxlevel <- maxadmin("nigeria")
#'
#' @return integer vector of max admin levels
#' @export

maxadmin <- function(country,
                     datasource = 'gadm') {

  path <- system.file(package="afriadmin","/external")

  # check and convert country names to iso codes
  iso3c <- country2iso(country)

  allfiles <- list.files(path)
  countryfiles <- allfiles[ substr(allfiles,1,3)==iso3c ]
  levs <- as.numeric( substr(countryfiles,8,8) )
  lev_hi <- max(levs)
  lev_hi
}


