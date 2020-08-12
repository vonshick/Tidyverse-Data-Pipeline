#' @import readr
#' @export
save_output_csv_files <- function() {
  data_directory <- Sys.getenv("DATA_FILE_DIRECTORY")
  output_data_sets <- generate_output_data_sets()

  write_csv(
    output_data_sets$test_utilization,
    path = file.path(data_directory, 'test_utilization.csv')
  )
  write_csv(
    output_data_sets$test_average_scores,
    path = file.path(data_directory, 'test_average_scores.csv')
  )

  print(paste("Result data sets were exported to", data_directory, sep = " "))
}
