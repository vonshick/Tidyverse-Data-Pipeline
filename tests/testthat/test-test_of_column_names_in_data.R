test_that("Check if required columns are present in class dataset", {
  data_sets_list <- check_id_uniqueness()

  expect_true(
    all(c("id", "name", "teaching_hours") %in% colnames(data_sets_list$class))
  )
})

test_that("Check if required columns are present in test_level dataset", {
  data_sets_list <- check_id_uniqueness()

  expect_true(
    all(c("id", "displayName", "created_at") %in% colnames(data_sets_list$test_level))
  )
})
