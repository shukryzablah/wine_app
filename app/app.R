library(shiny)
library(mosaic)
library(shinyWidgets)
library(purrr)
library(stringr)

#*****************START UI*******************************#

# Define UI for application that draws a histogram
ui <- fluidPage(
   
  # Application title
  titlePanel("Display a random Emily Dickinson poem (Gutenberg edition)"),
  
  sidebarLayout(
    sidebarPanel(
      p("Search for an Emily Dickinson poem or choose to display a poem at random below."),
      searchInput(
        inputId = "search_pattern",
        label = "Enter your search:", 
        value = "love",
        btnSearch = icon("search"), 
        btnReset = icon("remove"), 
        width = "100%"
      ),
      actionButton("pickpoem", "Pick a poem at random")),
    
    # Show a plot of the generated distribution
    mainPanel(verbatimTextOutput("displaypoem"),
              DT::DTOutput("search_matches"))
  )
)

#*****************END UI*******************************#

#*****************START SERVER*******************************#

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$displaypoem <- renderPrint({
    input$pickpoem

    directory <- "../poems-processed"
    
    files <- list.files(directory)
    n <- length(files)
    
    randnum <- sample(1:n, 1) 
    lines <- readLines(paste(directory, "/", files[randnum], sep=""))
    for (i in 1:length(lines)) {
      cat(paste(lines[i], "\n"))
    }
  })

####################################################
    output$search_matches <- DT::renderDT({
        messy <- search_files_for_pattern(file_names, input$search_pattern)
    })
}

#*****************END SERVER*******************************#

##################################################################
#################UTILITY FUNCTIONS FOR SEARCH######################

search_file_for_pattern <- function(file_name, pattern) {
    raw <- readLines(paste0("../poems-processed/", file_name))
    title <- raw[3]
    mask <- str_detect(raw, regex(pattern, ignore_case = T))
    hits <- tibble(title = title, matches = raw[mask])
    return(hits)
}

search_files_for_pattern <- function(file_names, pattern) {
    all_hits <- file_names %>%
        map_dfr(search_file_for_pattern, pattern)
    return(all_hits)
}

##################################################################
#######################LIST OF GLOBALS######################
file_names <- fs::dir_ls("../poems-processed")
###################################################################
##################################################################

# Run the application 
shinyApp(ui = ui, server = server)

