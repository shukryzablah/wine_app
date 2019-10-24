library(shiny)
library(mosaic)
library(shinyWidgets)
library(purrr)
library(stringr)
library(shinythemes)

#*****************START UI*******************************#

# Define UI for search app ----
ui <- fluidPage(theme = shinytheme("flatly"), response = TRUE,
  
  # App title ----
  titlePanel("Search for an Emily Dickinson Poem (Gutenberg edition) or Display a Random One"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: search bar & action button ----
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
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ poem, search matches, selected poem ----
      tabsetPanel(type = "tabs",
                  tabPanel("Random Poem", verbatimTextOutput("displaypoem")),
                  tabPanel("Search Matches", DT::DTOutput("search_matches"))
      )
    )
  )
)

#*****************END UI*******************************#

#*****************START SERVER*******************************#

# Define server logic required to display poem & search matches data table
server <- function(input, output) {
  
  #Output for random poem display 
  output$displaypoem <- renderPrint({
    input$pickpoem

    directory <- "./poems-processed"
    
    files <- list.files(directory)
    n <- length(files)
    
    randnum <- sample(1:n, 1) 
    lines <- readLines(paste(directory, "/", files[randnum], sep=""))
    for (i in 1:length(lines)) {
      cat(paste(lines[i], "\n"))
    }
  })

####################################################
  #Output for search matches data table
    output$search_matches <- DT::renderDT({
        messy <- search_files_for_pattern(file_names, input$search_pattern)
    })
}

#*****************END SERVER*******************************#

##################################################################
#################UTILITY FUNCTIONS FOR SEARCH######################

search_file_for_pattern <- function(file_name, pattern) {
    raw <- readLines(paste0(file_name))
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
file_names <- fs::dir_ls("./poems-processed")
###################################################################
##################################################################

# Run the application 
shinyApp(ui = ui, server = server)

