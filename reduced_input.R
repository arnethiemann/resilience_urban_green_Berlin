library(tidyverse)
library(terra)

EVIras <- rast("data/EVI_monthly/EVI_bln.tif")

AOI <- vect("data/selected_AOI.gpkg")

crs(AOI) == crs(EVIras)

EVIras_AOI <- crop(EVIras, ext(AOI), snap = "out")
EVIras_AOI <- mask(EVIras_AOI, AOI)



writeRaster(EVIras_AOI, "data/EVI_AOI_cropped.tif")

EVI_df <- terra::as.data.frame(EVIras_AOI, cells = T, xy = T, wide = F) %>% 
  na.omit()

plot(EVIras_AOI)

write_csv(EVI_df, "data/reduced_input/EVI_AOI.csv")


#---- categories raster ----
ATKIS40k <- vect("data/ATKIS/ATKIS_40k.gpkg")
ATKIS50k <- vect("data/ATKIS/ATKIS_50k.gpkg")
Umweltatlas <- vect("data/ATKIS/Umweltatlas.gpkg")
ATKIS_Schutzgebiete <- vect("data/ATKIS/ATKIS_Schutzgebiete.gpkg")

ATKIS40k_ras <- rasterize(ATKIS40k, EVIras_AOI[[1]], field = "atkis_id")
ATKIS50k_ras <- rasterize(ATKIS50k, EVIras_AOI[[1]], field = "atkis_id")
Umweltatlas_ras <- rasterize(Umweltatlas, EVIras_AOI[[1]], field = "objartname")
ATKIS_Schutzgebiete_ras <- rasterize(ATKIS_Schutzgebiete, EVIras_AOI[[1]], field = "atkis_id")

category_rasters <- c(ATKIS40k_ras, ATKIS50k_ras, Umweltatlas_ras, ATKIS_Schutzgebiete_ras)
names(category_rasters) <- c("ATKIS40k", "ATKIS50k", "Umweltatlas", "Schutzgebiete")

category_rasters <- category_rasters %>% 
  crop(., ext(AOI), snap = "out") %>% 
  mask(., AOI)

category_df <- category_rasters %>%
  terra::as.data.frame(cells = T, xy = T, wide = F) %>% 
  na.omit()

write_csv(category_df, "data/reduced_input/categories.csv")
