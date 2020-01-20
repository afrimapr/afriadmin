




#todo add country outlines for whole continent as single file
#todo mayne if I saved all outlines as a single file it would be easier to subset etc.

#todo allow countrynames as well as iso3
#todo add error checking for countries
#todo vectorise iso3 to allow combining countries
#todo maybe vectorise level too

#todo is it good idea to name function same as package ?
afriadmin <- function(iso3 = 'AGO',
                      level = 'max',
                      plot = TRUE) {

  #GADM_SF_URL  = "https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_"
  #initially store files directly as downloaded from gadm

  path <- system.file(package="afriadmin","/external")

  #to allow iso3 in lower case
  iso3 <- toupper(iso3)

  maxlevel <- maxadmin()

  if (level=='max')
  {
    level <- maxlevel
    message("returning max admin level available for ",iso3,", ",maxlevel)
  }
  else if (level > maxlevel)
  {
    warning("max admin level available for ",iso3," is ",maxlevel," you requested ",level)
    #maybe do this to return mot detailed available
    level <- maxlevel
  }


  filename <- paste0(iso3,'_adm',level,'.sf.rds')

  # path <- system.file(package="afriadmin")
  # sf1 <- readRDS(file.path(path, "external/", filename))

  sf1 <- readRDS(file.path(path, filename))

  if (plot) plot(sf::st_geometry(sf1))

  return(sf1)
}


# return max admin level for a country
# initialy gadm but could be other sources too
# todo should be vectorised
maxadmin <- function(iso3 = 'AGO') {

  path <- system.file(package="afriadmin","/external")

  allfiles <- list.files(path)
  countryfiles <- allfiles[ substr(allfiles,1,3)==iso3 ]
  levs <- as.numeric( substr(countryfiles,8,8) )
  lev_hi <- max(levs)
  lev_hi
}
