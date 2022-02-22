# modelo ----------------------------------------------------------------------

modelo <-
  dm() |>
  dm_add_tbl(!!!entidades) |>
  dm_add_pk(aluguel, id_aluguel) |>
  dm_add_pk(cliente, id_cliente) |>
  dm_add_pk(funcionario, id_funcionario) |>
  dm_add_pk(loja, id_loja) |>
  dm_add_pk(itens, id_itens) |>
  dm_add_pk(veiculo, id_veiculo) |>
  dm_add_fk(aluguel, id_cliente, cliente) |>
  dm_add_fk(aluguel, id_funcionario, funcionario) |>
  dm_add_fk(aluguel, id_itens, itens) |>
  dm_add_fk(funcionario, id_loja, loja) |>
  dm_add_fk(itens, id_veiculo, veiculo) |>
  dm_add_fk(veiculo, id_loja, loja) |>
  write_rds("dados/output/modelo.rds")

# diagrama --------------------------------------------------------------------

x <- dm_draw(
  modelo,
  view_type = "all",
  columnArrows = FALSE,
  edge_attrs = "dir = both, arrowtail = crowodot, arrowhead = teetee",
  node_attrs = "fontname = Helvetica",
  column_types = TRUE
)
x |>
  pluck("x") |>
  pluck("diagram") |>
  str_split("\n") |>
  unlist() |>
  write_lines("dados/output/diagram.txt")
