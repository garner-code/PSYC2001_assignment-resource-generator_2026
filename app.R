library(shiny)
source("assets/dataGen.R")

# Define UI for data download app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("PSYC2001 Assignment Data Generator 2025"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Enter student number
      numericInput("zID", label = h3("Student number (without z)"), value = 1234567),
      
      #Input: enter number of participants
#      numericInput("N", label = h3("Number of participants"), value = 6),
      
      # Button
      downloadButton("downloadData", "Download")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      tableOutput("table")
      
    )
    
  )
)

# Define server logic to display and download selected file ----
server <- function(input, output) {
  
  # Reactive value for selected dataset ----
  dat <- reactive({
    dataGen(input$zID)
  })
  
  # Table of selected dataset ----
  output$table <- renderTable({
    dat()
  })
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$zID, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(dat(), file, row.names = FALSE)
    }
  )
  
}

# Create Shiny app ----
shinyApp(ui, server)
