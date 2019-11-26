library(leaflet)
library(RColorBrewer)
library(dplyr)

function(input, output, session) {

    ######################
    ## Helper Functions ##
    ######################
    showWineryPopup <- function(winery_address, lat, lng) {
        selectedWinery <- Wineries %>%
            filter(address == winery_address)
        
        content <- as.character(tagList(
            tags$h4("Name: ", selectedWinery$address),
            tags$br(),
            sprintf("Avg Points: %s", selectedWinery$avg_points),
            tags$br(),
            sprintf("Avg Price: %s", selectedWinery$avg_price)
        ))
        
        leafletProxy("map") %>%
            addPopups(lng, lat, content, layerId = winery_address)
    }

    
    #########
    ## Map ##
    #########
    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%
            addEasyButton(
                easyButton(
                    icon="fa-globe",
                    title="World-View Zoom",
                    onClick=JS("function(btn, map){ map.setZoom(2); }")))
    })

    ###############################
    ## Observers (Map Modifiers) ##
    ###############################

    ## 1. change marker colors on input change
    observe({
        distinguishBy <- input$distinguish
        colorData <- Wineries[[distinguishBy]]
        pal <- colorBin("viridis", colorData, 5, pretty = FALSE)
        radius <- Wineries[[distinguishBy]] /
            max(Wineries[[distinguishBy]], na.rm = TRUE) * 10

        leafletProxy("map", data = Wineries) %>%
            clearShapes() %>%
            fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat)) %>%
            addCircleMarkers(~lon, ~lat, radius = radius,
                       layerId = ~address, stroke = FALSE,
                       fillOpacity = 0.5, fillColor = pal(colorData),
                       clusterOptions = markerClusterOptions(),
                       clusterId = "wineCluster") %>%
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
            showWineryPopup(event$id, event$lat, event$lng)
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
            showWineryPopup(address, lat, lon)
        })
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
}
