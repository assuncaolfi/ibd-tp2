gerar_passaporte <- function(n) {
  numeros <- as.character(0:9)
  letras <- LETTERS
  1:n |>
    map(sample, x = c(numeros, letras), size = 9) |>
    map_chr(paste, collapse = "")
}

gerar_situacao <- function(n, situacoes, probs) {
  sample(situacoes, n, probs, replace = TRUE)
}

gerar_situacao_cliente <- partial(
  gerar_situacao,
  situacoes = c("IRREGULAR", "REGULAR"),
  probs = c(0.05, 0.95)
)

gerar_carros <- function(n) {
  mtcars |>
    rownames() |>
    tibble() |>
    set_names("carro") |>
    separate(
      col = carro,
      into = c("marca_veiculo", "modelo_veiculo"),
      sep = " "
    ) |>
    drop_na() |>
    slice_sample(n = n, replace = TRUE)
}

gerar_situacao_veiculo <- partial(
  gerar_situacao,
  situacoes = c("INATIVO", "ATIVO"),
  probs = c(0.05, 0.95)
)

gerar_cidades <- function(n) {
  "dados" |>
    file.path("input", "cidades-latam.csv") |>
    read_delim() |>
    set_names(str_to_lower) |>
    select(city, country, population) |>
    mutate(population = parse_number(population)) |>
    slice_sample(n = n, replace = TRUE, weight_by = population) |>
    transmute(cidade_loja = city, pais_loja = country)
}

gerar_situacao_funcionario <- partial(
  gerar_situacao,
  situacoes = c(
    "CONTRATADO",
    "DESLIGADO",
    "PESSOA JURIDICA"
  ),
  probs = c(0.8, 0.1, 0.1)
)

gerar_cargo_funcionario <- partial(
  gerar_situacao,
  situacoes = c(
    "VENDEDOR",
    "GERENTE"
  ),
  probs = c(0.7, 0.3)
)

gerar_data_aluguel <- function(n) {
  hoje <- today()
  inicio <- hoje - years(3)
  datas <- seq(inicio, hoje, "days")
  datas |>
    sample(n, replace = TRUE) |>
    sort() |>
    as.Date()
}
