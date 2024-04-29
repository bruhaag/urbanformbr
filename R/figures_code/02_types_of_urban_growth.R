#' Script para preparar plots para o relatório

source('R/fun_support/setup.R')
source("R/fun_support/colours.R")
mapviewOptions(platform = "leaflet")
library(geobr)
#bnu <- read_municipality(code_muni = 4202404, year = 2020)
#cx <- read_municipality(code_muni = 4305108, year = 2020)
#lon <- read_municipality(code_muni = 4113700, year = 2020)


# spatial data - cells classified by growth type
urban_extent_processed <- read_rds(file = "../../data/urbanformbr/urban_growth/grid_uca_growth5.rds") %>%
  mutate(growth_type = if_else(status == "consolidated", "upward", status)) %>%
  mutate(growth_type = factor(growth_type,
                              levels = c("upward", "infill", "extension", "leapfrog"),
                              labels = c("Adensamento", "Preenchimento", "Extensão", "Leapfrog"))) %>%
  filter(name_uca_case == "blumenau_sc") %>%
  filter(period_start == 1975, period_end == 2014)

#water_bodies_sf <- st_read("../../data/urbanformbr/urban_growth/rios_porto_alegre_wsg84.gpkg")
#land_sf <- geobr::read_municipality(code_muni = 4202404)
# roads_sf <- st_read("../../data/urbanformbr/urban_growth/rodovias_porto_alegre_wgs84.gpkg") %>%
#   filter(LAYER %in% c(1, 6))

# Mapa - Tipos de Crescimento ---------------------------------------------

#' Mapa descritivo dos tipos de crescimento urbano: upward, infill, extension
#' e leapfrog

b_box <- st_bbox(urban_extent_processed)

urban_extent_processed %>%
  ggplot() +
  ggspatial::annotation_map_tile(
    zoom = 12
    #, zoomin = -1
    , type = "cartolight" #cartodark
  ) +
  geom_sf(
  data = bnu, fill="grey30", color="black", alpha=.05, size=.15) +
  #geom_sf(data = water_bodies_sf, fill = "#d7dfe6", color = "#d7dfe6") +
  #geom_sf(data = roads_sf, size = 1, color = "grey40") +
  geom_sf(aes(fill=growth_type), size = 0.2) +
  coord_sf(xlim = c(b_box["xmin"], b_box["xmax"]),
           ylim = c(b_box["ymin"], b_box["ymax"])) +
  scale_fill_aop(palette = "blue_red", reverse = TRUE) +
  theme_minimal() +
  theme(panel.border = element_rect(fill = NA, color = "grey80"),
        panel.grid = element_blank()) +
  labs(fill = "",
       title = "Blumenau / SC - expansão urbana entre 1975 e 2014")+
  ggspatial::annotation_scale(location = "tl") +
  ggspatial::annotation_north_arrow(
    location = "br",
    height = unit(1, "cm"),
    width = unit(1, "cm")
  )

ggsave(filename = here::here("figures", "blumenau_types_of_growth.pdf"),
       width = 10, height = 8, units = "cm", dpi = 300, scale = 1.8)


