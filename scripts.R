library(tidyverse)
library(RPostgres)

# setwd("~/Downloads/download/OneDrive_1_29.07.2020/")

# default credentials
Sys.setenv("DB_HOST" = "localhost")
Sys.setenv("DB_USER" = "postgres")
Sys.setenv("DB_PASSWORD" = "postgres")
Sys.setenv("DB_NAME" = "postgres")
Sys.setenv("DB_PORT" = "5432")
Sys.setenv("DB_SCHEMA" = "public")

database_connection <- dbConnect(
  Postgres(),
  host = Sys.getenv("DB_HOST"),
  user = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASSWORD"),
  dbname = Sys.getenv("DB_NAME"),
  port = Sys.getenv("DB_PORT"),
  options = paste("-c search_path=", Sys.getenv("DB_SCHEMA"), sep = "")
)

load_table_to_database <- function(table_name, data_to_load, database_connection) {
  tryCatch({
    dbBegin(database_connection)
    dbWriteTable(database_connection, table_name, data_to_load, append = TRUE)
    dbCommit(database_connection)
    print(paste("Loading to", table_name + " succeded", sep = " "))
  }, error = function(err){
    dbRollback(database_connection)
    print(paste("Loading to" + table_name + "failed:", err, sep = " "))
  }, finally = {
    dbDisconnect(database_connection)
  })
}

class <- read_delim(file = 'class.csv', delim = ';')
test_level <- read_delim(file = 'test_level.csv', delim = ';')
test <- read_delim(fil = 'test.csv', delim = ';')

check_if_id_is_unique <- function(data_set, data_set_name) {
  distinct_ids_count <- data_set %>%
    distinct(id) %>%
    count()

  if(distinct_ids_count != nrow(data_set)) {
    print(data_set_name + " ID was not unique")
    return(FALSE)
  } else {
    return(TRUE)
  }
}

map2(list(test, test_level, class), list("test", "test_level", "class"), function(data_set, data_set_name) check_if_id_is_unique(data_set, data_set_name))

class_info <- class %>%
  select(id, name, teaching_hours) %>%
  rename(class_id = id, class_name = name)

test_info <- test_level %>%
  select(id, displayName, created_at) %>%
  rename(test_level_id = id, test_level = displayName, test_created_at = created_at)

column_picked <- c("class_id","class_name","teaching_hours","test_id","test_created_at", "test_authorized_at","test_level")

test_utilization <- test %>%
  rename(test_id = id, test_authorized_at = authorized_at) %>%
  filter(!is.na(test_authorized_at)) %>%
  left_join(class_info, by = "class_id") %>%
  left_join(test_info, by = "test_level_id") %>%
  select(class_id, class_name, teaching_hours, test_id, test_created_at, test_authorized_at, test_level) %>%
  arrange(class_id, class_name, teaching_hours, test_id, test_created_at, test_authorized_at, test_level) %>%
  group_by(class_id, class_name, teaching_hours, test_created_at, test_authorized_at, test_level) %>%
  mutate(
    class_test_number = row_number()
  )

test_average_scores <- test %>%
  rename(test_id = id, test_authorized_at = authorized_at) %>%
  filter(!is.na(test_authorized_at) & test_status == "SCORING_SCORED") %>%
  left_join(class_info, by = "class_id") %>%
  left_join(test_info, by = "test_level_id") %>%
  select(class_id, class_name, teaching_hours, test_created_at, test_authorized_at, overall_score) %>%
  group_by(class_id, class_name, teaching_hours, test_created_at, test_authorized_at) %>%
  mutate(
    avg_class_test_overall_score = mean(overall_score, na.rm = TRUE)
  )

write_csv(test_utilization, path = "test_utilization.csv")
write_csv(test_average_scores, path = "test_average_scores.csv")



