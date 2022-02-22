# database --------------------------------------------------------------------

# dbSendQuery(con, "DROP DATABASE locadora_veiculos")
con <- dbConnect(odbc(), dsn = "mysql")
criar_database <- read_file("SQL/01-criar-database.sql")
dbSendQuery(con, criar_database)
con <- dbConnect(odbc(), dsn = "mysql", database = "locadora_veiculos")

# tabelas ---------------------------------------------------------------------

queries <-
  con |>
  dm:::build_copy_queries(modelo, temporary = FALSE) |>
  mutate(table = dm_get_tables(modelo)[name]) |>
  write_rds("dados/output/create-table-index.rds")
tabelas_criadas <-
  queries |>
  select(statement = sql_table) |>
  pwalk(dbExecute, conn = con)
tabelas_adicionadas <-
  queries |>
  transmute(name = remote_name, value = table) |>
  pwalk(dbAppendTable, conn = con)
tabelas_indexadas <-
  queries |>
  select(statement = sql_index) |>
  flatten() |>
  keep(negate(is_null)) |>
  map_depth(2, dbExecute, conn = con)

# output ----------------------------------------------------------------------
