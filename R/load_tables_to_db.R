#'@import RPostgres
set_up_db_connection <- function() {
  database_connection <- dbConnect(
    Postgres(),
    host = Sys.getenv("DB_HOST"),
    user = Sys.getenv("DB_USER"),
    password = Sys.getenv("DB_PASSWORD"),
    dbname = Sys.getenv("DB_NAME"),
    port = Sys.getenv("DB_PORT"),
    options = paste("-c search_path=", Sys.getenv("DB_SCHEMA"), sep = "")
  )

  return(database_connection)
}

#'@import RPostgres
load_table_to_database <- function(data_set, data_set_name) {
  tryCatch({
    database_connection <- set_up_db_connection()
    dbBegin(database_connection)
    dbWriteTable(database_connection, data_set_name, data_set, append = TRUE)
    dbCommit(database_connection)
    print(paste("Loading to", data_set_name, "succeded", sep = " "))
  }, error = function(err){
    dbRollback(database_connection)
    print(paste("Loading to", data_set_name, "failed:", err, sep = " "))
  }, finally = {
    dbDisconnect(database_connection)
  })
}

#'@import tidyverse
#'@export
load_tables_to_db <- function() {
  output_data_sets <- generate_output_data_sets()
  load_logs <- map2(
      output_data_sets,
      names(output_data_sets),
      function(data_set, data_set_name) load_table_to_database(data_set, data_set_name)
  )
}

