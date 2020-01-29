#' conversion from country names to iso3c code
#'
#' #todo vectorise
#'
#' @param country a character vector of country names
#'
#'
#' @examples
#'
#' iso3c <- country2iso("nigeria")
#'
#' @return character vector of iso3c codes
#' @export
#'
country2iso <- function(country) {

  if (nchar(country) > 3)
  {
    iso3c <- countrycode::countrycode(country, origin='country.name', destination='iso3c')
  } else
  {
    #to allow iso3c argument in lower case
    iso3c <- toupper(country)
  }

  iso3c

}




