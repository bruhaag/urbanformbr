# descrição -------------------------------------------------------------

# este script salva polígonos para cada área de concentração urbana com base em áreas construídas
#..porcentagem de área definida no script 04-0 (ou seja, área construída >= 5%)
# esses polígonos para área construída são definidos como "extensão urbana" e serão utilizados
#..para comparar a expansão urbana em termos de aumento da densidade e da pegada urbana
# os polígonos são salvos em um dataframe (.rds) para cada ano (1990,2000,2014)

# setup -------------------------------------------------------------------

source('R/fun_support/setup.R')

# setup parallel ----------------------------------------------------------

future::plan(future::multicore, workers = future::availableCores() / 2)

# define function ---------------------------------------------------------

#ano <- 1990

f_create_uca_polygon_cutoff_5 <- function(ano){

  # read info df
  urban_shapes <- readr::read_rds('../../data/urbanformbr/urban_area_shapes/urban_area_pop_100000_dissolved.rds') %>%
    sf::st_drop_geometry() %>%
    select(-pop_ibge_total_2010)

  codigos <- urban_shapes$code_urban_concentration

  df_pol_cutoff5 <- furrr::future_map_dfr(
    codigos,
    function(code_uca){
      message(paste0("\n working on ", code_uca,"\n"))

      # * subset urban_shapes ---------------------------------------------------

      df_urban_shape <- subset(urban_shapes, code_urban_concentration == code_uca)

      # * read built up area raster ---------------------------------------------

      raster_uca_bua <- raster::raster(sprintf("../../data/urbanformbr/ghsl/BUILT/UCA/GHS_BUILT_LDS%s_%s_R2018A_54009_1K_V2_0_raster.tif", ano, code_uca))

      # * filter grid cells -----------------------------------------------------

      # filter grid cells with >= 5% built up area
      raster_filter <- raster_uca_bua
      raster_filter[raster_filter < 5] <- NA

      # * convert to polygon ----------------------------------------------------
      #
      pol_uca_bua <- raster::rasterToPolygons(raster_filter) %>%
        sf::st_as_sf()

      # rename and create columns
      pol_uca_bua <- pol_uca_bua %>%
        dplyr::rename(bua_value = 1) %>%
        dplyr::mutate(cutoff5 = "construida")

      # non onverlapping join
      pol_uca_bua <- pol_uca_bua %>%
        dplyr::group_by(cutoff5) %>%
        dplyr::summarise() %>%
        dplyr::select(-cutoff5)

      # add code_urban_concentration, name_urban_concentration & name_uca_case
      df_pol_uca_bua <- pol_uca_bua %>%
        dplyr::mutate(
          code_urban_concentration = df_urban_shape$code_urban_concentration
          , name_urban_concentration = df_urban_shape$name_urban_concentration
          , name_uca_case = df_urban_shape$name_uca_case
        ) %>%
        dplyr::relocate("geometry", .after = name_uca_case)

      return(df_pol_uca_bua)

    }
  )


  # save as one df ----------------------------------------------------------
  saveRDS(
    df_pol_cutoff5,
    sprintf("../../data/urbanformbr/ghsl/results/urban_extent_uca_%s_cutoff5.rds", ano),
    compress = 'xz'
  )


}

# run for mulitple years --------------------------------------------------

anos <- c("1975","1990","2000","2014")

furrr::future_walk(anos, ~f_create_uca_polygon_cutoff_5(.))

