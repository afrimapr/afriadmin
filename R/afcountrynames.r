#' return all africa country names
#' (may not need the function, given that I've saved as data afcountries)
#'
#' @param nameoriso3c whether to return vector of 'name' or 'iso3c' or 'both'
#' @param filtercountries optional filter countries that are in 'gadm2' potential to add others
#'
#' @examples
#'
#' afcountrynames()
#'
#' @return character vector of african country names
#' @export
#'
afcountrynames <- function(nameoriso3c = 'name',
                           filtercountries = NULL) {

  # this code now moved to data-raw
  # # vector of all ISO 3 letter country codes for african countries
  # # can use rnaturalearth to get
  # library(rnaturalearth)
  # #51 misses cape verde, comoros
  # #sf_ne_africa <- ne_countries(scale = 110, type = "countries", continent = 'africa', returnclass='sf')
  # #54 misses mauritius, seychelles. includes western sahara, somaliland
  # sf_ne_africa <- ne_countries(scale = "medium", type = "countries", continent = 'africa', returnclass='sf')
  #
  # #plot(sf::st_geometry(sf_ne_africa))
  #
  # #select just 2 columns, drop geometry
  # afcountries <- sf::st_drop_geometry(subset(sf_ne_africa, select=c('admin','adm0_a3')))
  # #rename columns
  # names(afcountries) <- c('name','iso3c')
  # #correct some codes
  # afcountries$iso3c[afcountries$iso3c=='SAH'] <- 'ESH' #replace western sahara code for gadm
  # afcountries$iso3c[afcountries$iso3c=='SDS'] <- 'SSD' #replace south sudan code for gadm
  # # why do I have solomon islands in africa ? think should be somaliland, internationally considered part of somalia
  # afcountries <- afcountries[afcountries$iso3c != 'SOL',] #remove somaliland code not in gadm

  #saved this dataframe in the package
  #usethis::use_data(afcountries)

  # #gadm level 2 fails at COM comoros,CPV cape verde, LBY Libya, LSO lesotho, ESH western sahara
  if (isTRUE(filtercountries == 'gadm2'))
     afcountries <- afcountries[(!afcountries$iso3c %in% c('COM','CPV','LBY', 'LSO', 'ESH')),]

  if (nameoriso3c == 'name') return(afcountries$name)
  else if (nameoriso3c == 'iso3c') return(afcountries$iso3c)
  else return(afcountries)

  #TODO may want to allow subsetting of countries that are in gadm at diff admin levels
  # see below

  #gadm queries using GADMTools
  #works
  # gadm0_afr <- GADMTools::gadm_sf_loadCountries(ve_adm0_a3_afr, level=0)
  # gadm1_afr <- GADMTools::gadm_sf_loadCountries(ve_adm0_a3_afr, level=1)
  # #gadm level 2 fails at COM comoros,CPV cape verde, LBY Libya, LSO lesotho, ESH western sahara
  # ve_adm0_a3_afr_gadm2 <- ve_adm0_a3_afr[(!ve_adm0_a3_afr %in% c('COM','CPV','LBY', 'LSO', 'ESH'))]
  # gadm2_afr <- GADMTools::gadm_sf_loadCountries(ve_adm0_a3_afr_gadm2, level=2)
  #mapview(gadm1_afr$sf, zcol='NAME_1', color=grey, lwd=1, legend=FALSE )
  #mapview(gadm2_afr$sf, zcol='NAME_2', color=grey, lwd=1, legend=FALSE )

  # old code
  # ve_adm0_a3_afr <- sf_ne_africa$adm0_a3 # 54 countries
  # ve_adm0_a3_afr[ve_adm0_a3_afr=='SAH'] <- 'ESH' #replace western sahara code for gadm
  # ve_adm0_a3_afr[ve_adm0_a3_afr=='SDS'] <- 'SSD' #replace south sudan code for gadm
  # # why do I have solomon islands in africa ? think should be somaliland, internationally considered part of somalia
  # ve_adm0_a3_afr <- ve_adm0_a3_afr[ve_adm0_a3_afr!='SOL'] #remove somaliland code not in gadm


}




