extract_files_from_zip <- function() {
  tryCatch({
    unzip(zipfile = "data_files/OneDrive_1_29.07.2020.zip", exdir ="data_files")
    print("CSV files were extracted from zip to data_files directory.")
  }, error = function(err){
    print(paste("Extracting files from ZIP failed:", err, sep = " "))
  })
}

#' @import readr
load_data_from_csv_files <- function() {
  extract_files_from_zip()

  class <- read_delim(file = 'data_files/class.csv', delim = ';')
  test_level <- read_delim(file = 'data_files/test_level.csv', delim = ';')
  test <- read_delim(fil = 'data_files/test.csv', delim = ';')

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
  data_sets_list <- load_data_from_csv_files()

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
