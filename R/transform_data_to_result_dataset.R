#' @import dplyr
prepare_data_sets_to_join <- function() {
  data_sets_list <- get_raw_data_sets()

  class_info <- data_sets_list$class %>%
    select(id, name, teaching_hours) %>%
    rename(class_id = id, class_name = name)

  test_level_info <- data_sets_list$test_level %>%
    select(id, displayName, created_at) %>%
    rename(test_level_id = id, test_level = displayName, test_created_at = created_at)

  return(list(test = data_sets_list$test, class_info = class_info, test_level_info = test_level_info))
}

#' @import dplyr
generate_output_data_sets <- function() {
  data_sets_list <- prepare_data_sets_to_join()

  test <- data_sets_list$test
  test_level_info <- data_sets_list$test_level_info
  class_info <- data_sets_list$class_info

  test_utilization <- test %>%
    rename(test_id = id, test_authorized_at = authorized_at) %>%
    filter(!is.na(test_authorized_at)) %>%
    left_join(class_info, by = "class_id") %>%
    left_join(test_level_info, by = "test_level_id") %>%
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
    left_join(test_level_info, by = "test_level_id") %>%
    select(class_id, class_name, teaching_hours, test_created_at, test_authorized_at, overall_score) %>%
    group_by(class_id, class_name, teaching_hours, test_created_at, test_authorized_at) %>%
    mutate(
      avg_class_test_overall_score = mean(overall_score, na.rm = TRUE)
    )

  return(list(test_utilization = test_utilization, test_average_scores = test_average_scores))
}
