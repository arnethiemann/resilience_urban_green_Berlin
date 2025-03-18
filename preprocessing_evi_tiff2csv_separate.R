library(tidyverse)
library(terra)

file_paths <- list.files(
  "../MAP/data/EVI_combined", pattern = "\\.tif$", full.names = T
)


for (i in file_paths) {
  writeLines(paste("Processing", i))
  ras <- rast(i)
  
  ras_csv <- ras %>% 
    terra::as.data.frame(
      xy = T,
      cells = T,
      wide = F
    ) %>% 
    na.omit()
  
  write_csv(ras_csv, file = paste0(i, ".csv"))
  
  ras <- NULL
}

