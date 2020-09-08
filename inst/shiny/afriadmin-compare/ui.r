# afriadmin/afriadmin-compare/ui.r
# to compare different admin boundaries for the same country (diff. sources and resolutions)

# initially copied from afrihealthsites/healthsites_viewer2

cran_packages <- c("shiny","leaflet","remotes")

lapply(cran_packages, function(x) if(!require(x,character.only = TRUE)) install.packages(x))

library(shiny)
library(leaflet)
library(remotes)

if(!require(afriadmin)){
  remotes::install_github("afrimapr/afriadmin")
}

library(afriadmin)
# library(mapview)

data(afcountries)

fluidPage(

  #headerPanel('afrimapr admin boundaries comparison tool'),
  headerPanel(p( a("afrimapr", href="http://www.afrimapr.org", target="_blank"),
                 'admin boundaries comparison app')),

  p("compare", a("geoBoundaries", href="https://www.geoboundaries.org/", target="_blank"),
    "&",       a("GADM", href="https://www.gadm.org/", target="_blank") ,
    "- may take a few seconds to download selected data"),

  sidebarLayout(

  sidebarPanel( width=3,

    # p("data from",
    #               a("healthsites.io", href="https://www.healthsites.io", target="_blank"),
    #               " & ",
    #               a("KEMRI Wellcome", href="https://www.nature.com/articles/s41597-019-0142-2", target="_blank"),
    #               " / ",
    #               a("WHO", href="https://www.who.int/malaria/areas/surveillance/public-sector-health-facilities-ss-africa/en/", target="_blank")),


    #selectInput('country', 'Country', afcountries$name, size=10, selectize=FALSE, multiple=TRUE, selected="Angola"),
    #miss out Western Sahara because no healthsites or WHO
    selectInput('country', 'Country', choices = sort(afcountries$name[!afcountries$name=="Western Sahara"]),
                size=7, selectize=FALSE, multiple=TRUE, selected="Angola"),

    #admin level
    selectInput("adm_lvl", label = "admin level",
                choices = c(1:4),
                selected = 1),

    selectInput("type", label = "geoboundaries type",
                choices = c("simple (sscu)"="sscu", "precise (hpscu)"="hpscu", "simple standard (sscgs)"="sscgs", "precise standard (hpscgs)"="hpscgs"),
                selected = 1),

    # dynamic who category selection
    #uiOutput("select_who_cat"),

    p("active development Sep 2020, v0.1 ",
      "Open source ", a("R code", href="https://github.com/afrimapr/afriadmin", target="_blank")),

    #p("Contact : ", a("@southmapr", href="https://twitter.com/southmapr", target="_blank")),
    #p("Open source ", a("R code", href="https://github.com/afrimapr/afriadmin", target="_blank")),

    p("by ", a("afrimapr", href="http://www.afrimapr.org", target="_blank"),
      ": creating R building-blocks to ease use of open health data in Africa"),

    p("Input and suggestions ", a("welcome", href="https://github.com/afrimapr/suggestions_and_requests", target="_blank")),
    #  "Contact : ", a("@southmapr", href="https://twitter.com/southmapr", target="_blank")),

    p(tags$small("Disclaimer : Data used by afrimapr are sourced from published open data sets. We provide no guarantee of accuracy.")),

  ),

  mainPanel(

    #when just had the map
    #leafletOutput("serve_map", height=1000)

    #tabs
    tabsetPanel(type = "tabs",
                tabPanel("map", leafletOutput("serve_map", height=800)),
                tabPanel("names", DT::dataTableOutput("table_names")))
                #tabPanel("facility types", plotOutput("plot_fac_types", height=600)),
                #tabPanel("healthsites data", DT::dataTableOutput("table_raw_hs")),

    )
  )
)



