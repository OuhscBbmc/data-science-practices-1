Prototypical Repository {#repo-prototype}
====================================

https://github.com/wibeasley/RAnalysisSkeleton

Root {#repo-root}
------------------------------------

1. `config.R`  is simply a plain-text yaml file read by the [config](https://CRAN.R-project.org/package=config) package.  It is great when a value has to be coordinated across multiple file

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
    pattern_mrn_centricity  : "^\\d{16}$"        # The 64-bit int is more easily validated as a character.
    ```
    
1. `flow.R`
1. `README.md`
1. `*.Rproj`

Analysis
------------------------------------

Data Public
------------------------------------
1. Raw
1. Derived
1. Metadata
1. Database
1. Original


Data Unshared
------------------------------------

Documentation
------------------------------------

Manipulation
------------------------------------

Stitched Output
------------------------------------

Utility
------------------------------------
