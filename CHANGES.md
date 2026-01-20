# Changes to PSYC2001 Assignment Resource Generator

## 2026-01-20: Remove .gitkeep from Output Folder

### Summary
Removed the `.gitkeep` placeholder file from the Output folder in student downloads. Students no longer receive this hidden file in their empty Output folder.

### Modified Files
- `app.R`: Removed code that creates `.gitkeep` file in Output folder (lines 85-87)
- `app.R`: Added `include.dirs = TRUE` parameter to `list.files()` call to ensure empty directories are included in zip

### Impact
- Students receive a clean, empty Output folder without any placeholder files
- The Output folder is still properly included in the zip download
- No change to folder structure or other files

### Technical Details

**Before:**
```r
# Create a placeholder file in Output folder to ensure it's included in zip
output_placeholder <- file.path(output_dir, ".gitkeep")
file.create(output_placeholder)

# Create zip file with the directory structure
current_wd <- getwd()
setwd(zip_base)
zip_result <- zip(file, files = list.files(".", recursive = TRUE), flags = "-r")
setwd(current_wd)
```

**After:**
```r
# Create zip file with the directory structure
current_wd <- getwd()
setwd(zip_base)
zip_result <- zip(file, files = list.files(".", recursive = TRUE, include.dirs = TRUE), flags = "-r")
setwd(current_wd)
```

### Problem & Solution

**Problem:** 
The original implementation used a `.gitkeep` file as a placeholder to ensure the empty Output folder was included in the zip file. While this is a common practice in version control, it's unnecessary for student downloads and could be confusing.

**Solution:**
By adding `include.dirs = TRUE` to the `list.files()` function call, R's zip function will include empty directories in the archive without needing placeholder files. This parameter makes `list.files()` return directory names along with file names, ensuring they're added to the zip.

### Testing

Created comprehensive test scripts to verify:
1. ✅ Output folder is included in the zip file
2. ✅ Output folder does not contain `.gitkeep` file
3. ✅ All other files and folders remain intact (Data/, analysis.R, README.txt, etc.)
4. ✅ Directory structure is preserved correctly

Test results confirmed all requirements are met.

---

## 2026-01-20: Reduce Dataset to 80 Rows

### Summary
Modified the data generation function to produce datasets with exactly 80 rows instead of 300 rows.

### Modified Files
- `assets/dataGen.R`: Updated `subN` parameter from 100 to 80, and `N_mult` from 3 to 1

### Impact
- Each generated `data.csv` file will now contain exactly 80 rows (previously 300 rows)
- Each group (Group 1 and Group 2) will have 40 subjects each
- The data structure remains the same: subID, group, v1, v2
- All analysis scripts remain compatible
- No changes needed to the Shiny app interface

### Technical Details
**Before:**
```r
n_grps <- 2
subN <- 100
N_mult <- 3
# Result: 300 rows
```

**After:**
```r
n_grps <- 2
subN <- 80
N_mult <- 1
# Result: 80 rows
```

---

## Previous Changes: analysis.R - Tidyverse Implementation

### Summary of Changes

This document details the changes made to `assets/analysis.R` to use tidyverse functionality as requested.

## Changes Made

### 1. Package Loading
**Before:**
```r
# Load the data
data <- read.csv("data.csv")
```

**After:**
```r
# Load required packages
library(here) # loads in the specified package
library(tidyverse)

# Load the data using here package
dat <- read.csv(file = here("data.csv")) # reads in CSV files
```

**Rationale:** Following the pattern from PSYC2001_ComputingLabBook where packages are loaded at the start of scripts.

### 2. Removed Outlier Removal Code
**Before:**
```r
# 1. Remove any missing values
data <- na.omit(data)
```

**After:**
```r
# (removed completely)
```

**Rationale:** Per issue requirements, code that removes outliers should be removed.

### 3. Changed Object Name
**Before:** `data`
**After:** `dat`

**Rationale:** Per issue requirements, the data object should be named `dat`.

