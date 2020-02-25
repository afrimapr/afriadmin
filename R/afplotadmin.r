#' plot admin levels
#'
#' *in progress
#' aim to plot admin levels for a single country
#' either on same map or facetted
#' to make it easier to see the structure
#'
#' @param country a character vector of country names or iso3c character codes.
#' @param datasource data source, initial default 'gadm'
#' @param addcontext whether to plot neighbouring countries as well
# @param level which admin level to return
# @param plot option to display map 'mapview' for interactive, 'sf' for static
#'
#'
# @examples
# afplotadmin('nigeria')
#'
#' @return \code{sf}
#' @export
#'
afplotadmin <- function(country,
                      #level = 'max',
                      datasource = 'gadm',
                      addcontext = FALSE ) {
                      #plot = 'mapview') {


# TODO if I want to facet, I'll need to use ggplot or tmap


  data("afcountries")
  data("sf_af_gadm0")

  # check and convert country names to iso codes
  iso3c <- country2iso(country)


  countrynum <- which(afcountries$iso3c==iso3c)
  name <- afcountries$name[countrynum]
  maxlevel <- maxadmin(iso3c, datasource='gadm')


    #cat(name," ",iso3c," levels=",maxlevel,"\n")

    #reverse order so lower levels don't get overpainted
    for(level in maxlevel:0)
    {
      sflevel <- afriadmin(iso3c, level=level, datasource='gadm', plot=FALSE)

      #todo allow all admin boundaries to be saved in a single sf object
      #will need to rationalise column numbers and names
      #for gadm there are diff num columns ac/to level
      #so how does GADMTools rbind them ?
      #i think GADMTools only allows loading a single level across multiple countries
      #so it doesn't solve that issue


      #sf plot options to allow adding multiple layers
      #if addcontext don't reset on last layer
      reset <- ifelse(level==0 & !addcontext ,TRUE,FALSE)
      add   <- ifelse(level==maxlevel,FALSE,TRUE)
      #just add title to first
      main   <- ifelse(level==maxlevel,name,'')
      #border colour according to level
      border <- switch(as.character(level),
                       '0' = 'black', #'darkblue'
                       '1' = 'darkgreen', #'darkmagenta',
                       '2' = 'darkorange', #'blue',
                       '3' = 'yellow')

      plot(sf::st_geometry(sflevel), reset=reset, add=add, border=border, main=main)
    }


    if (addcontext)
    {
      #add africa countries outlines for context
      plot(sf::st_geometry(sf_af_gadm0), reset=FALSE, add=TRUE, border='grey',lwd=2)
      #replot adm0 to avoid overplotting
      plot(sf::st_geometry(sflevel), reset=TRUE, add=TRUE, border=border, main=main)
    }


}
