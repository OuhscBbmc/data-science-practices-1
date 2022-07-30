Prototypical Repository {#repo-prototype}
====================================

https://github.com/wibeasley/RAnalysisSkeleton

Root {#repo-root}
------------------------------------

### `config.R` {#repo-config}

The configuration file is simply a plain-text yaml file read by the [config](https://CRAN.R-project.org/package=config) package.  It is great when a value has to be coordinated across multiple files.

Also see the discussion of how we use the config file for [excluding bad data values](https://ouhscbbmc.github.io/data-science-practices-1/coding.html#excluding-bad-cases) and of how the config file [relates to yaml](#data-containers-yaml), json, and xml.

```yaml
default:
  # To be processed by Ellis lanes
  path_subject_1_raw:  "data-public/raw/subject-1.csv"
  path_mlm_1_raw:      "data-public/raw/mlm-1.csv"

  # Central Database (produced by Ellis lanes).
  path_database:       "data-public/derived/db.sqlite3"

  # Analysis-ready datasets (produced by scribes & consumed by analyses).
  path_mlm_1_derived:  "data-public/derived/mlm-1.rds"

  # Metadata
  path_annotation:     "data-public/metadata/cqi-annotation.csv"

  # Logging errors and messages from automated execution.
  path_log_flow:       !expr strftime(Sys.time(), "data-unshared/log/flow-%Y-%m-%d--%H-%M-%S.log")

  # time_zone_local       :  "America/Chicago" # Force local time, in case remotely run.

  # ---- Validation Ranges & Patterns ----
  range_record_id         : !expr c(1L, 999999L)
  range_dob               : !expr c(as.Date("2010-01-01"), Sys.Date() + lubridate::days(1))
  range_datetime_entry    : !expr c(as.POSIXct("2019-01-01", tz="America/Chicago"), Sys.time())
  max_age                 : 25
  pattern_mrn             : "^E\\d{9}$"  # An 'E', followed by 9 digits.
```

### `flow.R` {#repo-flow}

The workflow of the repo is determined by `flow.R`.  It calls (typically R and SQL) files in a specific order, while sending the log messages to a file.

See [automation mediators](#automation-flow) for more details.

### `README.md` {#repo-readme}

### `*.Rproj` {#repo-rproj}

The Rproj file stores project-wide settings used by the RStudio IDE, such how trailing whitespaces are handled.  The file's major benefit is that it sets the R session's working directory, which facilitates good discipline about setting a constant location for all files in the repo.  Although the plain-text file can be edited directly, we recommend using RStudio's dialog box.  There is good documentation about Rproj settings.  If you are unsure, copy [this file](https://github.com/wibeasley/RAnalysisSkeleton/blob/master/RAnalysisSkeleton.Rproj) to the repo's root directory and rename it to match the repo exactly.

Analysis {#repo-analysis}
------------------------------------

Data Public {#repo-data-public}
------------------------------------

`data-public/` Directory
=========

This directory should contain information that is not sensitive and is not proprietary.  It SHOULD NOT hold [PHI](https://www.hhs.gov/answers/hipaa/what-is-phi/index.html) (Protected Health Information), or other information like participant names, social security numbers, or passwords.  Files with PHI should **not** be stored in a GitHub repository, even a [private GitHub repository](https://help.github.com/articles/publicizing-or-hiding-your-private-contributions-on-your-profile/).

Please see [`data-unshared/`](#repo-data-unshared) for options storing sensitive information.

The `data-public/` directory typically works best if organized with subdirectories.  We commonly use

* **`data-public/raw/`** for the input to the pipelines.  These datasets usually represents all the hard work of the data collection.

* **`data-public/metadata/`** for the definitions of the datasets in raw.  For example, "gender.csv" might translate the values 1 and 2 to male and female.  Sometimes a dataset feels natural in either the raw or the metadata subdirectory.  If the file would remain unchanged if a subsequent sample was collected, lean towards metadata.

* **`data-public/derived/`** for output of the pipelines.  Its contents should be completely reproducible when starting with `data-public/raw/` and the repo's code.  In other words, it can be deleted and recreated at ease.  This might contain a small database file, like SQLite.

* **`data-public/logs/`** for logs that are useful to collaborators or necessary to demonstrate something in the future, beyond the reports contained in the `analysis/` directory.

* **`data-public/original/`** for nothing (hopefully); ideally it is never used.  It is similar to `data-public/raw/`.  The difference is that `data-public/raw/` is called by the pipeline code, while `data-public/original/`  is not.

  A file in `data-public/original/`typically comes from the investigator in a malformed state and requires some manual intervention; then it is copied to `data-public/raw/`.  Common offenders are (a) a csv or Excel file with bad or missing column headers, (b) a strange file format that is not readable by an R package, (c) a corrupted file that require a rehabilitation utility.

The characteristics of `data-public/` vary based on the subject matter.  For instance, medical research projects typically use only the metadata directory, because the incoming information contains PHI and is stored in a database.  On the other hand, microbiology and physics research typically do not have data protected by law, and it is desirable for the repo to contain everything.

We feel a private GitHub repo offers adequate protection if being scooped is the biggest risk.


Data Unshared {#repo-data-unshared}
------------------------------------

`data-unshared/` Directory
=========

Files in this directory are stored on the local computer, but are not committed and are not sent to the central GitHub repository/server.  This makes the folder a decent container for:

1. **sensitive information**, such as [PHI](https://www.hhs.gov/answers/hipaa/what-is-phi/index.html) (Protected Health Information).  When PHI is involved, we recommend `data-unshared/` only if a database or a secured networked file share is not feasible.  See the discussion below.

1. **public files that are huge** (say, 1+ GB) and easily downloadable or reproducible.  For instance, files from stable sources like the US Census, NLSY, or Dataverse.

1. **diagnostic logs** that are not useful to collaborators.

A line in the repo's `.gitignore` file blocks the directory's contents from being staged/committed (look for `/data-unshared/*`).  Since files in this directory are not committed, it requires more discipline to communicate what files should be on a collaborator's computer.  Keep a list of files (like a table of contents) updated at `data-unshared/contents.md`; at a minimum declare the name of each file and how it can be downloaded or reproduced.  If you are curious the line `!data-unshared/contents.md` in `.gitignore` declares an exception so the markdown file is committed and updated on a collaborator's machine.

Even though these files are kept off the central repository, we recommend encrypting your local drive if the `data-unshared/` contains sensitive (such as PHI).  See the `data-public/` [`README.md`](data-public/) for more information.

The directory works best with the subdirectories described in the organization of [`data-public/`](#repo-data-public).

Compared to `data-unshared/`, we prefer storing PHI in an enterprise database (such as SQL Server, PostgreSQL, MariaDB/MySQL, or Oracle) or networked drive for four reasons.

1. These central resources are typically managed by Campus IT and reviewed by security professionals.
1. It's trivial to stay synchronized across collaborators with a file share or database. In contrast, `data-unshared/` isn't synchronized across machines so extra discipline is required to tell collaborators to update their machines.
1. It's sometimes possible to recover lost data from a file share or database.  It's much less likely to turn back the clock for `data-unshared/` files.
1. It's not too unlikely to mess up the `.gitignore` entries which would allow the sensitive files to be committed to the repository.  If sensitive information is stored on `data-unshared/`, it is important to review every commit to ensure information isn't about to sneak into the repo.

Documentation {#repo-documentation}
------------------------------------

Manipulation {#repo-manipulation}
------------------------------------

Stitched Output {#repo-stitched}
------------------------------------

Utility {#repo-utility}
------------------------------------
