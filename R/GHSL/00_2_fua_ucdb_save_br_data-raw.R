# descrição ------------------------------------------------ -------------

# este script
# i. lê dados de conjuntos de dados FUA e UCDB
# áreas Urbanas Funcionais (FUA) e Banco de Dados de Centros Urbanos (UCDB)
# ii. filtrar dados de cidades brasileiras
# iii. salva dados como .rds para limpeza futura e manipulação

# setup -------------------------------------------------------------------

source('R/fun_support/setup.R')

# directory ---------------------------------------------------------------

ghsl_dir <- "C:/Users/haagb/data-raw/ghsl"


# define function ---------------------------------------------------------

filter_savebr <- function(){


  # 1 read raw data ---------------------------------------------------------

  # * 1.1 fua ---------------------------------------------------------------

  fua <- sf::read_sf('../../data-raw/ghsl/fua/GHS_FUA_UCDB2015_GLOBE_R2019A_54009_1K_V1_0.gpkg')

  #dplyr::glimpse(fua)

  # * 1.2 ucdb --------------------------------------------------------------

  ucdb <- sf::read_sf("../../data-raw/ghsl/ucdb/GHS_STAT_UCDB2015MT_GLOBE_R2019A_V1_2/GHS_STAT_UCDB2015MT_GLOBE_R2019A/GHS_STAT_UCDB2015MT_GLOBE_R2019A_V1_2.gpkg")

  #dplyr::glimpse(ucdb)


  # 2 filter brazilian cities -----------------------------------------------

  # * 2.1 fua ---------------------------------------------------------------

  fua <- fua %>% dplyr::filter(Cntry_ISO=="BRA")


  # * 2.2 ucdb --------------------------------------------------------------

  ucdb <- ucdb %>% dplyr::filter(CTR_MN_ISO == "BRA")


  # 3 save rds data ---------------------------------------------------------


  readr::write_rds(
    x = fua,
    file = "../../data-raw/ghsl/fua/fua_br_2015_1k_v1.rds",
    compress = 'gz'
  )

  readr::write_rds(
    x = ucdb,
    file = "../../data-raw/ghsl/ucdb/ucdb_br_2015_v1_2.rds",
    compress = 'gz'
  )


}

library(writexl)

write_xlsx(fua, "C:\\Users\\haagb\\data-raw\\ghsl\\fua\\fua.xlsx")
write_xlsx(ucdb, "C:\\Users\\haagb\\data-raw\\ghsl\\ucdb\\ucdb.xlsx")

# run function ------------------------------------------------------------
filter_savebr()

