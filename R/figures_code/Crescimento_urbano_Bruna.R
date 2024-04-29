
# description -------------------------------------------------------------

# este script plota a extensão urbana (corte de 20% da área construída) forma e formas urbanas
# (político administrativo) para mostrar a evolução da extensão urbana de 1990 a 2014


# setup -------------------------------------------------------------------
source("R/fun_support/setup.R")
source("R/fun_support/style.R")
source("R/fun_support/colours.R")
library(ggmap)
library(osmdata)
library(dplyr)

# select ucas -------------------------------------------------------------

built_growth <- data.table::fread("../../data/urbanformbr/consolidated_data/urban_growth_builtarea.csv")
built_growth$code_urban_concentration = as.numeric(built_growth$code_urban_concentration)
built_growth <- filter(built_growth, code_urban_concentration %in% c(4202404, 4113700, 4305108))

pop_growth <- data.table::fread("../../data/urbanformbr/consolidated_data/urban_growth_population.csv")
pop_growth$code_urban_concentration = as.numeric(pop_growth$code_urban_concentration)
pop_growth <- filter(pop_growth, code_urban_concentration %in% c(4202404, 4113700, 4305108))

#censo <- data.table::fread("../../data/urbanformbr/consolidated_data/censo_metrics.csv")
