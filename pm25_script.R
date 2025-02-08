library(tidyverse)
library(ggplot2)
library(ggthemes)
library(ggrepel)
library(sf)
library(viridis)

district_shp <- st_read("/Users/anannyasharma/Documents/Ashoka/ASP/Spring 24/ISM - Mapping the Sustainability of Delhi/code/datasets/shrug-pc11subdist-poly-shp/subdistrict.shp")
pm25_shrug_pc_11_district <- read.csv("/Users/anannyasharma/Documents/Ashoka/ASP/Spring 24/ISM - Mapping the Sustainability of Delhi/code/datasets/shrug-pm25-csv/pm25_pc11dist.csv")
state_keys <- read.csv("/Users/anannyasharma/Documents/Ashoka/ASP/Spring 24/ISM - Mapping the Sustainability of Delhi/code/datasets/state_key.csv")

delhi_pm25 <- left_join(pm25_shrug_pc_11_district, state_keys, by="pc11_state_id")

delhi_pm25 <- delhi_pm25 %>% 
  filter(state_name == "nct of delhi")

district_shp <- district_shp %>% 
  filter(pc11_s_id == "07")

district_shp$pc11_district_id <- as.numeric(district_shp$pc11_d_id)

table(district_shp$pc11_district_id%in%delhi_pm25$pc11_district_id)

delhi_district_shp <- dplyr::left_join(district_shp, delhi_pm25, by="pc11_district_id")

# mean PM 2.5
delhi_shp_pm25_mean <- ggplot(delhi_district_shp)+
  geom_sf(aes(fill = pm25_mean)) +
  theme_map() + scale_fill_viridis()+
  scale_color_viridis()

delhi_shp_pm25_mean

# max PM 2.5
delhi_shp_pm25_max <- ggplot(delhi_district_shp)+
  geom_sf(aes(fill = pm25_max)) +
  theme_map() + scale_fill_viridis()+
  scale_color_viridis()

delhi_shp_pm25_max

# min PM 2.5
delhi_shp_pm25_min <- ggplot(delhi_district_shp)+
  geom_sf(aes(fill = pm25_min)) +
  theme_map() + scale_fill_viridis()+
  scale_color_viridis()

delhi_shp_pm25_min

st_write(delhi_district_shp, "/Users/anannyasharma/Documents/Ashoka/ASP/Spring 24/ISM - Mapping the Sustainability of Delhi/mapping/delhi_pm25.shp", encoding = "UTF-8")

library(gridExtra)
grid.arrange(delhi_shp_pm25_max, delhi_shp_pm25_mean, delhi_shp_pm25_min, ncol=3)

traffic_delhi <- st_read("/Users/anannyasharma/Documents/Ashoka/ASP/Spring 24/ISM - Mapping the Sustainability of Delhi/mapping/traffic_delhi_clipped.shp")

traffic_delhi <- traffic_delhi %>% 
  filter(fclass=="fuel" | fclass=="traffic_signals")

traffic_delhi <- traffic_delhi %>%
  mutate(fclass = ifelse(fclass == "fuel", "blue", 
                         ifelse(fclass == "traffic_signals", "red", fclass)))

st_write(traffic_delhi, "/Users/anannyasharma/Documents/Ashoka/ASP/Spring 24/ISM - Mapping the Sustainability of Delhi/mapping/traffic_delhi.shp", encoding = "UTF-8")

delhi_green <- st_read("/Users/anannyasharma/Documents/Ashoka/ASP/Spring 24/ISM - Mapping the Sustainability of Delhi/mapping/explore/landuse_delhi_clippedpm25.shp")

delhi_green <- delhi_green %>% 
  filter(fclass=="park" | fclass=="forest" | fclass=="nature_reserve")

ggplot(delhi_green)+
  geom_sf(aes(fill = fclass)) +
  theme_map() 

st_write(delhi_green, "/Users/anannyasharma/Documents/Ashoka/ASP/Spring 24/ISM - Mapping the Sustainability of Delhi/mapping/delhi_greenspaces.shp", encoding = "UTF-8")
