# Note on assets/PSYC2001_Assignment.Rproj

## Status: No Longer Used in Production

As of 2026-01-27, the static `.Rproj` file located at `assets/PSYC2001_Assignment.Rproj` is **no longer used** by the Shiny app.

### What Changed

The app now **dynamically generates** the `.Rproj` file using the `write_rproj()` helper function instead of copying a static file.

### Why Keep the Static File?

The static file is retained in the repository for the following reasons:

1. **Reference**: It serves as a reference for what the `.Rproj` file should look like
2. **Documentation**: It shows the original settings that were used
3. **Testing**: It can be used for comparison during manual testing
4. **Backwards Compatibility**: If needed, we can easily revert to the static file approach

### Differences Between Static and Dynamic Files

| Setting | Static File (assets/) | Dynamic Generation (write_rproj) |
|---------|----------------------|----------------------------------|
| RestoreWorkspace | Default | No |
| SaveWorkspace | Default | No |
| AlwaysSaveHistory | Default | No |
| RnwWeave | Sweave | knitr |

The dynamic generation uses **modern R best practices** with no workspace saving/restoring for better reproducibility.

### If You Need to Delete the Static File

The static file at `assets/PSYC2001_Assignment.Rproj` can be safely deleted without affecting the Shiny app's functionality, as it is no longer referenced in the code. However, keeping it as a reference is harmless and may be useful for documentation purposes.

### Verification

You can verify the static file is not used by searching the codebase:

```bash
grep -r "assets/PSYC2001_Assignment.Rproj" app.R
# Returns nothing - file is not referenced
```

The only reference to creating the `.Rproj` file in production code is:

```r
write_rproj(build_dir, project_name = "PSYC2001_Assignment")
```

This dynamically generates the file on-the-fly during download.
