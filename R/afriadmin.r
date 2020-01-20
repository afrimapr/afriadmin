#todo add country outlines for whole continent as single file
#todo maybe if I saved all outlines as a single file it would be easier to subset etc.

#todo allow countrynames as well as iso3
#todo add error checking for countries
#todo vectorise iso3c to allow combining countries
#todo maybe vectorise level too

#todo is it good idea to name function same as package ?

#' Get admin polygons
#'
#' returns admin polygons for specified countries and optionally plots map
#'
#' @param country a character vector of country names or iso3c character codes.
#' @param level whih admin level to return
#' @param plot whether to display map
#'
#'
#' @examples
#'
#' sfnga2 <- afriadmin("nigeria", level=2)
#'
#' @return \code{sf}
#' @export
#'
afriadmin <- function(country,
                      level = 'max',
                      plot = TRUE) {

  #GADM_SF_URL  = "https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_"
  #initially store files directly as downloaded from gadm

  path <- system.file(package="afriadmin","/external")

  # check and convert country names to iso codes
  iso3c <- country2iso(country)

  # find the max admin level available
  # either to check that asked for one is there, or to find max
  maxlevel <- maxadmin(country=iso3c)

  if (level=='max')
  {
    level <- maxlevel
    message("returning max admin level available for ",iso3,", ",maxlevel)
  }
  else if (level > maxlevel)
  {
    warning("max admin level available for ",iso3," is ",maxlevel," you requested ",level)
    #maybe do this to return mot detailed available
    level <- maxlevel
  }

  filename <- paste0(iso3c,'_adm',level,'.sf.rds')

  # path <- system.file(package="afriadmin")
  # sf1 <- readRDS(file.path(path, "external/", filename))

  sf1 <- readRDS(file.path(path, filename))

  # display map if option chosen
  # helps with debugging, may not be permanent
  #if (plot) plot(sf::st_geometry(sf1))

  if (plot) print(mapview::mapview(sf1, zcol=paste0("NAME_",level), legend=FALSE))

  return(sf1)
}


#initial conversion from country names
#todo vectorise
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


# return max admin level for a country
# initialy gadm but could be other sources too
# todo should be vectorised
maxadmin <- function(country) {

  path <- system.file(package="afriadmin","/external")

  # check and convert country names to iso codes
  iso3c <- country2iso(country)

  allfiles <- list.files(path)
  countryfiles <- allfiles[ substr(allfiles,1,3)==iso3c ]
  levs <- as.numeric( substr(countryfiles,8,8) )
  lev_hi <- max(levs)
  lev_hi
}


