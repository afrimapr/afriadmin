#' hdx admin layers starting to looking at downloading
#'
#' #todo vectorise
#'
#' @param country a character vector of country names
#'
#'
#' @examples
#'
#' hdxadmin("nigeria")
#'
#' @return not sure yet
#' @export
#'
hdxadmin <- function(country) {


    iso3clow <- tolower(country2iso(country))

    #querytext <- paste0('vocab_Topics:("common operational dataset - cod" AND "administrative divisions") AND groups:', iso3clow)
    querytext <- paste0('vocab_Topics:("common operational dataset - cod" AND "gazetteer") AND groups:', iso3clow)


    rhdx::set_rhdx_config()
    datasets_list <- rhdx::search_datasets(fq = querytext)

    ds <- datasets_list

    #hoping that it just returns a single dataset (with multiple resources)
    #kenya seems to return list(0)

    list_of_rs <- get_resources(ds[[1]])

    list_of_rs
}

# using gazetteer
# > hdxadmin("nigeria")
# [[1]]
# <HDX Resource> 0bc2f7bb-9ff6-40db-a569-1989b8ffd3bc
# Name: nga_admbnda_osgof_eha_itos.gdb.zip
# Description: Administrative level 0 (country), 1 (state), 2 (local government area), 3 (wards - northeast Nigeria), and  senatorial district boundary geodatabase
# Size: 6706778
# Format: GEODATABASE
#
# ...
#
# [[3]]
# <HDX Resource> aa69f07b-ed8e-456a-9233-b20674730be6
# Name: nga_adm_osgof_20190417_SHP.zip
# Description: Administrative level 0 (country), 1 (state), 2 (local government area), 3 (wards - northeast Nigeria), and  senatorial districts boundary shapefiles
# Size: 7491434
# Format: ZIPPED SHAPEFILES

#for Nigeria using tag:administrative divisions just returning this topojson probably not what I want
# hdxadmin("nigeria")
# [[1]]
# <HDX Resource> e13316a7-1380-4676-abdc-bd5127577371
# Name: COD_NGA_Admin3.topojson
# Description: This dataset is of simplified geometries from COD live services deployed Sept.  2019. To preview, download from link and load in https://mapshaper.org. Methodology: Simplification methods applied from ESRI libraries using Python, Node.js and Mapshaper.js and based on adapted procedures for best outcomes preserving shape, topology and attributes. These data are not a substitute for the original COD data sets used in GIS applications. No warranties of any kind are made for any purpose and this dataset is offered as-is.
# Size:
# Format: topojson


