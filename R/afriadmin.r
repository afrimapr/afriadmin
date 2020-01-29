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
#' @param datasource data source, initial default 'gadm'
#' @param level whih admin level to return
#' @param plot option to display map 'mapview' for interactive, 'sf' for static
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
                      datasource = 'gadm',
                      level = 'max',
                      plot = 'mapview') {

  #GADM_SF_URL  = "https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_"
  #initially store files directly as downloaded from gadm

  path <- system.file(package="afriadmin","/external")

  # check and convert country names to iso codes
  iso3c <- country2iso(country)

  # find the max admin level available
  # either to check that asked for one is there, or to find max
  maxlevel <- maxadmin(country=iso3c, datasource=datasource)

  if (level=='max')
  {
    level <- maxlevel
    message("returning max admin level available for ",iso3c,", ",maxlevel)
  }
  else if (level > maxlevel)
  {
    warning("max admin level available for ",iso3c," is ",maxlevel," you requested ",level)
    #maybe do this to return most detailed available
    level <- maxlevel
  }

  filename <- paste0(iso3c,'_adm',level,'.sf.rds')

  sf1 <- readRDS(file.path(path, filename))

  # display map if option chosen
  # helps with debugging, may not be permanent

  if (plot == 'mapview') print(mapview::mapview(sf1, zcol=paste0("NAME_",level), legend=FALSE))
  else if (plot == 'sf') plot(sf::st_geometry(sf1))

  return(sf1)
}

