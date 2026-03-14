# PSYC2001 2026 Assignment Resources Generator

K. Garner - 2026

A Shiny web application that allows PSYC2001 students to download a personalised dataset and analysis script for their assignment.

---

## Overview

Each student enters their student number (zID) into the app and clicks **Download**. The app generates a bespoke dataset seeded from the student's zID (so every student gets a unique but reproducible dataset) and bundles it together with an R analysis script, an R project file, and a README into a single `.zip` file ready to unzip and open in RStudio.

---

## Running the App Locally

### Prerequisites

Install R and the following packages:

```r
install.packages(c("shiny", "zip", "scales", "here", "tidyverse"))
```

### Start the app

From an R console, open the project root as your working directory and run:

```r
shiny::runApp("app.R")
```

Or open `app.R` in RStudio and click the **Run App** button.

---

## Deployed App

The app is deployed on ShinyApps.io and accessible at:

```
https://unsw-psych.shinyapps.io/PSYC2001_assignment-resource-generator_2026/
```

Deployment configuration is stored in `rsconnect/shinyapps.io/unsw-psych/`.

---

## How It Works

1. The student enters their **student number (without the leading z)** in the sidebar.
2. A preview of their dataset is shown in the main panel.
3. Clicking **Download** generates and downloads a `.zip` file named `<studentNumber>.zip`.

### Generated Dataset

The dataset is created by `assets/dataGen.R`. It uses the student's zID as a random seed, so each student receives a unique but fully reproducible 100-row dataset containing:

| Column | Description |
|--------|-------------|
| `subID` | Subject ID (1–100) |
| `group` | Group membership: 1 or 2 (50 subjects per group) |
| `v1` | Continuous variable 1 (scaled 0–1) |
| `v2` | Continuous variable 2 (scaled 0–1, negatively correlated with v1) |

---

## Contents of the Downloaded Zip File

When a student clicks **Download**, they receive a `.zip` file with the following structure:

```
<studentNumber>.zip
├── PSYC2001_Assignment.Rproj   ← RStudio project file (double-click to open)
├── analysis.R                  ← Analysis script (see below)
├── README.txt                  ← Instructions for students
├── Data/
│   └── data.csv                ← The student's personalised dataset
└── Output/                     ← Empty folder for saving plots and results
    └── README.txt
```

### Opening the Project

Students should:

1. Unzip the downloaded file.
2. Double-click `PSYC2001_Assignment.Rproj` to open the project in RStudio.
3. Read `README.txt` for assignment instructions.

---

## The `analysis.R` Script

`assets/analysis.R` is copied into every student's download. It demonstrates a complete analysis workflow using **tidyverse** and **here** packages:

- **Load data** – reads `Data/data.csv` using `here::here()`
- **Wrangle** – converts `group` to a labelled factor with `dplyr::mutate()`
- **Visualise** – histograms of `v1` and `v2`, a paired boxplot, a group-comparison boxplot, a one-sample boxplot, and a scatterplot (all via `ggplot2`)
- **Analyse** – paired t-test, independent-samples t-test, one-sample t-test, and Pearson correlation
- **Save output** – writes text results and PNG plots to the `Output/` folder

Students are asked to create a new script `my_analysis.R` that contains only the code relevant to their chosen analysis, with added comments explaining each step.

---

## Repository Structure

```
.
├── app.R                      # Shiny application (UI + server)
├── assets/
│   ├── analysis.R             # Student analysis script template
│   ├── dataGen.R              # Data generation function
│   ├── README.txt             # Instructions included in student download
│   └── PSYC2001_Assignment.Rproj  # retained for reference; download uses dynamically-generated copy
├── index.htm                  # ShinyApps.io landing page
├── manifest.json              # ShinyApps.io deployment manifest
├── rsconnect/                 # ShinyApps.io deployment config
├── CHANGES.md                 # Changelog
└── README.md                  # This file
```

---

## Dependencies

| Package | Purpose |
|---------|---------|
| `shiny` | Web application framework |
| `zip` | Cross-platform zip file creation |
| `scales` | Rescaling data in `dataGen.R` |
| `here` | Portable file paths in `analysis.R` |
| `tidyverse` | Data wrangling and visualisation in `analysis.R` |

---

## Notes for Maintainers

- The `.Rproj` file included in student downloads is **generated dynamically** by the `write_rproj()` helper in `app.R`, not copied from `assets/`. This ensures modern R best-practice settings (no workspace saving/restoring).
- Changing the dataset size requires editing `subN` and `N_mult` in `assets/dataGen.R`.
- All changes should be logged in `CHANGES.md`.
