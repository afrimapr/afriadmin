# afriadmin/afriadmin-compare/server.r
# to compare different admin boundaries for the same country (diff. sources and resolutions)

# initially copied from afrihealthsites/healthsites_viewer2

# TODO could add mapshaper to be able to simplify boundaries on the fly

cran_packages <- c("leaflet","remotes")
lapply(cran_packages, function(x) if(!require(x,character.only = TRUE)) install.packages(x))


library(remotes)
library(leaflet)
# library(ggplot2)
# library(patchwork) #for combining ggplots

if(!require(afriadmin)){
  remotes::install_github("afrimapr/afriadmin")
}

library(afriadmin)
library(rgeoboundaries) #think maybe this shouldn't be needed but seems to cause fail on shinyapps
library(mapview) #otherwise | operator doesn't work
#mapviewOptions(fgb = FALSE)


#global variables

# to try to allow retaining of map zoom, when selections are changed
zoom_view <- NULL
# when country is changed I want whole map to change
# but with other options (e.g. boundary type) I want to retain zoom
# perhaps can just reset zoomed view to NULL when country is changed


# Define a server for the Shiny app
function(input, output) {

  ######################################
  # mapview interactive leaflet map plot
  output$serve_map <- renderLeaflet({


    mapplot <- compareadmin(input$country,
                            level=input$adm_lvl,
                            datasource = c('geoboundaries','gadm'),
                            type = c(input$type, NULL),
                            plot = 'mapview',
                            plotshow = FALSE
                            )



    #creating side-by-side slider view
    #found that this error was known to others & should be fixed by dev version of mapview
    #remotes::install_github("r-spatial/mapview")
    #Warning: Error in value[[3L]]: Couldn't normalize path in `addResourcePath`, with arguments: `prefix` = 'PopupTable-0.0.1'; `directoryPath` = ''
    #did work from console
    #mapplot <- mapplot1 | mapplot2


    # to retain zoom if only types have been changed
    if (!is.null(zoom_view))
    {
      mapplot@map <- leaflet::fitBounds(mapplot@map, lng1=zoom_view$west, lat1=zoom_view$south, lng2=zoom_view$east, lat2=zoom_view$north)
    }


    #important that this returns the @map bit
    #otherwise get Error in : $ operator not defined for this S4 class
    mapplot@map

    })

  #########################################################################
  # trying to detect map zoom as a start to keeping it when options changed
  observeEvent(input$serve_map_bounds, {

    #print(input$serve_healthsites_map_bounds)

    #save to a global object so can reset to it
    zoom_view <<- input$serve_map_bounds
  })

  ####################################################################
  # perhaps can just reset zoomed view to NULL when country is changed
  # hurrah! this works, is it a hack ?
  observe({
    input$country
    zoom_view <<- NULL
  })


  ###################################
  # to update map without resetting everything use leafletProxy
  # see https://rstudio.github.io/leaflet/shiny.html
  # Incremental changes to the map should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  # BUT I don't quite know how to use with a mapview map ...
  # observe({
  #   #pal <- colorpal()
  #   # leafletProxy("map", data = filteredData()) %>%
  #   #   clearShapes() %>%
  #   #   addCircles(radius = ~10^mag/10, weight = 1, color = "#777777",
  #   #              fillColor = ~pal(mag), fillOpacity = 0.7, popup = ~paste(mag)
  #   #  )
  # })




  ###########################
  # table of admin unit names from the 2 sources
  output$table_names <- DT::renderDataTable({

    #want to avoid downloading the data again,
    #but hopefully it will have been cached locally so won't download again

    #beware this just uses single type so far
    dfnames <- compareadmin(input$country, level=input$adm_lvl, type=input$type, plot='namestable')


    DT::datatable(dfnames, options = list(pageLength = 50))
  })




}
