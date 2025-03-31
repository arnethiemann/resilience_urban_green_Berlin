#---- load required packages ----

library(tidyverse)
library(terra)


#---- load EVI raster files for every year ----

EVIras <- list.files(
  "../MAP/data/EVI_combined", pattern = "\\.tif$", full.names = T
) %>% 
  rast()


#---- mask to Berlin borders ----

berlin_boundaries <- vect("data/ALKIS_Landesgrenze/ALKIS_Landesgrenze.gpkg")

EVIras_Bln <- mask(EVIras, berlin_boundaries) # this can take some time


# save raster to disk as int. result - can also take a while
#terra::writeRaster(EVIras_Bln, filename = "data/EVI_monthly/EVI_bln.tif")


# burn 3 feature classes into rasters with the footprint of the EVI rasters

ATKIS40k <- vect("data/ATKIS/ATKIS_40k.gpkg")
ATKIS50k <- vect("data/ATKIS/ATKIS_50k.gpkg")
Umweltatlas <- vect("data/ATKIS/Umweltatlas.gpkg")
ATKIS_Schutzgebiete <- vect("data/ATKIS/ATKIS_Schutzgebiete.gpkg")

ATKIS40k_ras <- rasterize(ATKIS40k, EVIras_Bln[[1]], field = "atkis_id")
ATKIS50k_ras <- rasterize(ATKIS50k, EVIras_Bln[[1]], field = "atkis_id")
Umweltatlas_ras <- rasterize(Umweltatlas, EVIras_Bln[[1]], field = "objartname")
ATKIS_Schutzgebiete_ras <- rasterize(ATKIS_Schutzgebiete, EVIras_Bln[[1]], field = "atkis_id")


category_rasters <- c(ATKIS40k_ras, ATKIS50k_ras, Umweltatlas_ras, ATKIS_Schutzgebiete_ras)
names(category_rasters) <- c("ATKIS40k", "ATKIS50k", "Umweltatlas", "Schutzgebiete")

#category_df <- terra::as.data.frame(category_rasters, cells = T, xy = T)

writeRaster(category_rasters, "data/interim/categories.tif")

#write_csv(category_df, "data/interim/categories.csv")


#---- create EVI df ----
#EVI_df <- terra::as.data.frame(EVIras_Bln, cells = T, xy = T)



#---- create combination ----
COMBINED <- c(category_rasters, EVIras_Bln)