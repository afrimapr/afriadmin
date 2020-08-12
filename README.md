# afriadmin
african administrative boundaries

To make administrative boundary polygons for Africa easily accessible from R.

A part of the [afrimapr](www.afrimapr.org) project.

In early development, will change, contact Andy South with questions.


There are various sources of administrative boundaries available on the web, and existing R packages for accessing them.

This package will improve access to boundaries for Africa.

It started by looking at African admin boundaries at all levels from [gadm.org](https://gadm.org/).

Next step is to look at [geoboundaries](https://www.geoboundaries.org/) which seem to be more current and comprehensive - via [rgeoboundaries](https://dickoa.gitlab.io/rgeoboundaries/).

As a first step I've saved all the full resolution gadm files (~ 88MB) in the package to save having to download them each time. Later we may choose to save just lower resolution versions. [CRAN policy](https://cran.r-project.org/web/packages/policies.html) "As a general rule, neither data nor documentation should exceed 5MB ... Where a large amount of data is required (even after compression), consideration should be given to a separate data-only package which can be updated only rarely".
This is also just a temporary solution, given that the GADM licence conditions indicate that they cannot be re-distributed without permission.

I'll develop interface functions that are intended to stay similar, what is happening behind may change. 

I'm also looking into accessing boundaries from [HDX](https://data.humdata.org/) (Humanitarian Data eXchange), which are more up-to-date but currently are trickier to reach for all countries in an automated way.


### Install afriadmin

Install the development version from GitHub using [devtools](https://github.com/hadley/devtools).

    # install.packages("devtools") # if not already installed
    
    devtools::install_github("afrimapr/afriadmin")


### First Usage

``` r
library(afriadmin)
library(sf)

## single admin levels

# with interactive map
sfken <- afriadmin("kenya",level='max', plot='mapview')

# static map
sfeth <- afriadmin("ethiopia",level='max', plot='sf')

afriadmin("Angola",level=2)


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


