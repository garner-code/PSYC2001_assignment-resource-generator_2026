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
  
  # Downloadable zip file containing csv, R script, R project file, README, and folders ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$zID, ".zip", sep = "")
    },
    content = function(file) {
      # Create a temporary directory to store files before zipping
      temp_dir <- tempdir()
      zip_base <- file.path(temp_dir, paste0("zip_", input$zID))
      
      # Create the directory structure
      dir.create(zip_base, showWarnings = FALSE, recursive = TRUE)
      data_dir <- file.path(zip_base, "Data")
      output_dir <- file.path(zip_base, "Output")
      dir.create(data_dir, showWarnings = FALSE)
      dir.create(output_dir, showWarnings = FALSE)
      
      # Define file paths
      csv_file <- file.path(data_dir, "data.csv")
      r_script <- file.path(zip_base, "analysis.R")
      r_project <- file.path(zip_base, "PSYC2001_Assignment.Rproj")
      readme_file <- file.path(zip_base, "README.txt")
      
      # Write the CSV file to Data folder
      write.csv(dat(), csv_file, row.names = FALSE)
      
      # Copy the analysis R script to base directory
      if (!file.copy("assets/analysis.R", r_script)) {
        stop("Failed to copy analysis.R")
      }
      
      # Copy the R project file to base directory
      if (!file.copy("assets/PSYC2001_Assignment.Rproj", r_project)) {
        stop("Failed to copy PSYC2001_Assignment.Rproj")
      }
      
      # Copy the README file to base directory
      if (!file.copy("assets/README.txt", readme_file)) {
        stop("Failed to copy README.txt")
      }
      
      # Create zip file with the directory structure
      current_wd <- getwd()
      setwd(zip_base)
      zip_result <- zip(file, files = list.files(".", recursive = TRUE, include.dirs = TRUE, all.files = TRUE), flags = "-r")
      setwd(current_wd)
      
      # Check if zip was successful
      if (zip_result != 0) {
        stop("Failed to create zip file")
      }
    }
  )
  
}

# Create Shiny app ----
shinyApp(ui, server)
