library(tidyverse)
library(terra)


era5 <- rast("data/climate/era5/ee47210be29693a0ba919032db23ef77.grib")

# crop
berlin_gcs <- vect("data/ALKIS_Landesgrenze/ALKIS_Landesgrenze.gpkg") %>% 
  terra::project(., era5)

era5 <- crop(era5, berlin_gcs, snap = "out")

era5_df <- era5 %>% 
  as.data.frame(., xy = T, cells = T, time = T, wide = F) %>% 
  filter(!layer %in% c(
    "SFC (Ground or water surface); Soil Type [C]",
    "SFC (Ground or water surface); Convective available potential energy [J/kg]"
  ))

ggplot(
  era5_df,
  aes(
    x = time,
    y = values,
    col = factor(cell)
  )
) + geom_line() +
  facet_wrap(~ layer, scales = "free_y")


write_csv(era5_df, "data/climate/era5/era5_berlin.csv")
writeRaster(era5, "data/climate/era5/era5_berlin_ras.tif")

era5_df_wide <- era5_df %>% 
  filter(
    time >= "2000-01-01"
  ) %>% 
  mutate(
    time = (time + 5*24*60*60) %>%
      as.character() %>%
      strftime(., format = "%Y-%m") %>%
      paste0(., "-01") %>%
      as.Date()
  ) %>% 
  pivot_wider(
    names_from = layer,
    values_from = values
  )

write_csv(era5_df_wide, "data/climate/era5/era5_berlin_wide.csv")
