# data_sets <- get_raw_data_sets()

# test <- data_sets$test
# test_level <- data_sets$test_level
# class <- data_sets$class

# # check if IDs are unique
# nrow(test) == test %>% distinct(id) %>% count()
# nrow(class) == class %>% distinct(id) %>% count() 
# nrow(test_level) == test_level %>% distinct(id) %>% count() 

# # check if there are only values 1 and 0 in class 
# class %>% distinct(has_student_with_scored_test)

# # check what are the values of test_status in test table
# test %>% distinct(test_status)

# # check if all dates match the same pattern
# nrow(test) == test %>% filter(is.na(updated_at) | str_detect(updated_at, '[0-9]{2}.[0-9]{2}.[0-9]{2} [0-9]{2}:[0-9]{2}')) %>% count()
# nrow(test) == test %>% filter(is.na(created_at) | str_detect(created_at, '[0-9]{2}.[0-9]{2}.[0-9]{2} [0-9]{2}:[0-9]{2}')) %>% count()
# nrow(test) == test %>% filter(is.na(authorized_at) | str_detect(authorized_at, '[0-9]{2}.[0-9]{2}.[0-9]{2} [0-9]{2}:[0-9]{2}')) %>% count()

# nrow(class) == class %>% filter(is.na(updated_at) | str_detect(updated_at, '[0-9]{2}.[0-9]{2}.[0-9]{2} [0-9]{2}:[0-9]{2}')) %>% count()
# nrow(class) == class %>% filter(is.na(created_at) | str_detect(created_at, '[0-9]{2}.[0-9]{2}.[0-9]{2} [0-9]{2}:[0-9]{2}')) %>% count()
# nrow(class) == class %>% filter(is.na(latest_test_time) | str_detect(latest_test_time, '[0-9]{2}.[0-9]{2}.[0-9]{2} [0-9]{2}:[0-9]{2}')) %>% count()

# nrow(test_level) == test_level %>% filter(is.na(updated_at) | str_detect(updated_at, '[0-9]{2}.[0-9]{2}.[0-9]{2} [0-9]{2}:[0-9]{2}')) %>% count()
# nrow(test_level) == test_level %>% filter(is.na(created_at) | str_detect(created_at, '[0-9]{2}.[0-9]{2}.[0-9]{2} [0-9]{2}:[0-9]{2}')) %>% count()