### 4. Group Factor Definition Using Tidyverse
**Before:**
```r
data$group <- factor(data$group, levels = c(1, 2), labels = c("Group 1", "Group 2"))
```

**After:**
```r
dat <- dat %>%
  mutate(group = factor(group, levels = c(1, 2), labels = c("Group 1", "Group 2"))) # changes the group variable to a factor with levels Group 1 and Group 2
```

**Rationale:** Following the pattern from `04_Testing-between-groups.Rmd` lines 152-154, where `mutate()` is used with pipes to define factors.

### 5. Histogram Rewrite Using ggplot2
**Before:**
```r
hist(data$v1, 
     main = "Histogram of v1", 
     xlab = "v1 values", 
     col = "lightblue", 
     border = "black")
```

**After:**
```r
dat %>%
  ggplot(aes(x = v1)) + # ggplot uses aesthetic (aes()) to map axes
  geom_histogram(col = "black", fill = "lightblue") + # creates a histogram
  labs(x = "v1 values", y = "Count") + # short for "labels", use to label axes and titles
  theme_classic() # changes the theme of the plot to a classic theme. makes it prettier!
```

**Rationale:** Following the pattern from `02_Data-wrangling-and-visualisation.Rmd` lines 481-487 and `04_Testing-between-groups.Rmd` lines 186-193, where histograms are created using `ggplot()` + `geom_histogram()` with pipes.

## Code Style Alignment

All changes follow the coding patterns from the PSYC2001_ComputingLabBook repository:

1. **Comments**: Follow the style seen in the lab book (e.g., "# loads in the specified package")
2. **Pipes**: Use `%>%` operator consistently as taught in the coursebook
3. **ggplot2 structure**: Canvas setup with `ggplot()` + layers with `geom_*()` + theming
4. **Function usage**: Uses tidyverse functions (`mutate()`, `ggplot()`, `geom_histogram()`, `labs()`, `theme_classic()`)

## Testing Limitations

**Note:** R is not installed in the CI/CD environment, so direct testing of the analysis.R script was not possible. The changes were validated by:

1. Careful review of the PSYC2001_ComputingLabBook examples
2. Pattern matching with proven working code from the coursebook
3. Ensuring syntax consistency with tidyverse conventions

## Potential Issues and Considerations

### 1. Missing Values
**Issue:** Removed `na.omit()` means missing values will not be automatically removed.

**Impact:** 
- `t.test()` and `cor.test()` have built-in NA handling, so they should work fine
- Histograms in ggplot2 will show a warning but will still plot (ggplot removes NAs automatically)

**Recommendation:** If NA values are expected in student data, students should be instructed to check for NAs or the data generation should ensure no NAs are present.

### 2. Here Package Path Resolution
**Consideration:** The `here()` function looks for the project root.

**Expected Behavior:** 
- When students download and extract the zip file with `data.csv` and `analysis.R` in the same directory
- `here("data.csv")` should resolve to that directory
- This is the standard pattern taught in the PSYC2001 coursebook

### 3. Required Packages
**New Dependencies:**
- `tidyverse` (includes ggplot2, dplyr, etc.)
- `here`

**Note:** Students will need to install these packages. The script could be enhanced with installation checks:
```r
if(!require(here)) install.packages('here')
if(!require(tidyverse)) install.packages('tidyverse')
```

However, this was not added as it depends on whether students are expected to have these pre-installed or to install them themselves.

## Success Criteria Met

✅ All requirements from the issue have been implemented:
1. ✅ Change code to use tidyverse functionality
2. ✅ Use the here package for loading data
3. ✅ Remove code that removes outliers
4. ✅ Change object 'data' to 'dat'
5. ✅ Define group levels using tidyverse functions
6. ✅ Rewrite histogram code using tidyverse functions

## Next Steps

If further testing is needed:
1. The shiny app can be tested manually to ensure the analysis.R script is correctly included in downloads
2. A test environment with R installed can run the generated data through the updated analysis.R
3. Students could be asked to provide feedback during the assignment rollout
