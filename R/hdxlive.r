#' first go at interacting with hdx itos live admin layers
#' from https://github.com/SimonbJohnson/cod_topo
#'
#' NOTE I changed ZBM to ZMB for Zambia
#'
#' start by checking whether I can open a few geojson files copied across
#'
#'
#'
#' @param country a character vector of country names
#' @param level which admin level to return
#' @param colr_hdx colour for hdx boundaries in plots defaults blue semi-transparent
#' @param colr_gadm colour for gadm boundaries in plots defaults red semi-transparent
#' @param plot option to display map 'mapview' for interactive, 'sf' for static, 'compare' to sf compare with gadm
#'
#' @examples
#'
#' hdxlive("angola")
#' hdxlive('benin',level=2)
#' hdxlive('zimbabwe',level=2)
#'
#' @return not sure yet
#' @export
#'
hdxlive <- function(country,
                    level = 2,
                    colr_hdx = rgb(0,0,1,alpha=0.4),
                    colr_gadm = rgb(1,0,0,alpha=0.4),
                     plot = 'compare') {
                     #plot = 'mapview') {
                     #plot = 'sf') {


  #warning('hdxlive still in development')

  if (!requireNamespace("geojsonsf", quietly = TRUE)) {
    stop("Package \"geojsonsf\" needed for this function to work. Please install it from github.",
         call. = FALSE)
  }

  iso3clow <- tolower(country2iso(country))

  #iso3clow <- 'ago'
  #iso3clow <- 'mli'
  #level <- 2

  path <- system.file(package="afriadmin",paste0("external/hdxlive/",iso3clow,"/",level))

  #TODO add check whether the asked for level and country exist

  filename <- paste0('geom.geojson') #also a geom_modified.geojson for most countries except Comoros COM
  #filename <- paste0('geom_modified.geojson') #also a geom.geojson

  #TODO accents currently seem to get messed up
  #using geom_modified doesn't fix it

  #library(geojsonsf)

  sflayer <- geojsonsf::geojson_sf( file.path(path, filename) )

  # later read layer using layername
  # this relies on all country layers having adm* in their names
  #layername <- mlayers$name[ grep(paste0("adm",level),mlayers$name) ]

  #test plotting
  #plot(sf::st_geometry(sflayer))

  # display map if option chosen
  # helps with debugging, may not be permanent

  if (plot == 'mapview') print(mapview::mapview(sflayer, zcol=paste0("admin",level,"Name"), legend=FALSE))
  else if (plot == 'sf') plot(sf::st_geometry(sflayer))
  #trying an option to compare hdxlive with gadm
  else if (plot == 'compare')
  {
    #grDevices::rgb() to set alpha transparency
    plot(sf::st_geometry(sflayer), reset=FALSE, border=colr_hdx, main=paste0(country," level",level))
    #TODO COM Comoros has just 1 level in gadm and 3 in HDX live, how to deal with
    sfgadm <- afriadmin(country=country, level=level, plot=FALSE)
    #plot(sf::st_geometry(sfgadm), add=TRUE, reset=TRUE, border='red')

    graphics::legend("bottomright", c("HDX live","GADM"), lty=1, title= NULL, col=c(colr_hdx, colr_gadm), bty='n')

    plot(sf::st_geometry(sfgadm), add=TRUE, reset=TRUE, border=colr_gadm)
  }


  invisible(sflayer)

}


