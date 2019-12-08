## https://shiny.rstudio.com/articles/scoping.html

library(dplyr)
library(leaflet)
library(plotly)

Wines <- readr::read_csv("data/geocoded.csv.gz")

Wineries <- Wines %>%
    group_by(country, address, lat, lon) %>%
    summarize(num_entries = n(), 
              avg_points = mean(points, na.rm = TRUE),
              avg_price = mean(price, na.rm = TRUE),
              varieties = list(unique(variety)),
              designations = list(unique(designation))) %>%
    ungroup() %>%
    tidyr::drop_na() %>%
    mutate_at(vars(starts_with("avg")), round, 2)

varieties <- Wines %>% pull(variety) %>% unique()
