#script para baixar dados do censo

library(censobr)
library(arrow)
library(dplyr)
library(geobr)
library(ggplot2)

?censobr

read_population()
read_households()
read_mortality()
read_families()
read_emigration()

#caminho de onde os dados foram salvos
#C:/Users/haagb/AppData/Local/R/cache/R/censobr/data_release_v0.1.0

censobr_cache(list_files = TRUE)
censobr_cache(delete_file = "2000_families.parquet")
censobr_cache(delete_file = "2010_deaths.parquet")
censobr_cache(delete_file = "2010_emigration.parquet")
censobr_cache(list_files = TRUE)

dom = read_households(
  year = 2010,
  columns = c('code_muni',
              'V0001', # UF
              'V0002', # codigo municipio
              'V0010', # peso amostral
              "V0300", # controle
              "V1006", # situacao do domicilio (1 urbana 2 rural)
              'V0221', # existencia de motocicleta para uso particular (1 sim, 2 nao)
              'V0222', # existencia de automovel para uso particular (1 sim, 2 nao)
              "V0203", # numero de comodos -> criar numero medio de comodos por domicilio
              "V6203", # densidade morador/cômodo
              "V6204", # densidade morador/dormitorio
              "V0401"),  # quantas pessoas moravam no domicilio 31/07/10)
  add_labels = "pt",
  as_data_frame = TRUE,
  showProgress = FALSE)

pop = read_population(year = 2010,
                       columns = c('code_muni',
                                   'V0001', # UF
                                   'V0002', # codigo municipio
                                   'V0011', # area ponderacao
                                   'V0010', # peso amostral
                                   "V0300", # controle
                                   "V1006", # situacao do domicilio (1 urbana ou 2 rural)
                                   "V0601", # sexo
                                   "V6400", # nivel de instrucao
                                   "V6036", # idade calculada em anos
                                   "V6930", # posicao na ocupacao
                                   "V0648", # nesse trabalho era
                                   "V6471", # atividade CNAE
                                   "V6462", # ocupacao CBO
                                   "V6920", # situacao na ocupacao (2- nao ocupadas) -> USAR ESSE
                                   "V0661", # retorna do trabalho para casa diariamente (1 sim, 2 nao)
                                   "V0662", # tempo deslocamento casa-trabalho
                                   "V0606", # raca
                                   "V0660", # em que municipio e UF trabalha
                                   "V6531", # rendimento domiciliar (domicilio particular) per capita julho 2010
                                   "V0641", # trabalho remunerado
                                   "V0642", # tinha trabalho remunerado do qual estava temporariamente afastado
                                   "V6940", # subgrupo e categoria no emprego principal (grupo c/ trab. domestico)
                                   "V0651", # qual o rendimento bruto trab principal (n tem, dinheiro, somente beneficios)
                                   "V6513"),  # rendimento trabalho principal
                add_labels = 'pt',
                as_data_frame = TRUE,
                showProgress = FALSE)

#filtrar apenas os estados BNU/LON/CX

dom_BNU = subset(dom, dom$code_muni == 4202404)
dom_LON = subset(dom, dom$code_muni == 4113700)
dom_CX = subset(dom, dom$code_muni == 4305108)

pop_BNU = subset(pop, pop$code_muni == 4202404)
pop_LON = subset(pop, pop$code_muni == 4113700)
pop_CX = subset(pop, pop$code_muni == 4305108)

#Salvar data frame em formato RDS e xlsx com as variáveis acima, por município

library(writexl)

saveRDS(
  object = dom,
  file = '../../data/urbanformbr/censo/dom.rds',
  compress = 'xz'
)

saveRDS(
  object = pop,
  file = '../../data/urbanformbr/censo/pop.rds',
  compress = 'xz'
)

saveRDS(
  object = dom_BNU,
  file = '../../data/urbanformbr/censo/dom_BNU.rds',
  compress = 'xz'
)

saveRDS(
  object = dom_LON,
  file = '../../data/urbanformbr/censo/dom_LON.rds',
  compress = 'xz'
)

saveRDS(
  object = dom_CX,
  file = '../../data/urbanformbr/censo/dom_CX.rds',
  compress = 'xz'
)

saveRDS(
  object = pop_BNU,
  file = '../../data/urbanformbr/censo/pop_BNU.rds',
  compress = 'xz'
)

saveRDS(
  object = pop_LON,
  file = '../../data/urbanformbr/censo/pop_LON.rds',
  compress = 'xz'
)

saveRDS(
  object = pop_CX,
  file = '../../data/urbanformbr/censo/pop_CX.rds',
  compress = 'xz'
)

write_xlsx(dom, "../../data/urbanformbr/censo/dom.xlsx")
write_xlsx(dom_BNU, "../../data/urbanformbr/censo/dom_BNU.xlsx")
write_xlsx(dom_LON, "../../data/urbanformbr/censo/dom_LON.xlsx")
write_xlsx(dom_CX, "../../data/urbanformbr/censo/dom_CX.xlsx")
write_xlsx(pop, "../../data/urbanformbr/censo/pop.xlsx")
write_xlsx(pop_BNU, "../../data/urbanformbr/censo/pop_BNU.xlsx")
write_xlsx(pop_LON, "../../data/urbanformbr/censo/pop_LON.xlsx")
write_xlsx(pop_CX, "../../data/urbanformbr/censo/pop_CX.xlsx")
























