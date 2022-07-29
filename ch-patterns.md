Patterns {#patterns}
====================================

Ellis {#pattern-ellis}
------------------------------------

### Purpose

To incorporate outside data source into your system safely.

### Philosophy

* Without data immigration, all warehouses are useless.  Embrace the power of fresh information in a way that is:

  * repeatable when the data source is updated (and you have to refresh your warehouse)
  * similar to other Ellis lanes (that are designed for other data sources) so you don't have to learn/remember an entirely new pattern. (Like Rubiks cube instructions.)

### Guidelines

* Take small bites.

  * Like all software development, don't tackle all the complexity the first time.  Start by processing only the important columns before incorporating move.
  * Use only the variables you need in the short-term, especially for new projects.  As everyone knows, the variables from the upstream source can change.  Don't spend effort writing code for variables you won't need for a few months/years; they'll likely change before you need them.
  * After a row passes through the `verify-values` chunk, you're accountable for any failures it causes in your warehouse.  All analysts know that external data is messy, so don't be surprised.  Sometimes I'll spend an hour writing an Ellis for 6 columns.

* Narrowly define each Ellis lane.  One code file should strive to (a) consume only one CSV and (b) produce only one table.  Exceptions include:
    1. if multiple input files are related, and really belong together (*e.g.*, one CSV per month, or one CSV per clinic).  This scenario is pretty common.
    1. if the CSV should legitimately produce two different tables after munging.  This happens infrequently, such as one warehouse table needs to be wide, and another long.

### Examples

* <https://github.com/wibeasley/RAnalysisSkeleton/blob/master/manipulation/te-ellis.R>
* <https://github.com/wibeasley/RAnalysisSkeleton/blob/master/manipulation/>
* <https://github.com/OuhscBbmc/usnavy-billets/blob/master/manipulation/survey-ellis.R>

### Elements

1. **Clear memory** In scripting languages like R (unlike compiled languages like Java), it's easy for old variables to hang around.  Explicitly clear them before you run the file again.

    ```r
    rm(list = ls(all = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.
    ```

1. **Load Sources** In R, a `source()`d file is run to execute its code.  We prefer that a sourced file only load variables (like function definitions), instead of do real operations like read a dataset or perform a calculation.  There are many times that you want a function to be available to multiple files in a repo; there are two approaches we like.  The first is collecting those common functions into a single file (and then sourcing it in the callers).  The second is to make the repo a legitimate R package.

    The first approach is better suited for quick & easy development.  The second allows you to add documentation and unit tests.

    ```r
    # ---- load-sources ------------------------------------------------------------
    source("./manipulation/osdh/ellis/common-ellis.R")
    ```

1. **Load Packages** This is another precaution necessary in a scripting language.  Determine if the necessary packages are available on the machine.  Avoiding attaching packages (with the `library()` function) when possible.  Their functions don't need to be qualified (*e.g.*, `dplyr::intersect()`) and could cause naming conflicts.  Even if you can guarantee they don't conflict with packages now, packages could add new functions in the future that do conflict.

    ```r
    # ---- load-packages -----------------------------------------------------------
    # Attach these package(s) so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
    library(magrittr            , quietly=TRUE)
    library(DBI                 , quietly=TRUE)

    # Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
    requireNamespace("readr"        )
    requireNamespace("tidyr"        )
    requireNamespace("dplyr"        ) # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
    requireNamespace("testit")
    requireNamespace("checkmate")
    requireNamespace("OuhscMunge") # remotes::install_github(repo="OuhscBbmc/OuhscMunge")

    ```

1. **Declare Global Variables and Functions**.  This includes defining the expected column names and types of the data sources; use `readr::cols_only()` (as opposed to `readr::cols()`) to ignore any new columns that may be been added since the dataset's last refresh.

    ```r
    # ---- declare-globals ---------------------------------------------------------
    ```

1. **Load Data Source(s)** See [load-data](#chunk-load-data) chunk described in the prototypical file.

    ```r
    # ---- load-data ---------------------------------------------------------------
    ```

1. **Tweak Data**

    See [tweak-data](#chunk-tweak-data) chunk described in the prototypical file.

    ```r
    # ---- tweak-data --------------------------------------------------------------
    ```

1. **Body of the Ellis**

1. **Verify**

1. **Specify Columns**

    See [specify-columns-to-upload](#chunk-specify-columns) chunk described in the prototypical file.

    ```r
    # ---- specify-columns-to-upload -----------------------------------------------
    ```

1. **Welcome** into your warehouse.  Until this chunk, nothing should be persisted.

    ```r
    # ---- save-to-db --------------------------------------------------------------
    # ---- save-to-disk ------------------------------------------------------------
    ```

Arch {#pattern-arch}
------------------------------------

Ferry {#pattern-ferry}
------------------------------------

Scribe {#pattern-scribe}
------------------------------------

Analysis {#pattern-analysis}
------------------------------------

Presentation -Static {#pattern-presentation-static}
------------------------------------

Presentation -Interactive {#pattern-presentation-interactive}
------------------------------------

Metadata {#pattern-metadata}
------------------------------------

Survey items can change across time (for justified and unjustified reasons).  We prefer to dedicate a metadata csv to a single variable

https://github.com/LiveOak/vasquez-mexican-census-1/issues/17#issuecomment-567254695

| relationship_id | code_2011 | code_2016 | relationship             | display_order | description_2011         | description_2016         |
|-----------------|-----------|-----------|--------------------------|---------------|--------------------------|--------------------------|
| 1               | 1         | 1         | Jefe(a)                  | 1             | Jefe(a)                  | Jefe(a)                  |
| 2               | 2         | 2         | Esposo(a) o compañero(a) | 2             | Esposo(a) o compañero(a) | Esposo(a) o compañero(a) |
| 3               | 3         | 3         | Hijo(a)                  | 3             | Hijo(a)                  | Hijo(a)                  |
| 4               | 4         | 4         | Nieto(a)                 | 4             | Nieto(a)                 | Nieto(a)                 |
| 5               | 5         | 5         | Yerno/nuera              | 5             | Yerno/nuera              | Yerno/nuera              |
| 6               | 6         | 6         | Hermano(a)               | 6             | Hermano(a)               | Hermano(a)               |
| 7               | 7         | NA        | Sobrino(a)               | 7             | Sobrino(a)               | NA                       |
| 8               | 8         | NA        | Padre o madre            | 8             | Padre o madre            | NA                       |
| 9               | 9         | NA        | Suegro(a)                | 9             | Suegro(a)                | NA                       |
| 10              | 10        | NA        | Cuñado(a)                | 10            | Cuñado(a)                | Cuñado(a)                |
| 11              | 11        | 7         | Otros parientes          | 11            | Otros parientes          | Otros parientes          |
| 12              | 12        | 8         | No parientes             | 12            | No parientes             | No parientes             |
| 13              | 13        | 9         | Empleado(a) doméstico(a) | 13            | Empleado(a) doméstico(a) | Empleado(a) doméstico(a) |
| 99              | 99        | NA        | No especificado          | 99            | No especificado          | NA                       |

### Primary Rules for Mapping

A few important rules are necessary to map concepts in this multidimensional space.

1. each **variable** gets its own **csv**, such as `relationship.csv` (show above), `education.csv`, `living-status.csv`, or `race.csv`.  It's easiest if this file name matches the variable.

1. each **variable** also needs a unique *integer* that identifies the underlying level in the database, such as `education_id`, `living_status_id`, and `relationship_id`.

1. each **survey wave** gets its own **column** within the csv, such as `code_2011` and `code_2016`.

1. each **level** within a variable-wave gets its own **row**, like `Jefe`, `Esposo`, and `Hijo`.

### Secondary Rules for Mapping

In this scenarios, the first three columns are critical (*i.e.*, `relationship_id`, `code_2011`, `code_2016`).  Yet these additional guidelines will help the plumbing and manipulation of lookup variables.

1. each **variable** also needs a unique *name* that identifies the underlying level for human, such as `education`, `living_status`, and `relationship`.  This is the human label corresponding to `relationship_id`.  It's easiest if this column name matches the variable.

1. each **survey wave** gets its own **column** within the csv, such as `description_2011` and `description_2016`.  These are the human labels corresponding to variables like `code_2011` and `code_2016`.

1. each **variable** benefits from a unique *display order* value, that will be used later in analyses.  Categorical variables typically have some desired sequence in graph legends and tables; specify that order here.  This helps define the [`factor`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/factor.html) levels in R or the [`pandas.Categorical`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Categorical.html#pandas.Categorical) levels in Python.

1. Mappings are usually informed by outside documentation.  For transparency and maintainability, clearly describe where the documentation can be found.  One option is to include it in `data-public/metadata/README.md`.  Another option is to include it at the bottom of the csv, preceded by a `#`, or some 'comment' character that can keep the csv-parser from treating the notes like data it needs to squeeze into cells.  Notes for this example are:

    ```csv
    # Notes,,,,,,
    # 2016 codes come from `documentation/2106/fd_endireh2016_dbf.pdf`, pages 14-15,,,,,
    # 2011 codes come from `documentation/2011/fd_endireh11.xls`, ‘TSDem’ tab,,,,,
    ```

1. sometimes a `notes` column helps humans keep things straight, especially researchers new to the field/project.  In the example above, the `notes` value in the first row might be "*jefe* means 'head', not 'boss'".
