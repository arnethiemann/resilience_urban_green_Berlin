library(tidyverse)
library(xml2)
library(curl)

# https://gdi.berlin.de/geonetwork/srv/ger/catalog.search#/metadata/f0e8ff09-2887-3446-9c53-81dbc45af03c

namespace <- c(atom = "http://www.w3.org/2005/Atom")

dem_links <- "https://fbinter.stadt-berlin.de/fb/feed/senstadt/a_dgm" %>% 
  read_xml() %>% 
  xml_find_all("//atom:entry", namespace) %>% 
  xml_find_all(".//atom:link[@rel='alternate']", namespace) %>% 
  xml_attr("href") %>% 
  read_xml() %>% 
  xml_find_all("//atom:entry", namespace) %>% 
  xml_find_all("//atom:link[@rel='section']", namespace) %>% 
  xml_attrs("href") %>% 
  sapply(., c) %>% t() %>% data.frame()

if(!dir.exists("atkis_dem_tiles")) dir.create("atkis_dem_tiles")

check <- multi_download(
  dem_links$href,
  destfiles = paste0("atkis_dem_tiles/", dem_links$title),
  resume = T
)

zipfiles <- list.files(
  "atkis_dem_tiles",
  pattern = "\\.zip$",
  full.names = T
)

pb = txtProgressBar(min = 0, max = length(zipfiles), initial = 0, style = 3) 

for (i in seq_along(zipfiles)) {
  unzip(
    zipfiles[i],
    overwrite = F,
    junkpaths = T,
    exdir = "../MAP/data/berlin_atkis/dgm/xyztiles"
  )
  
  setTxtProgressBar(pb,i)
}