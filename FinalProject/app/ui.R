library(leaflet)

navbarPage("Wine Explorer", id = "nav",
           
           #########
           ## MAP ##
           #########
           tabPanel("Interactive Map",
                    div(class = "outer",
                        ## insert custom css
                        tags$head(
                                 includeCSS("styles.css"),
                                 includeScript("gomap.js")
                             ),
                        ## map
                        ## set dim to px if not using styles.css
                        leafletOutput("map",
                                      width = "100%", 
                                      height = "100%"),
                        ## control panel
                        absolutePanel(id = "controls",
                                      class = "panel panel-default",
                                      fixed = TRUE,
                                      draggable = TRUE,
                                      top = 60,
                                      left = "auto",
                                      right = 20,
                                      bottom = "auto",
                                      width = 330,
                                      height = "auto",
                                      h2("Wine Explorer"),
                                      selectInput("distinguish",
                                                  "Distinguish",
                                                  c("avg_points",
                                                    "avg_price"))
                                      )
                        )
                    ),
           
           #############
           ## Catalog ##
           #############
           tabPanel("Catalog",
                    DT::dataTableOutput("winetable")
                    )
           )

