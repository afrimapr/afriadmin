## code to prepare `sf_af_gadm0` dataset goes here

library(GADMTools)

# download country files for all Africa, also results in single object
af_gadm0 <- GADMTools::gadm_sf_loadCountries(afcountrynames('iso3c',filter=NULL), level=0)

# only need sf part of the object
sf_af_gadm0 <- af_gadm0$sf

#names(sf_af_gadm0)
#[1] "ISO"      "NAME_0"   "geometry"

# rename columns
names(sf_af_gadm0) <- c('iso3c','name','geometry')

usethis::use_data("sf_af_gadm0")
