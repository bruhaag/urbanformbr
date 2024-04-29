
# descrição -------------------------------------------------------------

# este script usa dados construídos multitemporais GHSL do ID do bloco 9_13 para
# recortar a forma político-administrativa da região metropolitana de Blumenau / Caxias do Sul / Londrina

# bloco contendo blumenau / caxias do sul / londrina: ID 9_13
# setup -------------------------------------------------------------------
source("R/fun_support/setup.R")


# function ----------------------------------------------------------------
funcao <- function(){

  #  read data --------------------------------------------------------------

  # * tile ------------------------------------------------------------------
  tile_9_13 <- raster::raster("C:/Users/haagb/data-raw/ghsl/BUILT/multitemporal_30m/GHS_BUILT_LDSMT_GLOBE_R2018A_3857_30_V2_0_9_13.tif")

  # * political administrative shape ----------------------------------------

  urban_shapes <- readr::read_rds("../../data/urbanformbr/urban_area_shapes/urban_area_pop_100000_dissolved.rds")
  urban_shapes <- urban_shapes %>%
    dplyr::select(-starts_with("pop"))
  lon <- urban_shapes %>% filter(code_urban_concentration == 4113700)

  # reproject/transform urban shape crs to tile crs
  lon <- sf::st_transform(lon, raster::projection(tile_9_13))

  # crop and mask -----------------------------------------------------------
  # crop raster data using bh polygon
  lon_crop <- raster::crop(tile_9_13, lon)

  # mask raster data
  lon_mask <- raster::mask(lon_crop, lon)

  # save data ---------------------------------------------------------------
  # create directory
  if (!dir.exists("../../data/urbanformbr/ghsl/BUILT/multitemporal")){
    dir.create("../../data/urbanformbr/ghsl/BUILT/multitemporal")
  }

  raster::writeRaster(
    x = lon_crop,
    filename = '../../data/urbanformbr/ghsl/BUILT/multitemporal/GHS_BUILT_LDSMT_GLOBE_R2018A_3857_30_V2_0_londrina_metro_area_CROP.tif',
    overwrite = T
  )

  raster::writeRaster(
    x = lon_mask,
    filename = '../../data/urbanformbr/ghsl/BUILT/multitemporal/GHS_BUILT_LDSMT_GLOBE_R2018A_3857_30_V2_0_londrina_metro_area_MASK.tif',
    overwrite = T
  )

}


# run function ------------------------------------------------------------
funcao()

