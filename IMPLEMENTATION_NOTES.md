# Implementation Notes: README.txt and Folder Structure

## Summary of Changes

This document details the changes made to add README.txt to the download and create a proper folder structure with Data/ and Output/ directories.

## Requirements Addressed

1. ✅ Added README.txt file to the download
2. ✅ Created two empty folders: Data/ and Output/
3. ✅ Moved data.csv into the Data/ folder
4. ✅ Updated analysis.R to import CSV from the Data/ folder

## Files Modified

### 1. app.R
**Location**: `/app.R`

**Changes Made**:
- Modified the `downloadHandler` content function to create a proper directory structure
- Created a base directory (`zip_base`) with subdirectories: `Data/` and `Output/`
- Changed file path for `data.csv` to be written to `Data/data.csv`
- Added `README.txt` to the root of the zip file
- Added a `.gitkeep` placeholder file in the `Output/` folder to ensure it's included
- Changed zip creation method from using `-j` flag (which junks paths) to `-r` flag (recursive) to preserve folder structure
- Used `setwd()` to change to the zip_base directory before zipping to ensure correct relative paths

### 2. assets/analysis.R
**Location**: `/assets/analysis.R`

**Changes Made**:
- Updated line 11: Changed `here("data.csv")` to `here("Data", "data.csv")`
- This ensures the script can locate the CSV file in the new Data/ folder location

## Expected Download Structure

When a student downloads their data, the zip file will have this structure:

```
[student_zID].zip
├── README.txt                      (Instructions for students)
├── PSYC2001_Assignment.Rproj      (R project file)
├── analysis.R                      (Analysis script)
├── Data/
│   └── data.csv                   (Student's personalized dataset)
└── Output/
    └── .gitkeep                   (Placeholder to ensure folder is included)
```

## Errors Encountered and Workarounds

### Error 1: Empty Folders Not Included in Zip Files

**Problem**: 
By default, R's `zip()` function and most zip utilities do not include empty directories in the archive. This would mean the `Output/` folder would not be included in the download if left empty.

**Solution**: 
Added a `.gitkeep` placeholder file in the `Output/` folder. This is a common convention used in version control systems to track empty directories. The file has no functional purpose other than ensuring the directory exists in the zip file.

**Code**:
```r
output_placeholder <- file.path(output_dir, ".gitkeep")
file.create(output_placeholder)
```

### Error 2: Preserving Directory Structure in Zip Files

**Problem**: 
The original code used `zip(file, files = c(...), flags = "-j")`. The `-j` flag "junks" (removes) the directory paths, creating a flat zip file with all files in the root.

**Solution**: 
1. Changed to use the `-r` flag for recursive zipping
2. Changed the working directory to `zip_base` before creating the zip
3. Used relative paths by calling `list.files(".", recursive = TRUE)`
4. Restored the original working directory after zipping

**Code**:
```r
current_wd <- getwd()
setwd(zip_base)
zip_result <- zip(file, files = list.files(".", recursive = TRUE), flags = "-r")
setwd(current_wd)
```

This approach ensures that:
- The directory structure is preserved in the zip file
- All subdirectories and their contents are included
- The paths in the zip are relative to the zip root (not absolute paths)

### Consideration: here() Package Behavior

**Note**: 
The `here()` package locates the project root by searching for specific markers like:
- `.Rproj` files
- `.here` files
- `.git` directories
- Other project-related markers

Since students will download the `PSYC2001_Assignment.Rproj` file in the root of their extracted folder, the `here()` function should correctly identify this as the project root and properly resolve `here("Data", "data.csv")` to the correct path.

**No errors expected** with this approach, as it follows best practices for R project structure.

## Testing Recommendations

Since R is not available in the development environment, manual testing should be performed after deployment:

1. **Deploy to shinyapps.io** (already configured in rsconnect/)
2. **Test the download**:
   - Enter a test student number (e.g., 1234567)
   - Click the Download button
   - Save the zip file
3. **Verify the structure**:
   - Extract the zip file
   - Confirm all files and folders are present:
     - README.txt in root
     - PSYC2001_Assignment.Rproj in root
     - analysis.R in root
     - Data/ folder with data.csv inside
     - Output/ folder (empty except for .gitkeep)
4. **Test the analysis script**:
   - Open the extracted folder in RStudio (double-click the .Rproj file)
   - Ensure required packages are installed: `install.packages(c("here", "tidyverse"))`
   - Run the analysis.R script
   - Verify it successfully reads the CSV from Data/data.csv
   - Confirm the script runs without errors

## Potential Edge Cases

1. **Student removes .gitkeep file**: No issue - the Output/ folder will still exist after extraction
2. **Student doesn't use RStudio**: If they open analysis.R in base R, `here()` might not work as expected. Recommend students always open the .Rproj file first.
3. **Different operating systems**: The `file.path()` function handles path separators correctly across Windows, Mac, and Linux.

## Code Quality Notes

- All changes maintain the existing code style
- Comments were added to explain new functionality
- The code follows R best practices for file operations
- Error handling is preserved (checking zip_result)
- The temporary directory approach is maintained for security and cleanliness
