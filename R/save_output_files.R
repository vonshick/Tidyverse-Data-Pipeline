#' @import readr
#' @export
save_output_csv_files <- function() {
  output_data_sets <- generate_output_data_sets()

  write_csv(
    output_data_sets$test_utilization,
    path = "data_files/test_utilization.csv"
  )
  write_csv(
    output_data_sets$test_average_scores,
    path = "data_files/test_average_scores.csv"
  )
}
