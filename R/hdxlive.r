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
#' @param lwd line width in plots
#' @param alpha transparency in mapview plots
#' @param plot option to display map 'mapview' for interactive, 'sf' for static, 'compare' to sf compare with gadm
#'
#' @examples
#'
#' hdxlive("angola")
#' hdxlive('benin',level=2)
#' hdxlive('zimbabwe',level=2)
#' #to compare gadm and hdx
#' hdxlive('malawi',level=2, plot='compare_mapview')
#'
#' @return not sure yet
#' @export
#'
hdxlive <- function(country,
                    level = 2,
                    #grDevices::rgb() to set alpha transparency
                    colr_hdx = rgb(0,0,1,alpha=0.4),
                    colr_gadm = rgb(1,0,0,alpha=0.4),
                    lwd = 2,
                    alpha = 0.5,
                     plot = 'compare_sf') {
                     #plot = 'compare_mapview') {
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
  #to compare hdxlive with gadm
  else if (plot == 'compare_sf' | plot == 'compare_mapview')
  {
    #TODO COM Comoros has just 1 level in gadm and 3 in HDX live, how to deal with
    sfgadm <- afriadmin(country=country, level=level, plot=FALSE)

    if (plot == 'compare_sf')
    {
      plot(sf::st_geometry(sflayer), reset=FALSE, border=colr_hdx, main=paste0(country," level",level), lwd=lwd)
      #put this before final layer to avoid reset issues
      graphics::legend("bottomright", c("HDX live","GADM"), lty=1, lwd=lwd, title= NULL, col=c(colr_hdx, colr_gadm), bty='n')
      plot(sf::st_geometry(sfgadm), add=TRUE, reset=TRUE, border=colr_gadm, lwd=lwd)
    }
    else if ( plot == 'compare_mapview')
    {
      #col.region sets colours for legend only (because I've set fill to FALSE)
      print(mapview(list(sflayer,sfgadm), fill=FALSE, color=list(colr_hdx,colr_gadm), col.region=list(colr_hdx,colr_gadm),
              alpha=alpha, lwd=lwd))
      #didn't work to set hover labels to names of polygons
      #,label=list(paste0("admin",level,"Name"),paste0("NAME_",level))
      #this messes with legend
      #zcol=list(paste0("admin",level,"Name"),paste0("NAME_",level)),
    }


  }



  invisible(sflayer)

}


