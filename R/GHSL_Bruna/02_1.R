# descrição

# este scipt
# i. lê dados raster de área construída do GHS-BUILT-BRASIL (resolução de 100 metros)
# ii. recorta espacialmente utilizando formatos de áreas de concentração urbana (uca) do IBGE
# iii. salva raster para cada uca e cada ano

# setup -------------------------------------------------------------------

source('R/fun_support/setup.R')

# setup parallel ----------------------------------------------------------

future::plan(future::multicore, workers = future::availableCores() / 2)

# define function ---------------------------------------------------------

#ano <- 1990

f_crop_built_uca <- function(ano){


  # * read files ------------------------------------------------------------

  # read uca sf saved at urban_concentration_area/01_1_uca_shapes
  urban_shapes <- readr::read_rds("D:/BACKUP_2023/Dissertação/BASE_DADOS/rstudio/data/urbanformbr/urban_area_shapes/urban_area_pop_100000_dissolved.rds")

  # read brasil raster built up area ano
  raster_sul_bua <- raster::raster(sprintf("D:/BACKUP_2023/Dissertação/BASE_DADOS/rstudio/data_ghsl_2023/urbanformbr/ghsl/BUILT/SUL/GHS_BUILT_S_E%s_SUL_R2023A_54009_100_V1_0_R13_C14_raster.tif", ano))


  # * change shape projection -----------------------------------------------

  projection_sul_bua <- rgdal::GDALinfo(sprintf("D:/BACKUP_2023/Dissertação/BASE_DADOS/rstudio/data_ghsl_2023/urbanformbr/ghsl/BUILT/SUL/GHS_BUILT_S_E%s_SUL_R2023A_54009_100_V1_0_R13_C14_raster.tif", ano)) %>%
    attr('projection')

  # change uca sf projection (using brasil built raster projection)
  urban_shapes <- sf::st_transform(urban_shapes, projection_sul_bua)

  codigos <- urban_shapes$code_urban_concentration

  furrr::future_walk(
    codigos,
    function(code_uca){
      message(paste0("\n working on ", code_uca,"\n"))

      # * subset urban_shapes ---------------------------------------------------

      # subset urban_shapes
      df_urban_shape <- subset(urban_shapes, code_urban_concentration == code_uca)

      # * crop & mask raster file ------------------------------------------------

      # crop raster with urban shape
      raster_uca_bua <- raster::crop(raster_sul_bua, df_urban_shape)

      # mask raster with urban shape
      raster_uca_bua <- raster::mask(raster_uca_bua, df_urban_shape)

      # * save file ------------------------------------------------------------

      # create output name with input
      name_output <- gsub(
        pattern = "SUL",
        replacement = df_urban_shape$code_urban_concentration,
        x = sprintf("GHS_BUILT_S_E%s_SUL_R2023A_54009_100_V1_0_R13_C14_raster.tif", ano)
      )

      # save built up area raster file
      raster::writeRaster(
        raster_uca_bua,
        filename = paste0("D:/BACKUP_2023/Dissertação/BASE_DADOS/rstudio/data_ghsl_2023/urbanformbr/ghsl/BUILT/UCA", name_output),
        overwrite = T
      )

    }
  )

}


# run for mulitple years --------------------------------------------------

anos <- c("1975","1980","1985","1990","2000","2005","2010","2015","2020","2025","2030")

furrr::future_walk(anos, ~f_crop_built_uca(.))


