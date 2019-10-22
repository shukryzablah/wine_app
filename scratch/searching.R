library(dplyr)
library(purrr)
library(stringr)

search_file_for_pattern <- function(file_name, pattern) {
    raw <- readLines(paste0("../poems-processed/", file_name))
    mask <- str_detect(raw, regex(pattern, ignore_case = T))
    hits <- tibble(file = file_name, matches = raw[mask])
    return(hits)
}

search_files_for_pattern <- function(file_names, pattern) {
    all_hits <- file_names %>%
        map_dfr(search_file_for_pattern, pattern)
    return(all_hits)
}

file_names <- fs::dir_ls("../poems-processed")
search_files_for_pattern(file_names, "love")
