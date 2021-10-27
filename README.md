# afriadmin
african administrative boundaries

To make administrative boundary polygons for Africa easily accessible from R.

A part of the [afrimapr](www.afrimapr.org) project.

In early development, will change, contact Andy South with questions.

There are various sources of sub-national administrative boundaries available on the web, and existing R packages for accessing them.

[geoboundaries](https://www.geoboundaries.org/) via [rgeoboundaries](https://dickoa.gitlab.io/rgeoboundaries/) seems to be the current best source.

[gadm.org](https://gadm.org/) is comprehensive and easy to access, but seems less up to date and data sourcing, curation and licensing are not as clear.

[HDX](https://data.humdata.org/) (Humanitarian Data eXchange), has some more up-to-date boundaries but currently are trickier to reach for all countries in an automated way. HDX developers have told us that should be improved in coming months.

### online user interface prototype
[https://andysouth.shinyapps.io/afriadmin-compare/](https://andysouth.shinyapps.io/afriadmin-compare/)


### Install afriadmin

Install the development version from GitHub using remotes.

    # install.packages("remotes") # if not already installed
    
    remotes::install_github("afrimapr/afriadmin")


### First Usage

``` r
library(afriadmin)
library(sf)

## single admin levels

# with interactive map, geoboundaries is default datasource but showing here for info
sftgo <- afriadmin("togo", level=2, datasource='geoboundaries')

# static map
sfeth <- afriadmin("ethiopia",level=4, plot='sf')

# comparing boundaries from different sources


# default compares geoboundaries and gadm
compareadmin("togo", level=2, datasource=c('geoboundaries','gadm'))

# option to compare different geobounadaries types
compareadmin("togo", level=2, datasource=c('geoboundaries','geoboundaries'), type=c('sscu','hpscu') )


## multiple admin levels - experimental

# single static map
afplotadmin("malawi")

# facetted using tmap
# returns a single object containing all admin levels
sfall <- alllevels("angola")


# todo move the readme to an Rmd to allow plots

```

### Use cases

A. I'm a developer in country X, I want to know what options I have for obtaining boundary data at different administrative levels for my country.


1. Single country maps.
We want to target in-country use. People in Africa making maps of Africa. Maybe there will be a greater utility for tools that make it easy to make maps of a single country rather than of multiple countries ? 

2. low resolution boundaries just for display at country level

3. higher resolution boundaries to allow zooming in. (e.g. what detail is needed in a polygon boundary file to be able to create zonal statistics for a raster file of a given cell size ?)


