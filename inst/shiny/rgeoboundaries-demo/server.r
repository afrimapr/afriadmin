# afriadmin rgeoboundaries-demo/server.r
# min repro example of rgeoboundaries to test download errors on shinyapps



function(input, output) {


  ######################################
  # mapview interactive leaflet map plot
  output$serve_map <- renderLeaflet({

    #avoid problems at start
    if (length(input$adm_lvl) == 0) return(NULL)

    # take code from afriadmin.r to make clearer how rgeoboundaries being used

    country <- input$country
    adm_lvl <- input$adm_lvl
    type    <- input$type

    #convert simplified codes to geoboundaries ones
    if      (type=='simple') type <- 'SSCU'
    else if (type=='simple standard') type <- 'SSCGS'
    else if (type=='precise') type <- 'HPSCU'
    else if (type=='precise standard') type <- 'HPSCGS'

    sf1 <- rgeoboundaries::geoboundaries(country,
                                         adm_lvl = paste0('adm',adm_lvl),
                                         type = type)

    mapplot <- mapview::mapview(sf1, zcol="shapeName", label="shapeName")


    #important that this returns the @map bit
    #otherwise get Error in : $ operator not defined for this S4 class
    mapplot@map

    })

  ################################################################################
  # dynamic selectable list of admin levels based on country
  output$select_lvl <- renderUI({

    max_lvl <- afriadmin::maxadmin(input$country, datasource='geoboundaries')

    radioButtons("adm_lvl", label = "admin level",
                 choices = c(1:max_lvl),
                 inline = TRUE, #horizontal
                 selected = 1)
  })




  ###########################
  # table of admin unit names from the 2 sources
  # output$table_names <- DT::renderDataTable({
  #
  #   #want to avoid downloading the data again,
  #   #but hopefully it will have been cached locally so won't download again
  #
  #   #beware this just uses single type so far
  #   dfnames <- compareadmin(input$country, level=input$adm_lvl, type=input$type, plot='namestable')
  #
  #
  #   DT::datatable(dfnames, options = list(pageLength = 50))
  # })




}
