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
                                                         maxItems = 3)
                                                     )
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
                    sidebarPanel(tags$h1("Prediction Engine"),
                                 tags$br(),
                                 tags$p("Estimate the quality of a wine with this app by entering country, price, description, province, and variety. The estimate is based off a model using a gradient boosting algorithm. The variables with the highest relative influence are price, province, and variety.
")
                                 ),
                    mainPanel(selectizeInput("country",
                                             "Country",
                                             selected = "Portugal",
                                             choices = countries,
                                             multiple = TRUE,
                                             width = "700px",
                                             options = list(
                                                 maxItems = 1)
                                             ),
                              sliderInput("price",
                                          "Price",
                                          min = 0,
                                          max = 250,
                                          step = 1,
                                          value = 30,
                                          width = "700px"
                                          ),
                              textAreaInput("description",
                                            "Description",
                                            value = "This is a solidly structured wine that has big tannins in place. That will change as the wine ages further, bringing the rich black fruits forward and reveling in the perfumed acidity of the wine. Drink from 2021.",
                                            width = "700px"),
                              selectizeInput("province",
                                             "Province",
                                             selected = "Dão",
                                             choices = provinces,
                                             multiple = TRUE,
                                             width = "700px",
                                             options = list(
                                                 maxItems = 1)
                                             ),
                              selectizeInput("variety2",
                                             "Variety",
                                             selected = "Portuguese Red",
                                             choices = varieties,
                                             width = "700px",
                                             multiple = TRUE,
                                             options = list(
                                                 maxItems = 1)
                                             ),
                              tags$h1(textOutput("estimate"))
                              )
                    )
           )
