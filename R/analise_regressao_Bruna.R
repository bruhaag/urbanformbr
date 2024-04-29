#script para análise de regressão múltipla

#DENSIDADE EXPERENCIADA
densidade_experenciada = read.csv("C:\\Users\\haagb\\data\\urbanformbr\\consolidated_data\\ghsl_experienced_density_metrics.csv")

densi_bnu_cxs_lon = subset(densidade_experenciada,
                           densidade_experenciada$code_urban_concentration == 4202404 |
                             densidade_experenciada$code_urban_concentration == 4113700 |
                             densidade_experenciada$code_urban_concentration == 4305108 )


#FRAGMENTAÇÃO - COMPACIDADE E CONTIGUIDADE
fragmen_compacit = read.csv("C:\\Users\\haagb\\data\\urbanformbr\\consolidated_data\\fragmentation_compacity.csv")
fragmen_compacit_bnu_cxs_lon = subset(fragmen_compacit,
                                      fragmen_compacit$code_urban_concentration == 4202404 |
                                        fragmen_compacit$code_urban_concentration == 4113700 |
                                        fragmen_compacit$code_urban_concentration == 4305108 )

compac = read.csv("C:\\Users\\haagb\\data\\urbanformbr\\fragmentation_compacity\\compacity_metrics.csv")
frag = read.csv("C:\\Users\\haagb\\data\\urbanformbr\\fragmentation_compacity\\fragmentation_metrics.csv")

compac_bnu_cxs_lon = subset(compac,
                            compac$code_urban_concentration == 4202404 |
                              compac$code_urban_concentration == 4113700 |
                              compac$code_urban_concentration == 4305108 )

frag_bnu_cxs_lon = subset(frag,
                          frag$city == 4202404 |
                            frag$city == 4113700 |
                            frag$city == 4305108 )


#DENATRAN
denatran_fleet = read.csv("C:\\Users\\haagb\\data\\urbanformbr\\consolidated_data\\denatran_fleet_metrics.csv")
denatran_fleet_bnu_cxs_lon = subset(denatran_fleet,
                                    denatran_fleet$code_urban_concentration == 4202404 |
                                      denatran_fleet$code_urban_concentration == 4113700 |
                                      denatran_fleet$code_urban_concentration == 4305108 )

#CRESCIMENTO URBANO
urban_growth_builtarea = read.csv("C:\\Users\\haagb\\data\\urbanformbr\\consolidated_data\\urban_growth_builtarea.csv")
urban_growth_population = read.csv("C:\\Users\\haagb\\data\\urbanformbr\\consolidated_data\\urban_growth_population.csv")

urban_growth_builtarea_bnu_cxs_lon = subset(urban_growth_builtarea,
                                            urban_growth_builtarea$code_urban_concentration == 4202404 |
                                              urban_growth_builtarea$code_urban_concentration == 4113700 |
                                              urban_growth_builtarea$code_urban_concentration == 4305108 )

urban_growth_population_bnu_cxs_lon = subset(urban_growth_population,
                                             urban_growth_population$code_urban_concentration == 4202404 |
                                               urban_growth_population$code_urban_concentration == 4113700 |
                                               urban_growth_population$code_urban_concentration == 4305108 )

urban_growth5 = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\urban_growth\\urban_growth5.rds")

urban_growth5_bnu_cxs_lon = subset(urban_growth5,
                                   urban_growth5$code_urban_concentration == 4202404 |
                                     urban_growth5$code_urban_concentration == 4113700 |
                                     urban_growth5$code_urban_concentration == 4305108 )


#DADOS ANP 2010
anp_energy_2010_metrics = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\consolidated_data\\anp_energy-2010_metrics.rds")

fuel_urban_areas = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\fuel\\fuel_urban_areas.rds")

fuel_urban_areas_bnu_cxs_lon = subset(fuel_urban_areas,
                                      fuel_urban_areas$code_urban_concentration == 4202404 |
                                        fuel_urban_areas$code_urban_concentration == 4113700 |
                                        fuel_urban_areas$code_urban_concentration == 4305108 )

anp_energy_2010_metrics_bnu_cxs_lon = subset(anp_energy_2010_metrics,
                                             anp_energy_2010_metrics$code_urban_concentration == 4202404 |
                                               anp_energy_2010_metrics$code_urban_concentration == 4113700 |
                                               anp_energy_2010_metrics$code_urban_concentration == 4305108 )

#ENDEREÇOS PARA ANÁLISE DE USO DO SOLO
cnefe_lon = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\cnefe\\db\\PR\\4113700_Londrina_PR.rds")
cnefe_cxs = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\cnefe\\db\\RS\\4305108_Caxias do Sul_RS.rds")
cnefe_bnu = readRDS("C:\\Users\\haagb\\data\\urbanformbr\\cnefe\\db\\SC\\4202404_Blumenau_SC.rds")


#VENDAS DE GASOLINA E ETANOL
vendas_etanol = read_xlsx("C:\\Users\\haagb\\data-raw\\ANP\\vendas-anuais-de-etanol-hidratado-por-municipio.xlsx")
vendas_gasolina = read_xlsx("C:\\Users\\haagb\\data-raw\\ANP\\vendas-anuais-de-gasolina-c-por-municipio.xlsx")

vendas_etanol_bnu_cxs_lon = subset(vendas_etanol,
                                   vendas_etanol$`CÓDIGO IBGE` == 4202404 |
                                     vendas_etanol$`CÓDIGO IBGE` == 4113700 |
                                     vendas_etanol$`CÓDIGO IBGE` == 4305108 )

vendas_gasolina_bnu_cxs_lon = subset(vendas_gasolina,
                                     vendas_gasolina$`CÓDIGO IBGE` == 4202404 |
                                       vendas_gasolina$`CÓDIGO IBGE` == 4113700 |
                                       vendas_gasolina$`CÓDIGO IBGE` == 4305108 )

# save.image('analise_regressao_Bruna.RData')
# getwd("C:/Users/haagb/OneDrive/Documentos/urbanformbr")

library(openxlsx)

write.xlsx(densi_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\densi_bnu_cxs_lon.xlsx' )
write.xlsx(fragmen_compacit_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\fragmen_compacit_bnu_cxs_lon.xlsx' )
write.xlsx(compac_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\compac_bnu_cxs_lon.xlsx' )
write.xlsx(frag_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\frag_bnu_cxs_lon.xlsx' )
write.xlsx(denatran_fleet_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\denatran_fleet_bnu_cxs_lon.xlsx' )
write.xlsx(urban_growth_builtarea_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\urban_growth_builtarea_bnu_cxs_lon.xlsx' )
write.xlsx(urban_growth_population_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\urban_growth_population_bnu_cxs_lon.xlsx' )
write.xlsx(urban_growth5_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\urban_growth5_bnu_cxs_lon.xlsx' )
write.xlsx(fuel_urban_areas_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\fuel_urban_areas_bnu_cxs_lon.xlsx' )
write.xlsx(anp_energy_2010_metrics_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\anp_energy_2010_metrics_bnu_cxs_lon.xlsx' )
write.xlsx(vendas_etanol_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\vendas_etanol_bnu_cxs_lon.xlsx' )
write.xlsx(vendas_gasolina_bnu_cxs_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\vendas_gasolina_bnu_cxs_lon.xlsx' )

#ERRO
write.xlsx(cnefe_lon,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\cnefe_lon.xlsx' )
write.xlsx(cnefe_cxs,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\cnefe_cxs.xlsx' )
write.xlsx(cnefe_bnu,
           'C:\\Users\\haagb\\data\\analise_regressao_Bruna\\cnefe_bnu.xlsx' )

