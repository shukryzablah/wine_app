library(RColorBrewer)
library(stringr)
library(purrr)
library(SnowballC)
library(gbm)
library(textmineR)

load("data/estimatepoints_function.Rda")
boost_wine <- readRDS("data/boost_wine500.rds")

function(input, output, session) {

    ######################
    ## Helper Functions ##
    ######################
    show_winery_popup <- function(winery_address, lat, lng) {
        selectedWinery <- Wineries %>%
            filter(address == winery_address)
        
        content <- as.character(tagList(
            tags$h4("Name: ", selectedWinery$address),
            tags$br(),
            sprintf("Number of Entries in Database: %s",
                    selectedWinery$num_entries),
            tags$br(),
            sprintf("Avg Points: %s", round(selectedWinery$avg_points),2),
            tags$br(),
            sprintf("Avg Price: %s", round(selectedWinery$avg_price,2))
        ))
        
        leafletProxy("map") %>%
            addPopups(lng, lat, content, layerId = winery_address)
    }

    
    #########
    ## Map ##
    #########
    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                     attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>%
            addEasyButton(
                easyButton(
                    icon="fa-globe",
                    title="World-View Zoom",
                    onClick=JS("function(btn, map){ map.setZoom(3); }"))) %>%
            addMiniMap(tiles = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                       toggleDisplay = TRUE,
                       width = 300,
                       height = 300)
    })


    ###############################
    ## Observers (Map Modifiers) ##
    ###############################

    ## 1. change marker colors on input change
    observe({
        distinguishBy <- input$distinguish
        colorData <- Wineries[[distinguishBy]]
        pal <- colorQuantile("viridis", colorData, 3)

        mapData <- Wineries
        if(!is.null(input$variety)) {
            mapData <- Wineries %>%
                filter(map_lgl(varieties, ~ any(input$variety %in% .x)))
        }
       
        leafletProxy("map", data = mapData) %>%
            clearMarkerClusters() %>%
            clearShapes() %>%
            fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat)) %>%
            addCircleMarkers(~lon, ~lat, radius = ~num_entries / 10,
                             layerId = ~address, stroke = FALSE,
                             fillOpacity = 0.5, fillColor = pal(colorData)) %>%
            addLegend("bottomleft", pal = pal,
                      values = colorData, title = distinguishBy,
                      layerId = "colorLegend") 
    })

    ## 2. show popup when map is clicked
    observe({
        leafletProxy("map") %>%
            clearPopups()
        event <- input$map_marker_click
        if (is.null(event))
            return()

        isolate({
            show_winery_popup(event$id, event$lat, event$lng)
        })
    })

    ## 3. when wine in table is clicked, go to winery in map
    observe({
        if (is.null(input$goto))
            return()
        
        dist <- 0.5
        address <- input$goto$address
        lat <- input$goto$lat
        lon <- input$goto$lon
        isolate({
            leafletProxy("map") %>%
                clearPopups() %>%
                fitBounds(lon - dist, lat - dist, lon + dist, lat + dist)
            show_winery_popup(address, lat, lon)
        })
    })


    ############################
    ## Plotly Summary Graphic ##
    ############################
    output$price <- renderPlotly({
        ggplotly(
            ggplot(diamonds, aes(x = carat)) +
            geom_histogram()
        )
    })

    
    #############
    ## Catalog ##
    #############
    output$winetable <- DT::renderDataTable({
        df <- Wines %>%
            mutate(locate = paste('<a class="go-map" href="" data-lat="', lat,
                                  '" data-lon="', lon,
                                  '" data-address="', address,
                                  '"><i class="fa fa-crosshairs"></i></a>',
                                  sep="")) %>%
            select(title, variety, points, price, country, province,
                   locate, taster_name, variety, address, lat, lon,
                   description) %>%
            rename_all(stringr::str_to_title)

        
        action <- DT::dataTableAjax(session, df, outputId = "winetable")
        DT::datatable(df,
                      options = list(ajax = list(url = action)),
                      escape = FALSE)
    })

    ############################
    ## Model Point Estimation ##
    ############################

    output$estimate <- renderText({
        estimatepoints(country = input$country,
                       price = input$price,
                       description = input$description,
                       province = input$province,
                       variety = input$variety2)
    })
    
}
