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
  
  # Downloadable zip file containing csv and R script ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$zID, ".zip", sep = "")
    },
    content = function(file) {
      # Create a temporary directory to store files before zipping
      temp_dir <- tempdir()
      
      # Define file paths
      csv_file <- file.path(temp_dir, paste(input$zID, ".csv", sep = ""))
      r_script <- file.path(temp_dir, "analysis.R")
      
      # Write the CSV file
      write.csv(dat(), csv_file, row.names = FALSE)
      
      # Copy the analysis R script and update the filename reference
      analysis_content <- readLines("assets/analysis.R")
      analysis_content <- gsub("your_data.csv", paste(input$zID, ".csv", sep = ""), analysis_content)
      writeLines(analysis_content, r_script)
      
      # Create zip file with both files
      zip_result <- zip(file, files = c(csv_file, r_script), flags = "-j")
      
      # Check if zip was successful
      if (zip_result != 0) {
        stop("Failed to create zip file")
      }
    }
  )
  
}

# Create Shiny app ----
shinyApp(ui, server)
