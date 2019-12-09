## https://shiny.rstudio.com/articles/scoping.html

library(dplyr)
library(leaflet)
library(plotly)

Wines <- readr::read_csv("data/geocoded.csv.gz") %>%
    tidyr::drop_na(country, address, lat, lon)
    
Wineries <- Wines %>%
    group_by(country, address, lat, lon) %>%
    summarize(num_entries = n(), 
              avg_points = mean(points, na.rm = TRUE),
              avg_price = mean(price, na.rm = TRUE),
              varieties = list(unique(variety))) %>%
    ungroup() %>%
    tidyr::drop_na() %>%
    mutate_at(vars(starts_with("avg")), round, 2)

varieties <- Wines %>% pull(variety) %>% unique()
countries <- Wines %>% pull(country) %>% unique()
provinces <- Wines %>% pull(province) %>% unique()

load("data/estimatepoints_function.Rda")
boost_wine <- readRDS("data/boost_wine500.rds")
