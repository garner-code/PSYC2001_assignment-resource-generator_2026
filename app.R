library(shiny)
library(zip)   # for cross-platform zipping
source("assets/dataGen.R")

# Helper: write an .Rproj file with sensible defaults
write_rproj <- function(path, project_name = NULL, overwrite = FALSE) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  if (is.null(project_name)) project_name <- basename(normalizePath(path, mustWork = FALSE))
  rproj_path <- file.path(path, paste0(project_name, ".Rproj"))
  
  if (file.exists(rproj_path) && !overwrite) {
    stop("Rproj already exists at: ", rproj_path)
  }
  
  rproj_contents <- c(
    "Version: 1.0",
    "",
    "RestoreWorkspace: No",
    "SaveWorkspace: No",
    "AlwaysSaveHistory: No",
    "",
    "EnableCodeIndexing: Yes",
    "UseSpacesForTab: Yes",
    "NumSpacesForTab: 2",
    "Encoding: UTF-8",
    "",
    "RnwWeave: knitr",
    "LaTeX: pdfLaTeX"
  )
  writeLines(rproj_contents, rproj_path, useBytes = TRUE)
  rproj_path
}

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

      # Create a temp build directory
      build_dir <- tempfile("bundle_")
      dir.create(build_dir)

      # Create the directory structure
      data_dir <- file.path(build_dir, "Data")
      output_dir <- file.path(build_dir, "Output")
      dir.create(data_dir, showWarnings = FALSE)
      dir.create(output_dir, showWarnings = FALSE)
      
      # 1) Write the .Rproj file using the helper function
      write_rproj(build_dir, project_name = "PSYC2001_Assignment")

      # 2) Write the CSV file to Data folder
      csv_file <- file.path(data_dir, "data.csv")
      write.csv(dat(), csv_file, row.names = FALSE)
      
      # 3) Copy the analysis R script to base directory
      r_script <- file.path(build_dir, "analysis.R")
      if (!file.copy("assets/analysis.R", r_script)) {
        stop("Failed to copy analysis.R")
      }
      
      # 4) Copy the README file to base directory
      readme_file <- file.path(build_dir, "README.txt")
      if (!file.copy("assets/README.txt", readme_file)) {
        stop("Failed to copy README.txt")
      }
      
      # 5) Add a README to Output folder to ensure it's included in the zip
      output_readme <- file.path(output_dir, "README.txt")
      writeLines("This folder is for your analysis outputs (plots, tables, etc.)", output_readme)
      
      # 6) Zip the directory contents into `file`
      # Use zip::zipr for portability (works on Windows/macOS/Linux)
      old_wd <- setwd(build_dir)
      on.exit(setwd(old_wd), add = TRUE)
      
      # Zip everything inside build_dir (relative paths)
      # Note: include.dirs = FALSE to avoid listing files twice
      # (zip::zipr handles directories automatically when given file paths)
      zip::zipr(
        zipfile = file,
        files   = list.files(".", all.files = TRUE, recursive = TRUE, include.dirs = FALSE)
      )
    }
  )
  
}

# Create Shiny app ----
shinyApp(ui, server)
