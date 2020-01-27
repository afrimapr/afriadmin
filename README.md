# afriadmin
african administrative boundaries

To make administrative boundary polygons for Africa easily accessible from R.

A part of the afrimapr project.

In early development, contact Andy South with questions.


There are various sources of administrative boundaries available on the web, and existing R packages for accessing them.

This package will improve access to boundaries for Africa.

It will start by giving access to African admin boundaries at all levels from [gadm.org](https://gadm.org/) (probably the best current source of global admin boundaries).

As a first step I've saved all the full resolution gadm files (~ 88MB) in the package to save having to download them each time. Later we may choose to save just lower resolution versions. [CRAN policy](https://cran.r-project.org/web/packages/policies.html) "As a general rule, neither data nor documentation should exceed 5MB ... Where a large amount of data is required (even after compression), consideration should be given to a separate data-only package which can be updated only rarely".

I'll develop interface functions that are intended to stay similar, what is happening behind may change. 


### Install afriadmin

Install the development version from GitHub using [devtools](https://github.com/hadley/devtools).

    devtools::install_github("afrimapr/afriadmin")


### First Usage

``` r
library(afriadmin)
library(sf)

#Angola level 2
plot(sf::st_geometry(afriadmin("AGO",2)))

# todo move the readme to an Rmd to allow plots

```

### Use cases

1. Single country maps.
We want to target in-country use. People in Africa making maps of Africa. Maybe there will be a greater utility for tools that make it easy to make maps of a single country rather than of multiple countries ? 

2. low resolution boundaries just for display at country level

3. higher resolution boundaries to allow zooming in. (e.g. what detail is needed in a polygon boundary file to be able to create zonal statistics for a raster file of a given cell size ?)


