#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
  # Application title
  titlePanel("Display a random Emily Dickinson poem (Gutenberg edition)"),
  
  sidebarLayout(
    sidebarPanel(
      searchInput(
        inputId = "id", 
        label = "Enter your search:", 
        placeholder = "This is a placeholder", 
        btnSearch = icon("search"), 
        btnReset = icon("remove"), 
        width = "100%"
      ),
      actionButton("pickpoem", "Pick a poem at random")),
    
    # Show a plot of the generated distribution
    mainPanel(verbatimTextOutput("displaypoem"))
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$displaypoem <- renderPrint({
    input$pickpoem
    
    require(mosaic)
    directory <- "../poems-processed"
    
    files <- list.files(directory)
    n <- length(files)
    
    randnum <- sample(1:n, 1) 
    lines <- readLines(paste(directory, "/", files[randnum], sep=""))
    for (i in 1:length(lines)) {
      cat(paste(lines[i], "\n"))
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

