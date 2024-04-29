# descrição ------------------------------------------------ -------------

# este script recorta e salva raster para cada extensão urbana (corte de 5%)
#..contendo, para cada ano:
# i) dados de área construída
#ii) população

# setup -------------------------------------------------------------------

source('R/fun_support/setup.R')

# setup parallel ----------------------------------------------------------

future::plan(future::multicore, workers = future::availableCores() / 2)

# define function ---------------------------------------------------------

#ano <- 1975

f_create_uca_raster_cutoff5 <- function(ano){

  # read urban extent (cutoff 5%) polygon for every uca (saved at GHSL/04_1)
  df_pol_cutoff5 <- readr::read_rds(sprintf("../../data/urbanformbr/ghsl/results/urban_extent_uca_%s_cutoff5.rds", ano))

  codigos <- df_pol_cutoff5$code_urban_concentration

  furrr::future_walk(
    codigos,
    function(code_uca){
      message(paste0("\n working on ", code_uca,"\n"))

      if(ano == "2014"){
        ano_pop <- "2015"
      } else {
        ano_pop <- ano
      }

      # * subset df_cutoff5 ---------------------------------------------------
      df_cutoff5_subset <- subset(df_pol_cutoff5, code_urban_concentration == code_uca)

      # * read raster -----------------------------------------------------------

      # * * built up area -------------------------------------------------------
      raster_bua <- raster::raster(sprintf("../../data/urbanformbr/ghsl/BUILT/UCA/GHS_BUILT_LDS%s_%s_R2018A_54009_1K_V2_0_raster.tif", ano, code_uca))

      # * * population ----------------------------------------------------------
      raster_pop <- raster::raster(sprintf("../../data/urbanformbr/ghsl/POP/UCA/GHS_POP_E%s_%s_R2019A_54009_1K_V1_0_raster.tif", ano_pop, code_uca))


      # * crop & mask raster ----------------------------------------------------

      # * * built up area -------------------------------------------------------
      raster_bua <- raster::crop(raster_bua, df_cutoff5_subset)

      raster_bua <- raster::mask(raster_bua, df_cutoff5_subset)

      # * * population ----------------------------------------------------------
      raster_pop <- raster::crop(raster_pop, df_cutoff5_subset)

      raster_pop <- raster::mask(raster_pop, df_cutoff5_subset)


      # save data ---------------------------------------------------------------
      # built up area
      raster::writeRaster(
        x = raster_bua,
        filename = sprintf("../../data/urbanformbr/ghsl/BUILT/urban_extent_cutoff_5_raster/GHS_BUILT_LDS%s_%s_urban_extent_cutoff_5_1K_raster.tif", ano, code_uca),
        overwrite = T
      )

      # population
      raster::writeRaster(
        x = raster_pop,
        filename = sprintf("../../data/urbanformbr/ghsl/POP/urban_extent_cutoff_5_raster/GHS_POP_E%s_%s_urban_extent_cutoff_5_1K_raster.tif", ano_pop, code_uca),
        overwrite = T
      )

    }
  )

}


# run for mulitple years --------------------------------------------------

anos <- c("1975","1990","2000","2014")

furrr::future_walk(anos, ~f_create_uca_raster_cutoff5(.))


