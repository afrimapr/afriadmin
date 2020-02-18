#' hdx admin layers starting to looking at downloading
#'
#' #todo vectorise
#'
#' @param country a character vector of country names
#' @param level which admin level to return
#' @param plot option to display map 'mapview' for interactive, 'sf' for static
#'
#' @examples
#'
#' hdxadmin("nigeria")
#'
#' @return not sure yet
#' @export
#'
hdxadmin <- function(country,
                     level = 2,
                     plot = 'sf') {


    iso3clow <- tolower(country2iso(country))

    iso3clow <- 'nga'
    #iso3clow <- 'mli'
    level <- 2

    #nigeria does return single result
    #mali returns two datasets first one is population
    querytext <- paste0('vocab_Topics:("common operational dataset - cod" AND "gazetteer" NOT "baseline population") AND groups:', iso3clow)

    rhdx::set_rhdx_config()
    datasets_list <- rhdx::search_datasets(fq = querytext)

    #query needs to return a single dataset (with multiple resources)
    ds <- datasets_list[[1]]

    #get list of resources
    list_of_rs <- rhdx::get_resources(ds)
    list_of_rs

    #selecting resource
    #nigeria "zipped shapefiles"
    #mali "zipped shapefile"
    ds_id <- which( rhdx::get_formats(ds) == "zipped shapefiles" | "zipped shapefile")

    rs <- rhdx::get_resource(ds, ds_id)

    # find which layers in file
    mlayers <- rhdx::get_resource_layers(rs, download_folder=getwd())


    #error for nigeria
    #<HDX Resource> aa69f07b-ed8e-456a-9233-b20674730be6
    #Name: nga_adm_osgof_20190417_SHP.zip
    #Description: Administrative level 0 (country), 1 (state), 2 (local government area), 3 (wards - northeast Nigeria), and  senatorial districts boundary shapefiles
    #Format: ZIPPED SHAPEFILES
    #I suspect problem because uppercase and s on end
    #Error: This (spatial) data format is not yet supported
    #in hdx resources.r
    # supported_geo_format <- c("geojson", "zipped shapefile", "zipped geodatabase",
    #                           "zipped geopackage", "kmz", "zipped kml")

    #added "zipped shapefiles" option to supported_geo_format in my local branch of rhdx
    #now I get
    #Cannot open data source /vsizip/C:/rsprojects/afriadmin/nga_adm_osgof_20190417_shp.zip
    #Error in CPL_get_layers(dsn, options, do_count) : Open failed.
    #can I open a layer from the downloaded file directly ?
    #using default should open the first layer
    sflayer <- rhdx::read_resource(rs, download_folder=getwd())
    plot(sf::st_geometry(sflayer))
    #no this also fails
    #seemingly because there is a subfolder within the zip
    #aha, nigeria is in a folder within the zip and mali isn't so nigeria fails and mali works
    #is there a way of detecting and dealing with this ?


    # later read layer using layername
    # this relies on all country layers having adm* in their names
    layername <- mlayers$name[ grep(paste0("adm",level),mlayers$name) ]

    sflayer <- read_resource(re, layer=layername, download_folder=getwd())

    #test plotting
    plot(sf::st_geometry(sflayer))


    #lapply(ken, function(x) get_resource_format(x))
    #[1] "zipped shapefiles"
    #[1] "zipped geodatabase"

    # pull_dataset("administrative-boundaries-cod-mli") %>%
    #          get_resource(3) %>%
    #          read_resource(download_folder=getwd()) -> malishp
    #
    # plot(sf::st_geometry(malishp))

    # alternative approach using name of resource
    # TODO is naming consistent ?
    ds <- pull_dataset("administrative-boundaries-cod-mli")
    # these fail, may need to go back to query
    #ds <- pull_dataset("administrative-boundaries-cod-uga") #uganda none ?
    #ds <- pull_dataset("administrative-boundaries-cod-nga") #nigeria none ?

    list_of_rs <- rhdx::get_resources(ds)

    # for Mali is 3rd resource
    # TODO find better way of selecting from dataset list
    re <- get_resource(ds, 3)

    # find which layers in file
    mlayers <- get_resource_layers(re, download_folder=getwd())

    # next can I search for adm1 3 etc. in name field of the result
    # to get the layer I want

    #mlayers$name[ grep("adm2",mlayers$name) ]
    #using paste from admin_level
    #level <- 2
    level <- 3
    layername <- mlayers$name[ grep(paste0("adm",level),mlayers$name) ]
    # this relies on all country layers having adm* in their names

    # read layer using layername
    sflayer <- read_resource(re, layer=layername, download_folder=getwd())


    #todo later put these plotting bits into shared function
    plot(sf::st_geometry(sflayer))

    mapview(sflayer, zcol=paste0("admin",level,"Name"), legend=FALSE)

    # when I do directly from sf (see below)
    # seems to be problem opening a layer from a zipped shapefile by name
    # somehow rhdx gets around that


    # TODO will it work for geodatabase ? not quite
    # also geopackage not present for all countries
    ds_id <- which( rhdx::get_formats(ds) == "geodatabase" )


}

# rhdx seems to read the first layer if one isn't specified
# read_hdx_vector <- function(file = NULL, layer = NULL, zipped = TRUE, ...) {
#     check_packages("sf")
#     if (zipped)
#         file <- file.path("/vsizip", file)
#     if (is.null(layer)) {
#         layer <- sf::st_layers(file)[[1]][1]
#         message("reading layer: ", layer, "\n")
#     }
#     sf::read_sf(dsn = file, layer = layer, ...)
# }


#sf to find layers in a file
#mlayers <- sf::st_layers(file.path("/vsizip","mli_adm_1m_dnct_2019_shp.zip"))

#reads first layer by default if not specified
# sfmali <- sf::read_sf(file.path("/vsizip","mli_adm_1m_dnct_2019_shp.zip"))
#
# sfmali <- sf::read_sf(file.path("/vsizip","mli_adm_1m_dnct_2019_shp.zip", layer=mlayers$name[2]))
# #still problem reading 2nd layr from zip
# #Error: Cannot open "/vsizip/mli_adm_1m_dnct_2019_shp.zip/mli_admbnda_adm1_1m_dnct_20190802"; The file doesn't seem to exist.
#
# plot(sf::st_geometry(sfmali))

# rhdx has some useful code for querying format of resources from hdx and
# determining how to open them

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


