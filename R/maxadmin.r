#' return max admin level for a country
#'
#' initialy gadm but could be other sources too
#'
#' #todo change this to work on downloads (or save a table)
#' #todo add geoboundaries option
#' #todo vectorise
#'
#' @param country a character vector of country names
#' @param datasource data source, initial default 'gadm'
#'
#'
#' @examples
#'
#' maxlevel <- maxadmin("nigeria", datasource='geoboundaries')
#'
#' @return integer vector of max admin levels
#' @export

maxadmin <- function(country,
                     datasource = 'geoboundaries') {

  #not vectorised yet use these for testing
  #lvls_gadm <- unlist(lapply(afcountries$name[afcountries$iso3c!="ESH"],function(x) maxadmin(x,'gadm')))
  #lvls_geob <- unlist(lapply(afcountries$name[afcountries$iso3c!="ESH"],function(x) maxadmin(x,'geoboundaries')))

  # check and convert country names to iso codes
  iso3c <- country2iso(country)

  if (datasource == 'geoboundaries')
  {
    #initially don't pass geoboundaries type, version or license
    #mostly i think levels are the same across types
    maxlvl <- rgeoboundaries::gb_max_adm_lvl(iso3c)

  } else if (datasource == 'gadm')
  {

    #GADM36SF dataframe from GADMTools package
    #GADM36SF[GADM36SF$LEVEL_0=='Kenya',]
    #ID    LEVEL_0 LEVEL_1 LEVEL_2       LEVEL_3 LEVEL_4 LEVEL_5
    #KEN   Kenya   County  Constituency  Ward
    #to get max admin level, subtract 2 from max column not empty

    countrylevels <- GADM36SF[tolower(GADM36SF$ID)==tolower(iso3c),]

    #maxlvl <- -2 + which(GADM36SF[GADM36SF$LEVEL_0==country,] != "")
    maxlvl <- -2 + max(which(countrylevels != ""))

  }

return(maxlvl)

}


