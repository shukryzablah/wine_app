## https://shiny.rstudio.com/articles/scoping.html

library(dplyr)

Wines <- readr::read_csv("data/geocoded.csv.gz")

Wineries <- Wines %>%
    group_by(address, lat, lon) %>%
    summarize(num_entries = n(), 
              avg_points = mean(points, na.rm = TRUE),
              avg_price = mean(points, na.rm = TRUE)) %>%
    tidyr::drop_na() %>%
    ungroup()
