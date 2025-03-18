library(tidyverse)
library(terra)

EVIras <- list.files(
  "../MAP/data/EVI_combined", pattern = "\\.tif$", full.names = T
)

tiff2csv_save <- function(file_path){
  ras <- rast(file_path)
  
  ras_csv <- ras %>% 
    terra::as.data.frame(
      xy = T,
      cells = T,
      wide = F
    )
  
  write_csv(ras_csv, file = paste0(file_path, ".csv"))
}

mapply(tiff2csv_save, file_path = EVIras)
