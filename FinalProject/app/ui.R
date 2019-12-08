navbarPage("Wine Explorer", id = "nav",
           
           #########
           ## MAP ##
           #########
           tabPanel("Interactive Map",
                    div(class = "outer",
                        ## insert custom css and js
                        tags$head(
                                 includeCSS("styles.css"),
                                 includeScript("gomap.js")
                             ),
                        ## plot map
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
                                      width = 500,
                                      height = "auto",
                                      h2("Wine Explorer"),
                                      selectInput("distinguish",
                                                  "Distinguish",
                                                  c("avg_points",
                                                    "avg_price")),
                                      selectizeInput("variety",
                                                     "Variety",
                                                     choices = varieties,
                                                     multiple = TRUE,
                                                     options = list(
                                                         maxOptions = 5,
                                                         maxItems = 3)
                                                     ),
                                      plotlyOutput("price")
                                      )
                        )
                    ),
           
           #############
           ## Catalog ##
           #############
           tabPanel("Catalog",
                    DT::dataTableOutput("winetable")
                    ),

           ############################
           ## Model Point Estimation ##
           ############################
           tabPanel("Quality Estimate",
                    selectizeInput("country",
                                   "Country",
                                   selected = "Portugal",
                                   choices = countries,
                                   options = list(
                                       maxOptions = 10)
                                   ),
                    sliderInput("price",
                                "Price",
                                min = 0,
                                max = 100,
                                step = 1,
                                value = 35
                                ),
                    textAreaInput("description",
                                  "Description",
                                  value = "This is a solidly structured wine that has big tannins in place. That will change as the wine ages further, bringing the rich black fruits forward and reveling in the perfumed acidity of the wine. Drink from 2021."),
                    textInput("province",
                              "Province",
                              value = "Dão"),
                    selectizeInput("variety2",
                                   "Variety",
                                   selected = "Portuguese Red",
                                   choices = varieties,
                                   options = list(
                                       maxOptions = 10)
                                  ),
                    textOutput("estimate")
                    )
           )

