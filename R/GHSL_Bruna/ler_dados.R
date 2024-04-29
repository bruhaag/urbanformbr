#esse script lê os dados dos resultados da análise e manipulação GHSL
#filtra os dados das cidades de estudo
#salva em shp

library(dplyr)
library(geobr)
library(sf)

dados_1975_5 = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\ghsl\\results\\grid_uca_1975_cutoff5.rds")
dados_1990_5 = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\ghsl\\results\\grid_uca_1990_cutoff5.rds")
dados_2000_5 = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\ghsl\\results\\grid_uca_2000_cutoff5.rds")
dados_2014_5 = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\ghsl\\results\\grid_uca_2014_cutoff5.rds")

dados_1990_20 = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\ghsl\\results\\20%\\grid_uca_1990_cutoff20.rds")
dados_2000_20 = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\ghsl\\results\\20%\\grid_uca_2000_cutoff20.rds")
dados_2014_20 = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\ghsl\\results\\20%\\grid_uca_2014_cutoff20.rds")

#filtrar
dados_1975_5_ = subset(dados_1975_5, dados_1975_5$code_urban_concentration == 4202404 |
                         dados_1975_5$code_urban_concentration == 4113700 |
                         dados_1975_5$code_urban_concentration == 4305108)

dados_1990_5_ = subset(dados_1990_5, dados_1990_5$code_urban_concentration == 4202404 |
                         dados_1990_5$code_urban_concentration == 4113700 |
                         dados_1990_5$code_urban_concentration == 4305108)

dados_2000_5_ = subset(dados_2000_5, dados_2000_5$code_urban_concentration == 4202404 |
                         dados_2000_5$code_urban_concentration == 4113700 |
                         dados_2000_5$code_urban_concentration == 4305108)

dados_2014_5_ = subset(dados_2014_5, dados_2014_5$code_urban_concentration == 4202404 |
                         dados_2014_5$code_urban_concentration == 4113700 |
                         dados_2014_5$code_urban_concentration == 4305108)

dados_1990_20_ = subset(dados_1990_20, dados_1990_20$code_urban_concentration == 4202404 |
                          dados_1990_20$code_urban_concentration == 4113700 |
                          dados_1990_20$code_urban_concentration == 4305108)

dados_2000_20_ = subset(dados_2000_20, dados_2000_20$code_urban_concentration == 4202404 |
                          dados_2000_20$code_urban_concentration == 4113700 |
                          dados_2000_20$code_urban_concentration == 4305108)

dados_2014_20_ = subset(dados_2014_20, dados_2014_20$code_urban_concentration == 4202404 |
                          dados_2014_20$code_urban_concentration == 4113700 |
                          dados_2014_20$code_urban_concentration == 4305108)
rm(dados_1975_5)
rm(dados_1990_5)
rm(dados_2000_5)
rm(dados_2014_5)

rm(dados_1990_20)
rm(dados_2000_20)
rm(dados_2014_20)


shape_1975_5 = st_write(dados_1975_5_, "dados_1975_5_.shp", crs = 32722)
shape_1990_5 = st_write(dados_1990_5_, "dados_1990_5_.shp", crs = 32722)
shape_2000_5 = st_write(dados_2000_5_, "dados_2000_5_.shp", crs = 32722)
shape_2014_5 = st_write(dados_2014_5_, "dados_2014_5_.shp", crs = 32722)

shape_1990_20 = st_write(dados_1990_20_, "dados_1990_20_.shp")
shape_2000_20 = st_write(dados_2000_20_, "dados_2000_20_.shp")
shape_2014_20 = st_write(dados_2014_20_, "dados_2014_20_.shp")


type_growth = readRDS('C:\\Users\\haagb\\data\\urbanformbr\\urban_growth\\grid_uca_growth5.rds')

df_bnu = subset(type_growth, type_growth$code_urban_concentration == 4202404)
df_cxs = subset(type_growth, type_growth$code_urban_concentration == 4305108)
df_lon = subset(type_growth, type_growth$code_urban_concentration == 4113700)


getwd()
setwd('C:\\Users\\haagb\\OneDrive\\Área de Trabalho\\MAPAS\\growth')
shape_growth_bnu = st_write(df_bnu, "shape_growth_bnu.shp", crs = 32722)
shape_growth_cxs = st_write(df_cxs, "shape_growth_cxs.shp", crs = 32722)
shape_growth_lon = st_write(df_lon, "shape_growth_lon.shp", crs = 32722)

bnu = read_municipality(code_muni = 4202404)
cxs = read_municipality(code_muni = 4305108)
lon = read_municipality(code_muni = 4113700)
shape_bnu = st_write(bnu, "shape_bnu.shp", crs = 32722)
shape_cxs = st_write(cxs, "shape_cxs.shp", crs = 32722)
shape_lon = st_write(lon, "shape_lon.shp", crs = 32722)

sc = read_state(code_state = 42)
rs = read_state(code_state = 43)
pr = read_state(code_state = 41)
shape_sc = st_write(sc, "shape_sc.shp", crs = 32722)
shape_rs = st_write(rs, "shape_rs.shp", crs = 32722)
shape_pr = st_write(pr, "shape_pr.shp", crs = 32722)

brasil = read_municipality(code_muni = 'all')
sul = subset(brasil, brasil$abbrev_state == 'SC' |
               brasil$abbrev_state == 'RS' |
               brasil$abbrev_state == 'PR')

shape_muni_sul = st_write(sul, "shape_muni_sul.shp", crs = 32722)
