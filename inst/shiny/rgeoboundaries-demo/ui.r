# afriadmin rgeoboundaries-demo/ui.r
# min repro example of rgeoboundaries to test download errors on shinyapps


library(shiny)
library(leaflet)
library(remotes)

#IMPORTANT TO INSTALL rgeoboundaries from github rather than gitlab to get it to work on shinyapps
#remotes::install_github("wmgeolab/rgeoboundaries")

library(afriadmin)
library(rgeoboundaries) #think maybe this shouldn't be needed but seems to cause fail on shinyapps
library(mapview) #otherwise | operator doesn't work

#
data(afcountries)

fluidPage(

  headerPanel(p('rgeoboundaries-demo to test on shinyapps')),

  sidebarLayout(

  sidebarPanel( width=3,


    selectInput('country', 'Country', afcountries$name, size=10, selectize=FALSE, multiple=TRUE, selected="Angola"),

    #miss out Western Sahara because no healthsites or WHO
    #selectInput('country', 'Country', choices = sort(afcountries$name[!afcountries$name=="Western Sahara"]),
    #            size=7, selectize=FALSE, multiple=TRUE, selected="Angola"),

    #admin level
    uiOutput("select_lvl"),
    # selectInput("adm_lvl", label = "admin level",
    #             choices = c(1:4),
    #             selected = 1),


    selectInput("type", label = "geoboundaries type",
                choices = c("simple (sscu)"="sscu", "precise (hpscu)"="hpscu", "simple standard (sscgs)"="sscgs", "precise standard (hpscgs)"="hpscgs"),
                selected = 1),


    p("active development May 2021, v0.1 ",
      "Open source ", a("R code", href="https://github.com/afrimapr/afriadmin/inst/shiny/rgeoboundaries-demo", target="_blank")),

    p("by ", a("afrimapr", href="http://www.afrimapr.org", target="_blank"),
      ": creating R building-blocks to ease use of open health data in Africa"),

    p("Input and suggestions ", a("welcome", href="https://github.com/afrimapr/suggestions_and_requests", target="_blank")),
  ),

  mainPanel(

    #when just had the map
    leafletOutput("serve_map", height=1000)

    #tabs
    # tabsetPanel(type = "tabs",
    #             tabPanel("map", leafletOutput("serve_map", height=800)),
    #             tabPanel("names", DT::dataTableOutput("table_names")))

    )
  )
)



