# descrição -------------------------------------------------------------

# este script
#i. lê dados do GHS-POP (resolução de 100m)
#ii. filtrar dados do polígono Sul
#iii. salva Sul raster.tif para futura limpeza e manipulação

# LISTA DE AFAZERES:
## FUNÇÃO CORRIGIR OU APAGAR ESTRELAS
## VERIFIQUE A NECESSIDADE DE EMPILHAR ARQUIVOS RASTER/ESTRELAS UNS SOBRE OS OUTROS
## EXPANDIR A FUNÇÃO PARA OUTRAS RESOLUÇÕES?

# setup -------------------------------------------------------------------

source('R/fun_support/setup.R')
library(geobr)
library(dplyr)

# directory ---------------------------------------------------------------

ghsl_dir <- "../../data_raw2/GHSL"

# 1 read polygon data -----------------------------------------------------

conj = list_geobr()
br <- geobr::read_region(year = 2020)
sul <- br %>% filter(name_region == "Sul")

# 2 function and files ----------------------------------------------------

# * 2.1 files -------------------------------------------------------------

files_input <- dir(paste0(ghsl_dir,'/POP'), pattern = "100_V1_0_R13_C14.tif$")

files_output <- gsub('GLOBE','SUL', files_input)

files_output_raster <- gsub('.tif','_raster.tif', files_output)



# * 2.2 function raster ---------------------------------------------------

f_save_brasil_raster <- function(input, output){

  # read ghsl data
  pop <- raster::raster(paste0(ghsl_dir,'/POP/', input))

  # read br outside function
  #br <- geobr::read_country()
  # transform br crs to pop crs
  br <- sf::st_transform(br, raster::projection(pop))

  # crop raster data using br polygon
  pop_crop <- raster::crop(pop, br)

  # mask raster data
  pop_mask <- raster::mask(pop_crop, br)
  ## erro (que aparentemente nao atrapalha o processo)
  ##  Error in (function (x)  : tentativa de aplicar uma não-função

  # code below not run, but can be used to check
  # according to ghsl data documentation, nodata value = -200
  # check if there is any negative value (which would compromise area calc)
  ## any(pop_mask[pop_mask<0])

  # create directory
  if (!dir.exists("../../data2/urbanformbr/ghsl/POP/")){
    dir.create("../../data2/urbanformbr/ghsl/POP/")
  }

  if (!dir.exists("../../data2/urbanformbr/ghsl/POP/SUL")){
    dir.create("../../data2/urbanformbr/ghsl/POP/SUL")
  }

  # don't uses save raster files as .rds.
  # See https://stackoverflow.com/a/48512398 for details
  #saveRDS(
  #  pop_crop,
  #  paste0('../../data/urbanformbr/ghsl/',output),
  #  compress = 'xz'
  #  )

  raster::writeRaster(
    x = pop_mask,
    filename = paste0('../../data2/urbanformbr/ghsl/POP/SUL/', output),
    overwrite = T
  )

}


# * * 2.2.1 run multiple years --------------------------------------------

#future::plan(future::multisession)
#options(future.globals.maxSize = Inf)

purrr::walk2(.x = files_input, .y = files_output_raster, function(x,y)
  f_save_brasil_raster(input = x, output = y)
)

