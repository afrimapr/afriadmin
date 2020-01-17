


#todo function to find the highest level for a country

#todo add country outlines for whole continent as single file
#todo mayne if I saved all outlines as a single file it would be easier to subset etc.

#todo allow countrynames as well as iso3
#tood add error checking for countries
#todo vectorise iso3 to allow combining countries
#todo maybe vectorise level too

afriadmin <- function(iso3 = 'AGO',
                      level = 2,
                      plot = TRUE) {

  #GADM_SF_URL  = "https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_"

  #to allow iso3 in lower case
  iso3 <- toupper(iso3)

  filename <- paste0(iso3,'_adm',level,'.sf.rds')

  path <- system.file(package="afriadmin")

  sf1 <- readRDS(file.path(path, "external/", filename))

  if (plot) plot(sf::st_geometry(sf1))

  return(sf1)

}


