# set your database connection info here

.onLoad <- function(libname, pkgname) {
  Sys.setenv("DB_HOST" = "localhost")
  Sys.setenv("DB_USER" = "postgres")
  Sys.setenv("DB_PASSWORD" = "postgres")
  Sys.setenv("DB_NAME" = "postgres")
  Sys.setenv("DB_PORT" = "5432")
  Sys.setenv("DB_SCHEMA" = "public")
}

