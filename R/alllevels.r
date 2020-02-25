#' get all admin levels into a single object
#'
#' *in progress
#'
#' @param country a character vector of country names or iso3c character codes.
#' @param datasource data source, initial default 'gadm'
# @param level which admin level to return
#' @param plot option to display map 'mapview' for interactive, 'sf' for static
#'
#'
# @examples
# sfall <- alllevels('nigeria')
#'
#' @return \code{sf}
#' @export
#'
alllevels <- function(country,
                        #level = 'max',
                        #datasource = 'gadm') {
                        datasource = 'gadm',
                        plot = 'tmap') {


  # TODO if I want to facet, I'll need to use ggplot or tmap


  data("afcountries")

  # check and convert country names to iso codes
  iso3c <- country2iso(country)

  countrynum <- which(afcountries$iso3c==iso3c)
  name <- afcountries$name[countrynum]
  maxlevel <- maxadmin(iso3c, datasource='gadm')

  #first go at creating an all level object
  #sfall <- data.frame(name=NULL,level=NULL,geometry=NULL)

  #cat(name," ",iso3c," levels=",maxlevel,"\n")

  for(level in 0:maxlevel)
  {
    sflevel <- afriadmin(iso3c, level=level, datasource='gadm', plot=FALSE)

    #todo allow all admin boundaries to be saved in a single sf object
    #will need to rationalise column numbers and names
    #for gadm there are diff num columns ac/to level
    #so how does GADMTools rbind them ?
    #i think GADMTools only allows loading a single level across multiple countries
    #so it doesn't solve that issue

    #i think this may be useful
    #just retaining 3 columns for level, name and the geometry
    #it does mean that lose some potential, e.g. to identify parents
    #should maybe generalise this creation process for other data sources

    #if level0, take the 3 column object rename first 2 columns
    #from "GID_0"    "NAME_0"   "geometry"
    if (level==0)
    {
      sfall <- sflevel
      names(sfall) <- c('level','name','geometry')
      sfall$level <- 0

    } else
    {
      #for higher levels want to
      #select just the name and geometry columns
      #and one more that I can use to put level in
      sftobind <- sflevel[,c(1,which(names(sflevel)==paste0("NAME_",level)
                                   | names(sflevel)=='geometry')) ]
      names(sftobind) <- c('level','name','geometry')
      sftobind$level <- level

      sfall <- rbind(sfall,sftobind)
    }
  } #end of levels loop

  #temporary plotting levels as facets with tmap
  if (plot == 'tmap')
  {

    if (!requireNamespace("tmap", quietly = TRUE)) {
      stop("Package \"tmap\" needed for this plotting. Please install from CRAN.",
           call. = FALSE)
    }

    print(tmap::tm_shape(sfall) + tm_polygons() + tm_facets(by="level"))
  }


  sfall
}
