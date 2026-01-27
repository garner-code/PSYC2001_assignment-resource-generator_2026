# Fix Summary: Data.csv Duplication Issue

## Issue Description

Students downloading the zip file from the Shiny app were receiving two copies of `data.csv`:
1. One in the root folder
2. One in the Data/ folder

Only the copy in the Data/ folder should have been present.

## Root Cause Analysis

The issue was caused by the `include.dirs = TRUE` parameter in the `list.files()` call on line 130 of `app.R`.

### How the Bug Occurred

When `list.files(".", recursive = TRUE, include.dirs = TRUE)` is called, it returns:
- All files with their paths (e.g., "Data/data.csv")
- All directory names (e.g., "Data", "Output")

The file list passed to `zip::zipr()` looked like:
```
["PSYC2001_Assignment.Rproj", "analysis.R", "README.txt", "Data", "Data/data.csv", "Output"]
```

When `zip::zipr()` processes this list:
1. It encounters "Data" - adds the directory and all its contents (including data.csv)
2. It encounters "Data/data.csv" - adds this file explicitly
3. Result: data.csv appears twice in the final zip file

### Why include.dirs Was Used

The `include.dirs = TRUE` parameter was originally added to ensure that empty directories (like the Output/ folder) would be included in the zip file. However, this caused the unintended side effect of duplicating files within directories.

## Solution Implemented

### Change 1: Remove include.dirs Parameter (Line 130)

**Before:**
```r
zip::zipr(
  zipfile = file,
  files   = list.files(".", all.files = TRUE, recursive = TRUE, include.dirs = TRUE)
)
```

**After:**
```r
zip::zipr(
  zipfile = file,
  files   = list.files(".", all.files = TRUE, recursive = TRUE, include.dirs = FALSE)
)
```

**Rationale:**
- `zip::zipr()` automatically creates directories when it encounters file paths like "Data/data.csv"
- We don't need to pass directory names separately
- This eliminates the duplication issue

### Change 2: Add Output/README.txt (Lines 116-118)

**Code Added:**
```r
# 5) Add a README to Output folder to ensure it's included in the zip
output_readme <- file.path(output_dir, "README.txt")
writeLines("This folder is for your analysis outputs (plots, tables, etc.)", output_readme)
```

**Rationale:**
- With `include.dirs = FALSE`, empty directories won't be included in the zip
- Adding a README.txt file ensures the Output/ folder is created
- The README provides helpful context to students about the folder's purpose
- This is better than using a hidden .gitkeep file which can be confusing

## Expected Zip Structure

After this fix, the downloaded zip file will contain:
```
[student_zID].zip
├── PSYC2001_Assignment.Rproj
├── analysis.R
├── README.txt
├── Data/
│   └── data.csv
└── Output/
    └── README.txt
```

Note: `data.csv` now only appears in the Data/ folder, not in the root.

## Testing Recommendations

Since R is not available in the CI/CD environment, manual testing is required:

1. **Run the Shiny app locally**
   ```r
   shiny::runApp()
   ```

2. **Download a test zip file**
   - Enter a test student number (e.g., 1234567)
   - Click the Download button
   - Save the zip file

3. **Extract and verify structure**
   - Extract the zip file
   - Verify `data.csv` exists ONLY in the Data/ folder
   - Verify `data.csv` does NOT exist in the root folder
   - Verify the Output/ folder is present with a README.txt inside

4. **Test the analysis script**
   - Open the extracted folder in RStudio (double-click the .Rproj file)
   - Run the analysis.R script
   - Verify it successfully reads Data/data.csv without errors

## Errors Encountered During Implementation

### Error 1: R Not Available in Development Environment

**Error Message:**
```
Command 'R' not found, but can be installed with:
apt install r-base-core
```

**Impact:** 
- Could not perform automated testing of the Shiny app
- Could not verify the fix by actually running the app and downloading a zip

**Workaround:**
- Analyzed the code logically to identify the root cause
- Reviewed R documentation for `list.files()` and `zip::zipr()` behavior
- Made minimal, targeted changes based on understanding of the functions
- Created comprehensive testing documentation for manual verification

### Error 2: Git Grafted History

**Encountered:**
```
commit ed3cccbaec0ea437ca4b10973b26f69983c292f8 (grafted)
```

**Impact:**
- Could not view the full git history to see previous attempts to fix this issue
- Limited ability to understand what had been tried before

**Workaround:**
- Worked with available commit messages ("updated but still data twice")
- Focused on understanding the current code state rather than historical changes

## Code Quality Metrics

- **Files Modified:** 1 (app.R)
- **Files Added:** 1 (FIX_DATA_CSV_DUPLICATION.md)
- **Lines Changed:** 8 insertions, 2 deletions
- **Minimal Change:** ✅ Only changed what was necessary to fix the issue

## Changes Summary

| File | Lines | Change Description |
|------|-------|-------------------|
| app.R | 116-118 | Added Output/README.txt creation |
| app.R | 126-127 | Added explanatory comments |
| app.R | 130 | Changed `include.dirs = TRUE` to `include.dirs = FALSE` |

## Verification Checklist

Manual testing should verify:
- [ ] Zip file downloads successfully
- [ ] data.csv exists in Data/ folder
- [ ] data.csv does NOT exist in root folder
- [ ] Output/ folder exists in the zip
- [ ] Output/README.txt exists and contains helpful text
- [ ] PSYC2001_Assignment.Rproj exists in root
- [ ] analysis.R exists in root and runs without errors
- [ ] README.txt exists in root

## Conclusion

The fix addresses the root cause by:
1. **Preventing duplication:** Setting `include.dirs = FALSE` ensures files aren't listed twice
2. **Preserving structure:** `zip::zipr()` still creates all necessary directories from file paths
3. **Including empty folders:** Adding Output/README.txt ensures the Output/ folder is present
4. **Improving UX:** The README in Output/ provides helpful context to students

This is a minimal, surgical fix that solves the duplication issue while maintaining all desired functionality.
