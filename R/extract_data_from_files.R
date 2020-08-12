extract_files_from_zip <- function(data_directory) {
  tryCatch({
    unzip(zipfile = file.path(data_directory, "OneDrive_1_29.07.2020.zip"), exdir = data_directory)
    print("CSV files were extracted from zip to data_files directory.")
  }, error = function(err){
    print(paste("Extracting files from ZIP failed:", err, sep = " "))
  })
}

#' @import readr
extract_data_from_csv_files <- function() {
  data_directory <- Sys.getenv("DATA_FILE_DIRECTORY")
  extract_files_from_zip(data_directory)

  class <- read_delim(file = file.path(data_directory, 'class.csv'), delim = ';')
  test_level <- read_delim(file = file.path(data_directory, 'test_level.csv'), delim = ';')
  test <- read_delim(fil = file.path(data_directory, 'test.csv'), delim = ';')

  return(list(class = class, test_level = test_level, test = test))
}

#' @import dplyr
check_if_id_is_unique <- function(data_set) {
  distinct_ids_count <- data_set %>%
    distinct(id) %>%
    count()

  if(distinct_ids_count != nrow(data_set)) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

#' @import purrr
#' @import dplyr
#' @export
check_id_uniqueness <- function() {
  data_sets_list <- extract_data_from_csv_files()

  is_id_unique_for_datasets <- map_lgl(
    data_sets_list,
    function(data_set) check_if_id_is_unique(data_set)
  )

  if(FALSE %in% is_id_unique_for_datasets) {
    print(
      lapply(
        names(data_sets_list)[!is_id_unique_for_datasets],
        function(data_set_name) paste(data_set_name, "ID is not unique", sep = " ")
      )
    )
  } else {
    print("ID was unique for all data sets")
  }

  return(data_sets_list)
}
