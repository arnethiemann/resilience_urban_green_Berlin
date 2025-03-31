require(tidyverse)
library(ggalluvial)


tb <- read_csv("../MAP/data/osm_preprocessing/geofabrik/table.csv")


tb_sub <- tb %>% 
  filter(
    landuse %in% c("forest", "meadow", "allotments", "grass", 
                   "cemetery", "village_green", "brownfield", "plant_nursery", 
                   "traffic_island", "orchard", "recreation_ground", 
                   "flowerbed", "greenfield", "vineyard", 
                   "greenery", "animal_keeping", "forestry", "apiary", 
                   "tree_pit", "shrubs") |
      natural %in% c("wood", "scrub", "wetland", "grassland", "heath", "shrubbery", "shrub") |
      leisure %in% c("park", "playground", "nature_reserve", 
                     "garden", "golf_course", "pitch", "dog_park") |
      sport %in% c("soccer", "soccer;field_hockey;rugby;athletics", 
                   "field_hockey", "field_hockey;soccer;gaelic_games",
                   "field_hockey;ultimate;multi", "soccer;field_hockey",
                   "soccer;field_hockey;basketball", "baseball;soccer",
                   "soccer;baseball")
  ) %>% 
  select(osm_id, area, landuse, natural, leisure, sport)


# thrown out:
# leisure: "sports_centre"
# natural: plateau
# landuse: farmland, farmyard


#---- barplot ----

tb_sub_areas <- tb_sub %>% 
  group_by(landuse, natural, leisure, sport) %>% 
  summarise(area = sum(area, na.rm = T)) %>%
  mutate(name = paste(landuse,natural,leisure,sport, sep = ", ")) %>% 
  arrange(desc(area)) %>%
  head(50)

ggplot(
  tb_sub_areas %>% mutate,
  aes(
    x = area,
    y = reorder(name, area)
  )
) +
  geom_bar(stat = "identity")

ggsave(
  "osm_barplot.png",
  width = 30,
  height = 120,
  units = "cm",
  dpi = 96
)


#---- sankey ----
df_counts <- tb_sub %>%
  count(natural, landuse, leisure, sport, name = "Freq")

ggplot(df_counts, aes(axis1 = natural, axis2 = landuse, axis3 = leisure, axis4 = sport, y = Freq)) +
  geom_alluvium(aes(fill = landuse), width = 0.2, alpha = 0.7) +
  geom_stratum(width = 0.2, fill = "gray80", color = "black") +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)), size = 4) +
  theme_minimal()

ggsave(
  "osm_alluvial.png",
  width = 100,
  height = 100,
  units = "cm",
  dpi = 96
)
