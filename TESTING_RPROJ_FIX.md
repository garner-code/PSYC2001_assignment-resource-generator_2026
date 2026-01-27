# Testing the .Rproj File Fix

## Summary of Changes

This document describes the fix applied to ensure the `.Rproj` file is included in the downloadable zip file.

## Changes Made to app.R

### 1. Added Error Checking for file.copy Operations (Lines 77-89)

**Before:**
```r
file.copy("assets/analysis.R", r_script)
file.copy("assets/PSYC2001_Assignment.Rproj", r_project)
file.copy("assets/README.txt", readme_file)
```

**After:**
```r
if (!file.copy("assets/analysis.R", r_script)) {
  stop("Failed to copy analysis.R")
}

if (!file.copy("assets/PSYC2001_Assignment.Rproj", r_project)) {
  stop("Failed to copy PSYC2001_Assignment.Rproj")
}

if (!file.copy("assets/README.txt", readme_file)) {
  stop("Failed to copy README.txt")
}
```

**Rationale:** 
- `file.copy()` returns `TRUE` on success and `FALSE` on failure
- Previously, failures were silent and would go undetected
- Now, if any file fails to copy, the download handler will throw an explicit error
- This makes debugging easier and ensures users are notified if something goes wrong

### 2. Added all.files = TRUE Parameter to list.files() (Line 94)

**Before:**
```r
zip_result <- zip(file, files = list.files(".", recursive = TRUE, include.dirs = TRUE), flags = "-r")
```

**After:**
```r
zip_result <- zip(file, files = list.files(".", recursive = TRUE, include.dirs = TRUE, all.files = TRUE), flags = "-r")
```

**Rationale:**
- By default, `list.files()` with `all.files = FALSE` excludes files starting with a dot (`.`)
- While `PSYC2001_Assignment.Rproj` doesn't start with a dot, adding `all.files = TRUE` provides extra safety
- This ensures ALL files in the directory are captured, regardless of naming conventions
- This is a defensive programming practice to prevent similar issues with any file type

## Why This Fix Should Work

### Problem Diagnosis

The reported issue was that the `.Rproj` file was being created but not appearing in the downloaded zip file. This could happen for two reasons:

1. **Silent file.copy Failure**: If the source file didn't exist or couldn't be accessed, `file.copy()` would fail silently, and the file wouldn't be copied to the temp directory before zipping.

2. **list.files() Filtering**: If `list.files()` was filtering out certain files unexpectedly, they wouldn't be included in the zip even if they were copied successfully.

### How the Fix Addresses These Issues

1. **Error Checking**: Now, if `file.copy()` fails for any reason (missing source file, permission issues, disk full, etc.), the code will immediately throw an error with a clear message. This makes the problem visible rather than silent.

2. **Comprehensive File Listing**: Adding `all.files = TRUE` ensures that no files are inadvertently filtered out by `list.files()`. This is a safety measure that ensures complete file inclusion.

## Testing Instructions

Since R is not installed in the CI/CD environment, manual testing is required:

### Prerequisites
- R installed (version 3.5 or higher recommended)
- Shiny package installed: `install.packages("shiny")`

### Testing Steps

1. **Start the Shiny App**
   ```r
   # In R console, navigate to the repository directory
   setwd("/path/to/PSYC2001_assignment-resource-generator_2026")
   
   # Run the app
   shiny::runApp("app.R")
   ```

2. **Download Test**
   - Enter a test student number (e.g., `1234567`)
   - Click the "Download" button
   - Save the zip file (e.g., `1234567.zip`)

3. **Verify Zip Contents**
   - Extract the downloaded zip file
   - Confirm the following structure exists:
   
   ```
   1234567/
   ├── PSYC2001_Assignment.Rproj   ← This should be present!
   ├── README.txt
   ├── analysis.R
   ├── Data/
   │   └── data.csv
   └── Output/                      (empty directory)
   ```

4. **Verify .Rproj File Content**
   - Open the extracted `PSYC2001_Assignment.Rproj` file in a text editor
   - Verify it contains proper R project configuration:
   
   ```
   Version: 1.0

   RestoreWorkspace: Default
   SaveWorkspace: Default
   AlwaysSaveHistory: Default

   EnableCodeIndexing: Yes
   UseSpacesForTab: Yes
   NumSpacesForTab: 2
   Encoding: UTF-8

   RnwWeave: Sweave
   LaTeX: pdfLaTeX
   ```

5. **Functional Test**
   - Double-click the `PSYC2001_Assignment.Rproj` file to open it in RStudio
   - Verify that RStudio opens the project correctly
   - Open `analysis.R` within the project
   - Verify that the script can locate and load `Data/data.csv` using the `here()` package
   - Run the script to ensure it works end-to-end

### Expected Results

✅ **Success Indicators:**
- The `.Rproj` file is present in the extracted zip
- The file content is correct
- RStudio can open the project file
- The analysis script runs without errors

❌ **Failure Indicators:**
- The `.Rproj` file is missing from the zip
- The app throws an error "Failed to copy PSYC2001_Assignment.Rproj" (indicates source file issue)
- The zip file fails to create (zip_result != 0)

### Debugging Failed Tests

If the `.Rproj` file is still missing after this fix:

1. **Check Source File**
   ```r
   file.exists("assets/PSYC2001_Assignment.Rproj")  # Should return TRUE
   ```

2. **Check Permissions**
   ```r
   file.access("assets/PSYC2001_Assignment.Rproj", 4)  # Should return 0 (readable)
   ```

3. **Manual Zip Test**
   ```r
   # Create test structure
   temp_dir <- tempdir()
   test_base <- file.path(temp_dir, "test_zip")
   dir.create(test_base, recursive = TRUE)
   
   # Copy files
   file.copy("assets/PSYC2001_Assignment.Rproj", 
             file.path(test_base, "PSYC2001_Assignment.Rproj"))
   
   # List files
   setwd(test_base)
   files_found <- list.files(".", recursive = TRUE, include.dirs = TRUE, all.files = TRUE)
   print(files_found)  # Should include PSYC2001_Assignment.Rproj
   
   # Create zip
   zip_path <- file.path(temp_dir, "test.zip")
   zip(zip_path, files = files_found, flags = "-r")
   
   # Verify zip contents
   unzip(zip_path, list = TRUE)
   ```

## Edge Cases Considered

1. **Case Sensitivity**: File systems on different OS handle case differently. The fix works consistently because it explicitly lists all files rather than using patterns.

2. **Hidden Files**: The `all.files = TRUE` parameter ensures even hidden files starting with `.` are included (though `.Rproj` files aren't typically hidden).

3. **File Permissions**: Error checking will catch permission issues and surface them explicitly.

4. **Temporary Directory Issues**: Error checking will catch if the temp directory can't be written to.

## Conclusion

This fix applies defensive programming practices:
- **Explicit error handling** makes problems visible
- **Comprehensive file inclusion** prevents filtering issues
- **Minimal code changes** reduce risk of introducing new bugs

The fix should resolve the reported issue of the `.Rproj` file not being included in the download.
