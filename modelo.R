library(dm)
library(lubridate)
library(randomNames)
library(readr)
library(rlang)
library(tidyverse)
source("R/gerar.R")
set.seed(0)

# Clientes --------------------------------------------------------------------

n_clientes <- 100000
clientes <- tibble(
  id_cliente = 1:n_clientes,
  nome_cliente = randomNames(n_clientes, ethnicity = 4),
  passaporte_cliente = gerar_passaporte(n_clientes),
  # tipo_cliente = gerar_tipo_cliente(n_clientes), PJ, PF
  situacao_cliente = gerar_situacao_cliente(n_clientes)
)

# Lojas -----------------------------------------------------------------------

n_lojas <- 100
lojas <-
  n_lojas |>
  gerar_cidades() |>
  suppressWarnings() |>
  suppressMessages() |>
  mutate(id_loja = 1:n_lojas) |>
  select(id_loja, everything())

# Veiculos --------------------------------------------------------------------

n_veiculos <- 10000
veiculos <-
  n_veiculos |>
  gerar_carros() |>
  suppressWarnings() |>
  mutate(
    id_veiculo = 1:n_veiculos,
    id_loja = sample(n_lojas, n_veiculos, replace = TRUE),
    situacao_veiculo = gerar_situacao_veiculo(n_veiculos)
  ) |>
  select(id_veiculo, id_loja, everything())

# Funcionarios ----------------------------------------------------------------

n_funcionarios <- 1000
funcionarios <- tibble(
  id_funcionario = 1:n_funcionarios,
  id_loja = sample(n_lojas, n_funcionarios, replace = TRUE),
  nome_funcionario = randomNames(n_funcionarios, ethnicity = 4),
  passaporte_funcionario = gerar_passaporte(n_funcionarios),
  situacao_funcionario = gerar_situacao_funcionario(n_funcionarios),
  cargo_funcionario = gerar_cargo_funcionario(n_funcionarios),
  salario_funcionario = rexp(n_funcionarios, 2500)
)


# Alugueis --------------------------------------------------------------------

n_alugueis <- 1000000
n_objetos <- 3000000
alugueis <- tibble(
  id_aluguel = 1:n_alugueis,
  id_cliente = sample(n_clientes, n_alugueis, replace = TRUE),
  id_funcionario = sample(n_funcionarios, n_alugueis, replace = TRUE),
  id_objeto = sample(n_objetos, n_alugueis, replace = TRUE),
  data_aluguel = gerar_data_aluguel(n_alugueis),
  dias_aluguel = rgeom(n_alugueis, 0.1) + 1,
  status_aluguel = TRUE, # TODO
  valor_base_aluguel = 10, # TODO
  valor_multa_aluguel = 10, # TODO
  valor_danos_aluguel = 10 # TODO
)

# Objetos ---------------------------------------------------------------------

objetos <- tibble(
  id_objeto = 1:n_objetos,
  id_veiculo = sample(n_veiculos, n_objetos, replace = TRUE)
)

# Modelo ----------------------------------------------------------------------

entidades <- list(
  alugueis = alugueis,
  clientes = clientes,
  funcionarios = funcionarios,
  lojas = lojas,
  objetos = objetos,
  veiculos = veiculos
)
caminhos <-
  "dados" |>
  file.path("output", names(entidades)) |>
  paste0(".csv")
map2(entidades, caminhos, write_csv)

modelo <-
  dm() |>
  dm_add_tbl(!!!entidades) |>
  dm_add_pk(alugueis, id_aluguel) |>
  dm_add_pk(clientes, id_cliente) |>
  dm_add_pk(funcionarios, id_funcionario) |>
  dm_add_pk(lojas, id_loja) |>
  dm_add_pk(objetos, id_objeto) |>
  dm_add_pk(veiculos, id_veiculo) |>
  dm_add_fk(alugueis, id_cliente, clientes) |>
  dm_add_fk(alugueis, id_funcionario, funcionarios) |>
  dm_add_fk(alugueis, id_objeto, objetos) |>
  dm_add_fk(funcionarios, id_loja, lojas) |>
  dm_add_fk(objetos, id_veiculo, veiculos) |>
  dm_add_fk(veiculos, id_loja, lojas) |>
  write_rds("dados/output/modelo.rds")

dm_draw(modelo, view_type = "all")
