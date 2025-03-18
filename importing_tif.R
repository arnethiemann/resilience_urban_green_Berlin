library(sf)
library(raster)
library(terra)

# Path to load tif files
tif_path <- "D:/GIS_AGI/categories.tif"

# Reading the files
raster_data <- rast(tif_path)
# Printig and plotting
print(raster_data)
plot(raster_data)
