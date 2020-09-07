#' compare 2 sets of admin polygons for a country
#'
#' returns a mapview (or potentially later sf plot object), most arguments take a vector allowing two layers to be specified
#'
#' @param country a character vector of country names or iso3c character codes.
#'
#' @param datasource c('geoboundaries','gadm')
#' @param level 1
#' @param type for geoboundaries, boundary type defaults to 'simple' One of 'HPSCU', 'HPSCGS', 'SSCGS', 'SSCU', or 'precise' 'simple' 'precise standard' 'simple standard'
#'  Determines the type of boundary link you receive. More on details
#' @param version for geoboundaries defaults to the most recent version of geoBoundaries available.
#'  The geoboundaries version requested, with underscores. For example, 3_0_0 would return data
#'  from version 3.0.0 of geoBoundaries.
#'
#'
#' @param quiet for geoboundaries, if TRUE no message while downloading and reading the data. Default to FALSE
#' @param plot option to display map 'mapview' for interactive, 'sf' for static
#'
#'
#' @examples
#'
#' compareadmin("togo", level=2)
#' compareadmin("togo", level=2, datasource=c('geoboundaries','geoboundaries'), type=c('sscu','hpscu') )
#' #checking out problems with char encoding from rgeoboundaries
#' #e.g. togo admin2 accents malformed for sscu not hpscu
#' sfprecise <- rgeoboundaries::geoboundaries("togo", adm_lvl="adm2", type="hpscu")
#' sfsimple <- rgeoboundaries::geoboundaries("togo", adm_lvl="adm2", type="sscu")
#'
#'
#' @return \code{sf}
#' @export
#'
compareadmin <- function(country,
                      level = c(1,1), #'max',
                      datasource = c('geoboundaries','gadm'),
                      type = c('simple','simple'),
                      version = c(NULL,NULL),
                      quiet = FALSE,
                      colors = c('red', 'blue'), # for polygon boundaries
                      lwds = c(2,2),
                      col.regions = list(RColorBrewer::brewer.pal(9, "YlGn"), RColorBrewer::brewer.pal(9, "BuPu")),
                      alpha = c(0.9, 0.9), #keep point borders light, but present to show light colours
                      #map.types=c('CartoDB.Positron','OpenStreetMap.HOT'),
                      layer.names = NULL, #layer.names = c('a','b')
                      plotlegend = TRUE,
                      alpha.regions = c(0.1, 0.1),
                      plot = 'mapview',
                      plotshow = TRUE) {

  #if just one admin level is specified replicate it in a vector
  if (length(level) == 1) level <- c(level,level)
  if (length(datasource) == 1) datasource <- c(datasource,datasource)
  if (length(type) == 1) type <- c(type,type)

  sf1 <- afriadmin(country,
                   level = level[1],
                   datasource = datasource[1],
                   type = type[1],
                   version = version[1],
                   quiet = quiet,
                   plot = FALSE )

  sf2 <- afriadmin(country,
                   level = level[2],
                   datasource = datasource[2],
                   type = type[2],
                   version = version[2],
                   quiet = quiet,
                   plot = FALSE )


  zcol1 <- paste0("NAME_", level[1])
  if (!zcol1 %in% names(sf1)) zcol1 <- "shapeName"

  zcol2 <- paste0("NAME_", level[1])
  if (!zcol2 %in% names(sf2)) zcol2 <- "shapeName"

  # to set length of colour palette to length of data by interpolation partly to avoid warnings from mapview
  # colorRampPalette() returns a function that accepts the number of categories
  col.regions[[1]] <- grDevices::colorRampPalette(col.regions[[1]])
  col.regions[[2]] <- grDevices::colorRampPalette(col.regions[[2]])

  #initially set layer names from datasources
  if (is.null(layer.names))
  {
     layer.names <- datasource
     #cool bit of code to only add type to label for geoboundaries
     layer.names <- ifelse(datasource=="geoboundaries", paste(datasource,type), datasource)
  }

  if (plot == 'mapview')
  {

     mapplot <- mapview::mapview(sf1,
                                 zcol=zcol1,
                                 #label=paste(sf1[[zcol1]],sf1[[labcol1]]),
                                 #cex=plotcex[1],
                                 color = colors[1],
                                 lwd = lwds[1],
                                 #col.regions=col.regions[[1]],
                                 col.regions=colors[[1]], #try to cheat get this in legend, but low alpha so clear in map
                                 alpha.regions = alpha.regions[1],
                                 alpha = alpha[1],
                                 layer.name=layer.names[[1]],
                                 legend.pos = 'topleft', #failed to try to put legends on separate sides
                                 legend=plotlegend
                                 #map.types=map.types
                                 )

     mapplot <- mapplot + mapview::mapview(sf2,
                                           zcol=zcol2,
                                           #label=paste(sf2[[zcol2]],sf2[[labcol2]]),
                                           #cex=plotcex[2],
                                           color = colors[2],
                                           lwd = lwds[2],
                                           #col.regions=col.regions[[2]],
                                           col.regions=colors[[2]], #try to cheat get this in legend, but low alpha so clear in map
                                           alpha.regions = alpha.regions[2],
                                           alpha = alpha[2],
                                           layer.name=layer.names[[2]],
                                           legend=plotlegend
                                           #map.types=map.types
                                           )

     if (plotshow) print(mapplot)

     invisible(mapplot)

  } else if (plot == 'namestable')
  {
     #maxrows <- max(nrow(sf1), nrow(sf2))

     #list first to cope with rows of diff length
     #sort to facilitate comparison
     dfnames <- list(sort(sf1[[zcol1]]),
                     sort(sf2[[zcol2]]))

     #converts list to df and fills with NA
     dfnames <- data.frame(lapply(dfnames, "length<-", max(lengths(dfnames))))

     #set names of columns to the datasources
     names(dfnames) <- datasource
     return(dfnames)
  }


}
