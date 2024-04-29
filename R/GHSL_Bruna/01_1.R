# descrição -------------------------------------------------------------

#código novo
# este script
# i. lê dados do GHS-BUILT (resolução de 100m)
# ii. filtrar dados do polígono tile 9_13 (Sul)
# iii. salva Sul raster.tif para futura limpeza e manipulação

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

files_input <- dir(paste0(ghsl_dir,'/BUILT'), pattern = "100_V1_0_R13_C14.tif$")

files_output <- gsub('GLOBE','SUL', files_input)

files_output_raster <- gsub('.tif','_raster.tif', files_output)


# * 2.3 function raster ---------------------------------------------------

f_save_sul_raster <- function(input, output){

  # read ghsl data
  bua <- raster::raster(paste0(ghsl_dir,'/BUILT/', input))

  # read br outside function
  #br <- geobr::read_country()
  # transform br crs to bua crs
  br <- sf::st_transform(br, raster::projection(bua))

  # crop raster data using br polygon
  bua_crop <- raster::crop(bua, br)

  # mask raster data
  bua_mask <- raster::mask(bua_crop, br)

  # code below not run, but can be used to check
  # according to ghsl data documentation, nodata value = -200
  # check if there is any negative value (which would compromise area calc)
  ## any(bua_mask[bua_mask<0])

  # create directory
  if (!dir.exists("../../data2/urbanformbr/ghsl/BUILT/SUL")){
    dir.create("../../data2/urbanformbr/ghsl/BUILT/SUL")
  }

  # don't uses save raster files as .rds.
  # See https://stackoverflow.com/a/48512398 for details
  #saveRDS(
  #  bua_crop,
  #  paste0('../../data/urbanformbr/ghsl/',output),
  #  compress = 'xz'
  #  )

  raster::writeRaster(
    x = bua_mask,
    filename = paste0('../../data2/urbanformbr/ghsl/BUILT/SUL/', output),
    overwrite = T
  )

}


# * * 2.2.1 run multiple years --------------------------------------------

#future::plan(future::multisession)
#options(future.globals.maxSize = Inf)

purrr::walk2(.x = files_input, .y = files_output_raster, function(x,y)
  f_save_sul_raster(input = x, output = y)
)

