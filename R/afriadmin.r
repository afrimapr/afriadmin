#todo add country outlines for whole continent as single file
#todo maybe if I saved all outlines as a single file it would be easier to subset etc.

#todo add error checking for countries
#todo vectorise iso3c to allow combining countries
#todo maybe vectorise level too

#todo is it good idea to name function same as package ?

#' Get admin polygons
#'
#' returns admin polygons for specified countries and optionally plots map
#'
#' @param country a character vector of country names or iso3c character codes.
#' @param datasource data source, 'geoboundaries' or 'gadm'
#' @param level which admin level to return
#' @param type for geoboundaries, boundary type defaults to 'simple' One of 'HPSCU', 'HPSCGS', 'SSCGS', 'SSCU', or 'precise' 'simple' 'precise standard' 'simple standard'
#'  Determines the type of boundary link you receive. More on details
#' @param version for geoboundaries defaults to the most recent version of geoBoundaries available.
#'  The geoboundaries version requested, with underscores. For example, 3_0_0 would return data
#'  from version 3.0.0 of geoBoundaries.
#' @param path where to save downloaded data for gadm, defaults to tempdir()
#' @param quiet for geoboundaries, if TRUE no message while downloading and reading the data. Default to FALSE
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
                      level = 1, #'max',
                      datasource = 'geoboundaries',
                      type = 'simple',
                      version = NULL,
                      path = tempdir(),
                      quiet = FALSE,
                      plot = 'mapview') {


  # check and convert country names to iso codes
  iso3c <- country2iso(country)

  # temporarily commented out max level checking
  # find the max admin level available
  # either to check that asked for one is there, or to find max
  # maxlevel <- maxadmin(country=iso3c, datasource=datasource)
  #
  # if (level=='max')
  # {
  #   level <- maxlevel
  #   message("returning max admin level available for ",iso3c,", ",maxlevel)
  # }
  # else if (level > maxlevel)
  # {
  #   warning("max admin level available for ",iso3c," is ",maxlevel," you requested ",level)
  #   #maybe do this to return most detailed available
  #   level <- maxlevel
  # }


  #different datasources

  if (datasource == 'geoboundaries')
  {

    if (!requireNamespace("rgeoboundaries", quietly = TRUE)) {
      stop("Package \"rgeoboundaries\" needed. You can install it by : remotes::install_gitlab(\"dickoa/rgeoboundaries\")",
           call. = FALSE)
    }

    #convert simplified codes to geoboundaries ones
    if      (type=='simple') type <- 'SSCU'
    else if (type=='simple standard') type <- 'SSCGS'
    else if (type=='precise') type <- 'HPSCU'
    else if (type=='precise standard') type <- 'HPSCGS'

    sf1 <- rgeoboundaries::geoboundaries(iso3c, adm_lvl = paste0('adm',level), type = type, version = version)

  }

  else if (datasource == 'gadm')
  {
    # #when I had data saved in the package
    # path <- system.file(package="afriadmin","/external")
    # filename <- paste0(iso3c,'_adm',level,'.sf.rds')
    # sf1 <- readRDS(file.path(path, filename))

    # option to set path= to save downloaded file
    # TODO look at caching option similar to what rgeoboundaries does
    sf1 <- raster::getData('GADM', country=country, level=level, path=path, download=TRUE, type='sf') #, version=3.6

  }


  # display map if option chosen
  # helps with debugging, may not be permanent

  if (plot == 'mapview')
  {
    zcol <- switch(datasource,
                   'geoboundaries' = 'shapeName',
                   'gadm' = paste0("NAME_",level) )

    print(mapview::mapview(sf1, zcol=zcol, legend=FALSE))
  }

  else if (plot == 'sf') plot(sf::st_geometry(sf1))

  return(sf1)
}

