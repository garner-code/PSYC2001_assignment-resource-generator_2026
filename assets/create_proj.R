# Helper: write an .Rproj file with sensible defaults
create_proj <- function(path, project_name = NULL, overwrite = FALSE) {
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