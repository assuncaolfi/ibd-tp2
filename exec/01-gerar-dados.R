# cliente --------------------------------------------------------------------

n_cliente <- 100000
cliente <- tibble(
  id_cliente = 1:n_cliente,
  nome_cliente = randomNames(n_cliente, ethnicity = 4),
  passaporte_cliente = gerar_passaporte(n_cliente),
  # tipo_cliente = gerar_tipo_cliente(n_cliente), PJ, PF
  situacao_cliente = gerar_situacao_cliente(n_cliente)
)

# loja -----------------------------------------------------------------------

n_loja <- 100
loja <-
  n_loja |>
  gerar_cidades() |>
  suppressWarnings() |>
  suppressMessages() |>
  mutate(id_loja = 1:n_loja) |>
  select(id_loja, everything())

# veiculo --------------------------------------------------------------------

n_veiculo <- 10000
veiculo <-
  n_veiculo |>
  gerar_carros() |>
  suppressWarnings() |>
  mutate(
    id_veiculo = 1:n_veiculo,
    id_loja = sample(n_loja, n_veiculo, replace = TRUE),
    situacao_veiculo = gerar_situacao_veiculo(n_veiculo)
  ) |>
  select(id_veiculo, id_loja, everything())

# funcionario ----------------------------------------------------------------

n_funcionario <- 1000
funcionario <- tibble(
  id_funcionario = 1:n_funcionario,
  id_loja = sample(n_loja, n_funcionario, replace = TRUE),
  nome_funcionario = randomNames(n_funcionario, ethnicity = 4),
  passaporte_funcionario = gerar_passaporte(n_funcionario),
  situacao_funcionario = gerar_situacao_funcionario(n_funcionario),
  cargo_funcionario = gerar_cargo_funcionario(n_funcionario),
  salario_funcionario = rexp(n_funcionario, 2500)
)


# aluguel --------------------------------------------------------------------

n_aluguel <- 1000000
n_itens <- 3000000
aluguel <- tibble(
  id_aluguel = 1:n_aluguel,
  id_cliente = sample(n_cliente, n_aluguel, replace = TRUE),
  id_funcionario = sample(n_funcionario, n_aluguel, replace = TRUE),
  id_itens = sample(n_itens, n_aluguel, replace = TRUE),
  data_aluguel = gerar_data_aluguel(n_aluguel),
  dias_aluguel = rgeom(n_aluguel, 0.1) + 1,
  status_aluguel = TRUE, # TODO
  valor_base_aluguel = 10, # TODO
  valor_multa_aluguel = 10, # TODO
  valor_danos_aluguel = 10 # TODO
)

# itens ---------------------------------------------------------------------

itens <- tibble(
  id_itens = 1:n_itens,
  id_veiculo = sample(n_veiculo, n_itens, replace = TRUE)
)

# entidades -------------------------------------------------------------------

entidades <- list(
  aluguel = aluguel,
  cliente = cliente,
  funcionario = funcionario,
  loja = loja,
  itens = itens,
  veiculo = veiculo
)
caminhos <-
  "dados" |>
  file.path("output", names(entidades)) |>
  paste0(".csv")
map2(entidades, caminhos, write_csv)
