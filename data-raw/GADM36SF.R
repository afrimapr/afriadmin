## code to prepare `GADM36SF` dataset goes here

library(GADMTools)

#GADM36SF dataframe from GADMTools package
#GADM36SF[GADM36SF$LEVEL_0=='Kenya',]
#ID    LEVEL_0 LEVEL_1 LEVEL_2       LEVEL_3 LEVEL_4 LEVEL_5
#KEN   Kenya   County  Constituency  Ward

data(GADM36SF)

usethis::use_data(GADM36SF)
