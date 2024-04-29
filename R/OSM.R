library(osmdata)

consulta <- opq(bbox = c(-49.0660, -26.9175, -48.6860, -26.6340)) %>%
  add_osm_feature(key = 'highway', value = "motorway")
plot(dados_mapa$osm_lines)

ggplot() +
  geom_sf(data = dados_mapa$osm_lines, aes(), color = "grey50") +
  coord_sf()
