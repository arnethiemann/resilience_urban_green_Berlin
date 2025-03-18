library(tidyverse)
library(terra)

file_paths <- list.files(
  "../MAP/data/EVI_combined", pattern = "\\.tif$", full.names = T
)

bln_boundary <- vect("data/ALKIS_Landesgrenze/ALKIS_Landesgrenze.gpkg")

for (i in file_paths) {
  writeLines(paste("Processing", i))
  ras <- rast(i) %>% 
    mask(mask = bln_boundary)
  
  ras_csv <- ras %>% 
    terra::as.data.frame(
      xy = T,
      cells = T,
      wide = F
    ) %>% 
    na.omit()
  
  writeRaster(ras, filename = paste0(i, "_masked.tif"))
  write_csv(ras_csv, file = paste0(i, "_masked.csv"))
  
  ras <- NULL
}

