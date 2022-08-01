Prototypical Repository {#prototype-repo}
====================================

The following file repository structure has supported a wide spectrum of our projects, ranging from (a) a small, short-term retrospective project with one dataset, one manipulation file, and one analysis report to (b) a large, multi-year project fed by dozens of input files to support multiple statisticians and a sophisticated enrollment process.

Looking beyond any single project, we strongly encourage your team to adopt a common file organization.  Pursuing commonality provides multiple benefits:

* An evolved and thought-out structure makes it easier to follow good practices and avoid common traps.

* Code files are more portable between projects.  More code can be reused if both environments refer to same files and directories like [config.yml](https://github.com/wibeasley/RAnalysisSkeleton/blob/main/config.yml), [data-public/raw](https://github.com/wibeasley/RAnalysisSkeleton/tree/main/data-public/raw), and [data-public/derived](https://github.com/wibeasley/RAnalysisSkeleton/tree/main/data-public/derived)

* People are more portable between projects.  When a person is already familiar with the structure, they start contributing more quickly because they already know to look for statistical reports in [analysis/](https://github.com/wibeasley/RAnalysisSkeleton/tree/main/analysis) and to debug problematic file ingestions in [manipulation/](https://github.com/wibeasley/RAnalysisSkeleton/tree/main/manipulation) files.

If a specific project doesn't use a directory or file, we recommend retaining the stub.  Like the empty chunks discusses in the [Prototypical R File](#prototype-r) chapter, a stub communicates to your collaborator, "this project currently doesn't use the feature, but when/if it does, this will be the location".  The collaborator can stop their search immediately, and avoid searching weird places in order to rule-out the feature is located elsewhere.

The template that has worked well for us is publicly available at <https://github.com/wibeasley/RAnalysisSkeleton>.  The important files and directories are described below.  Please use this as a starting point, and not as a dogmatic prison.  Make adjustments when it fits your specific project or your overall team.

Root {#repo-root}
------------------------------------

The following files live in the repository's root directory, meaning they are not in any subfolder/subdirectory.

### `config.R` {#repo-config}

The configuration file is simply a plain-text yaml file read by the [config](https://CRAN.R-project.org/package=config) package.  It is well-suited when a value has to be coordinated across multiple files.

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

The workflow of the repo is determined by `flow.R`.  It calls (typically R, Python, and SQL) files in a specific order, while sending the log messages to a file.

See [automation mediators](#automation-flow) for more details.

### `README.md` {#repo-readme}

The readme is automatically displayed the GitHub repository is opened in a browser.  Include all the static information that can quickly orientate a collaborator.  Common elements include:

* Project Name (see our [style guide](#style-repo-naming) for naming recommendations)
* Principal Investigator (ultimately accountable for the research) and Project Coordinator (easy contact if questions arise)
* IRB Tracking Number (or whatever oversight committee reviewed and approved the project).  This will help communicate more accurately within your larger university or company.
* Abstract or some project description that is already written (for example, part of the IRB submission).
* Documentation locations and resources, such as those described in the [`documentation/` section below](#repo-documentation)
* Data Locations and resources, such as
  * database and database server
  * REDCap project id and url
  * networked file share
* The PI's expectations and goals for your analysis team
* Likely deadlines, such as grant and conference submission dates

Each directory can have its own readme file, but (for typical analysis projects) we discourage you from putting too much in each individual readme.  We've found it becomes cumbersome to keep all the scattered files updated and consistent; it's also more work for the reader to traverse the directory structure reading everything.  Our approach is to concentrate most of the information in the repo's root readme, and the most of the remaining  readmes are static and unchanged across projects (*e.g.*, generic description of `data-public/metadata/`).

### `*.Rproj` {#repo-rproj}

The Rproj file stores project-wide settings used by the RStudio IDE, such how trailing whitespaces are handled.  The file's major benefit is that it sets the R session's working directory, which facilitates good discipline about setting a constant location for all files in the repo.  Although the plain-text file can be edited directly, we recommend using RStudio's dialog box.  There is good documentation about Rproj settings.  If you are unsure, copy [this file](https://github.com/wibeasley/RAnalysisSkeleton/blob/master/RAnalysisSkeleton.Rproj) to the repo's root directory and rename it to match the repo exactly.

`manipulation/` {#repo-manipulation}
------------------------------------

`analysis/` {#repo-analysis}
------------------------------------

In a sense, all the directories exist only to support the contents of `analysis/`.  All the exploratory, descriptive, and inferential statistics are produced by the Rmd files.  Each subdirectory is the name of the report, (*e.g.*, `analysis/report-te-1`) and within that directory are four files:
  * the R file that contains the meat of the analysis (*e.g.*, `analysis/report-te-1/report-te-1.R`).
  * the Rmd file that serves as the "presentation layer" and calls the R file (*e.g.*, `analysis/report-te-1/report-te-1.Rmd`).
  * the markdown file produced directly by the Rmd (*e.g.*, `analysis/report-te-1/report-te-1.md`).  Some people consider this an intermediate file because it exists mostly by knitr/rmarkdown/pandoc to produce the eventual html file.
  * the html file that is derived from the markdown file (*e.g.*, `analysis/report-te-1/report-te-1.html`).  The markdown and html files can be safely discarded because they will be reproduced the next time the Rmd is rendered.  All the tables and graphs in the html file are self-contained, meaning the single file is portable and emailed without concern for the directory it is read from.  Collaborators rarely care about any manipulation files or analysis code; they almost always look exclusively at the outputed html.

`data-public/` {#repo-data-public}
------------------------------------

This directory should contain information that is not sensitive and is not proprietary.  It SHOULD NOT hold [PHI](https://www.hhs.gov/answers/hipaa/what-is-phi/index.html) (Protected Health Information), or other information like participant names, social security numbers, or passwords.  Files with PHI should **not** be stored in a GitHub repository, even a [private GitHub repository](https://help.github.com/articles/publicizing-or-hiding-your-private-contributions-on-your-profile/).

Please see [`data-unshared/`](#repo-data-unshared) for options storing sensitive information.

The `data-public/` directory typically works best if organized with subdirectories.  We commonly use

* **`data-public/raw/`** for the input to the pipelines.  These datasets usually represents all the hard work of the data collection.

* **`data-public/metadata/`** for the definitions of the datasets in raw.  For example, "gender.csv" might translate the values 1 and 2 to male and female.  Sometimes a dataset feels natural in either the raw or the metadata subdirectory.  If the file would remain unchanged if a subsequent sample was collected, lean towards metadata.

* **`data-public/derived/`** for output of the pipelines.  Its contents should be completely reproducible when starting with `data-public/raw/` and the repo's code.  In other words, it can be deleted and recreated at ease.  This might contain a small database file, like SQLite.

* **`data-public/logs/`** for logs that are useful to collaborators or necessary to demonstrate something in the future, beyond the reports contained in the `analysis/` directory.

* **`data-public/original/`** for nothing (hopefully); ideally it is never used.  It is similar to `data-public/raw/`.  The difference is that `data-public/raw/` is called by the pipeline code, while `data-public/original/`  is not.

  A file in `data-public/original/`typically comes from the investigator in a malformed state and requires some manual intervention; then it is copied to `data-public/raw/`.  Common offenders are (a) a csv or Excel file with bad or missing column headers, (b) a strange file format that is not readable by an R package, (c) a corrupted file that require a rehabilitation utility.

The characteristics of `data-public/` vary based on the subject matter.  For instance, medical research projects typically use only the metadata directory of a repo, because the incoming information contains PHI and therefore a database is the preferred location.  On the other hand, microbiology and physics research typically do not have data protected by law, and it is desirable for the repo to contain everything so it's not unnecessarily spread out.

We feel a private GitHub repo offers adequate protection if being scooped is the biggest risk.

`data-unshared/` {#repo-data-unshared}
------------------------------------

Files in this directory are stored on the local computer, but are not committed and are not sent to the central GitHub repository/server.  This makes the folder a candidate for:

1. **sensitive information**, such as [PHI](https://www.hhs.gov/answers/hipaa/what-is-phi/index.html) (Protected Health Information).  When PHI is involved, we recommend `data-unshared/` only if a database or a secured networked file share is not feasible.  See the discussion below.

1. **huge public files** say, files that 1+ GB and easily downloadable or reproducible.  For instance, files from stable sources like the [US Census](https://www.census.gov/data/datasets.html), [Bureau of Labor Statistics](https://www.bls.gov/nls/), or [dataverse.org](https://dataverse.org/).

1. **diagnostic logs** that are not useful to collaborators.

A line in the repo's `.gitignore` file blocks the directory's contents from being staged/committed (look for `/data-unshared/*`).  Since files in this directory are not committed, it requires more discipline to communicate what files should be on a collaborator's computer.  List the files either in the [repo's readme](#repo-readme) or in `data-unshared/contents.md`; at a minimum declare the name of each file and how it can be downloaded or reproduced.  (If you are curious, the `!data-unshared/contents.md` line in `.gitignore` declares an exception so the markdown file is committed and updated on a collaborator's machine.)

Even though these files are kept off the central repository, we recommend encrypting your local drive if the `data-unshared/` contains sensitive data (such as PHI).  See the `data-public/` [`README.md`](data-public/) for more information.

The directory works best with the subdirectories described in the organization of [`data-public/`](#repo-data-public).

Compared to `data-unshared/`, we prefer storing PHI in an enterprise database (such as SQL Server, PostgreSQL, MariaDB/MySQL, or Oracle) or networked drive for four reasons.

1. These central resources are typically managed by Campus IT and reviewed by security professionals.
1. It's trivial to stay synchronized across collaborators with a file share or database. In contrast, `data-unshared/` isn't synchronized across machines so extra discipline is required to tell collaborators to update their machines.
1. It's sometimes possible to recover lost data from a file share or database.  It's much less likely to turn back the clock for `data-unshared/` files.
1. It's not too unlikely to mess up the `.gitignore` entries which would allow the sensitive files to be committed to the repository.  If sensitive information is stored on `data-unshared/`, it is important to review every commit to ensure information isn't about to sneak into the repo.

`documentation/` {#repo-documentation}
------------------------------------

Good documentation is scarce and documentation files consume little space, so liberally copy everything you get to this directory.  The most helpful include:

* Approval letters from the IRB or other oversight board.  This is especially important if you are also the gatekeeper of a database, and must justify releasing sensitive information.
* Data dictionaries for the incoming datasets your team is ingesting.
* Data dictionaries for the derived datasets your team is producing.

If the documentation is public and stable, like the CDC's site for [vaccination codes](https://www2a.cdc.gov/vaccines/iis/iisstandards/vaccines.asp?rpt=cvx), include the url in the [repo's readme](#repo-readme).  If you feel the information or the location may change, copy the url and also the full document so it is easier to reconstruct your logic when returning to the project in a few years.

Optional {#repo-optional}
------------------------------------

Everything mentioned until now should exist in the repo, even if the file or directory is empty.  Some projects benefit from the following additional capabilities.

### `DESCRIPTION` {#repo-description}

The plain-text `DESCRIPTION` file lives in the repo's root directory --see the [example](https://github.com/wibeasley/RAnalysisSkeleton/blob/main/DESCRIPTION) in R Analysis Skeleton.  The file allows your repo to become an R package, which provides the following benefits even if it will never be deployed to CRAN.

* specify the packages (and their versions) required by your code.  This include packages that aren't available on CRAN, like [OuhscBbmc/OuhscMunge](https://github.com/OuhscBbmc/OuhscMunge).
* better unify and test the common code called from multiple files.
* better document functions and datasets within the repo.

The last two bullets are essentially an upgrade from merely sticking code in a file and [sourcing](#chunk-load-sources) it.

A package offers many capabilities beyond those listed above, but a typical data science repo will not scratch the surface.  The larger topic is covered in Hadley Wickham's  [*R Packages*](https://r-pkgs.org/).

### `utility/` {#repo-utility}

Include files that may be run occasionally, but are not required to reproduce the analyses.  Examples include:

* code for submitting the entire repo pipeline on a super computer,
* simulate artificial demonstration data, or
* running diagnostic checks on your code using something like the [goodpractice](http://mangothecat.github.io/goodpractice/) or [urlchecker](https://r-lib.github.io/urlchecker/).

### `stitched-output/` {#repo-stitched}

[Stitching](https://yihui.org/knitr/demo/stitch/) is a light-weight capability of [knitr](https://yihui.org/knitr/)/[rmarkdown](https://rmarkdown.rstudio.com/).  If you stitch the repo's files (to server as a type of logging), consider directing all output to this directory.  The basic call is:

```r
knitr::stitch_rmd(
  script = "manipulation/car-ellis.R",
  output = "stitched-output/manipulation/car-ellis.md"
)
```

We don't use this approach for medical research, because sensitive information is usually contained in the output, and sensitive patient information should not be stored in the repo.  (That's the last time I'll talk about sensitive information --at least in this chapter.)
