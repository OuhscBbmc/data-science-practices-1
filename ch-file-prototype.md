Prototypical File {#file-prototype}
====================================

As stated before, in [Consistency across Files](#consistency-files), using a consistent file structure can (a) improve the quality of the code because the structure has been proven over time to facilitate good practices and (b) allow your intentions to be more clear to teammates because they are familiar with the order and intentions of the chunks.

We use the term "chunk" for a section of code because it corresponds with knitr terminology [@xie2015], and in many analysis files (as opposed to manipulation files), the chunk of our R file connects to a knitr Rmd file.

Clear Memory
------------------------------------
Before the initial chunk many of our files clear the memory of variables from previous run. This is important when developig and debugging because it prevents previous runs from contaminating subsequent runs.  However it has little effect during production; we'll look at manipulation files separately from analysis files.  

Manipulation R files are [`source`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/source.html)d with the argument `local=new.env()`.  The file is executed in a fresh environment, so there are no variables to clear.  Analysis R files are typically called from an Rmd file's `knitr::read_chunk()`, and code positioned above the first chunk is not called by knitr ^[Read more about knitr's [code externalization](https://yihui.name/knitr/demo/externalization/)].

However typically do not clear the memory in R files that are [`source`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/source.html)d in the same environment as the caller, as it will interfere with the caller's variables.

```r
rm(list = ls(all.names = TRUE))
```

Load Sources
------------------------------------

In the first true chunk, [`source`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/source.html) any R files containing global variables and functions that the current file requires.  For instance, when a team of statisticians is producing a large report containing many analysis files, we define many of the graphical elements in a single file.  This sourced file defines common color palettes and graphical functions so the cosmetics are more uniform across analyses.

We prefer not to have `source`d files perform any real action, such as importing data or manipulating a file.  One reason is because it is difficult to be consistent about the environmental variables when the sourced file's functions are run.  A second reason is that it more cognitively difficult to understand how the files are connected.  

When the sourced file contains only function definitions, these operations can be called at any time in the current file with much tighter control of which variables are modfied.  A bonus of the discipline of defining functions (instead of executing functions) is that the operations are typically more robust and generalizable.

Keep the chunk even if no files are sourced.  An empty chunk is instructive to readers trying to determine if any files are sourced. This applies recommendation applies to all the chunks discussed in this chapter.  As always, your team should agree on its own set of standards.

```r
# ---- load-sources ------------------------------------------------------------
base::source(file="./analysis/common/display-1.R")      # Load common graphing functions.
```

Load Packages {#load-packages}
------------------------------------

The 'load-packages' chunk declares required packages near the file's beginning for three reasons.  First, a reader scanning the file can quickly determine its dependencies when located in a single chunk.  Second, if your machine is lacking a required package, it is best to know early^[The error message "Error in library(foo) : there is no package called 'foo'" is easier to understand than "Error in bar() : could not find function 'bar'" thrown somewhere in the middle of the file; this check can also illuminate conflicts arising when two packages have a `bar()` function. See McConnell 2004 Section qqq for more about the 'fail early' principle.].  Third, this style mimics a requirement of other languages (such as declaring headers at the top of a C++ file) and follows the [tidyverse style guide](https://style.tidyverse.org/files.html#internal-structure).

As discussed in the previous [qualify all functions](#qualify-functions) section, we recommend that functions are qualified with their package (*e.g.*, `foo::bar()` instead of merely `bar()`).  Consequently, the 'load-packages' chunk calls `requireNamespace()` more frequently than `library()`.  `requireNamespace()` verifies the package is available on the local machine, but does not load it into memory; `library()` verifies the package is available, and then loads it.

`requireNamespace()` is not used in several scenarios.

1. Core packages (*e.g.*, 'base' and 'stats') are loaded by R in most default installations.  We avoid unnecessary calls like `library(stats)` because they distract from more important features.
1. Obvious dependencies are not called by `reqiureNamespace()` or `library()` for similar reasons, especially if they are not called directly.  For example 'tidyselect' is not listed when 'tidyr' is listed.
1. The "pipe" function (declared in the `magrittr' package , *i.e.*, `%>%`) is attached with `import::from(magrittr, "%>%")`.  This frequently-used function called be called throughout the execution without qualification.
1. Compared to manipulation files, our analysis files tend to use many functions in a few concentrated packages so conflicting function names are less common.  Typical packages used in analysis are 'ggplot2' and 'lme4'.
    
The `source`d files above may load their own packages (by calling `library()`).  It is important that the `library()` calls in this file follow the 'load-sources' chunk so that identically-named functions (in different packages) are called with the correct precedent.  Otherwise identically-named functions will conflict in the namespace with hard-to-predict results.  

Read [R Packages](http://r-pkgs.had.co.nz/namespace.html#search-path) for more about `library()`, `requireNamespace()`, and their siblings, as well as the larger concepts such as attaching functions into the search path.

Here are packages found in most of our manipulation files.  Notice the lesser-known packages have a quick explanation; this helps maintainers decide if the declaration is still necessary.  Also notice the packages distributed outside of CRAN (*e.g.*, GitHub) have a quick commented line to help the user install or update the package.

```r
# ---- load-packages -----------------------------------------------------------
import::from(magrittr, "%>%" )

requireNamespace("readr"     )
requireNamespace("tidyr"     )
requireNamespace("dplyr"     ) 
requireNamespace("config"    ) 
requireNamespace("checkmate" ) # Asserts expected conditions 
requireNamespace("OuhscMunge") # remotes::install_github(repo="OuhscBbmc/OuhscMunge")
```

Declare Globals
------------------------------------
When values are repeatedly used within a file, consider dedicating a variable so it's defined and set only once.  This is also a good place for variables that are used only once, but whose value are central to the file's mission. Typical variables in our 'declare-globals' chunk include data file paths, data file variables, color palettes, and values in the *config* file.

The [config file](#repo-root) can coordinate a static variable across multiple files.  Centrally 

```r
# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
config                         <- config::get()
path_db                        <- config$path_database

# Execute to specify the column types.  It might require some manual adjustment (eg doubles to integers).
#   OuhscMunge::readr_spec_aligned(config$path_subject_1_raw)
col_types <- readr::cols_only(
  subject_id          = readr::col_integer(),
  county_id           = readr::col_integer(),
  gender_id           = readr::col_double(),
  race                = readr::col_character(),
  ethnicity           = readr::col_character()
)
```

Load Data
------------------------------------

All data ingested by this file occurs in this chunk.  We like to think of each file as a linear pipe with a single point of input and single point of output.  Although it is possible for a file to read  data files on any line, we recommend avoiding this sprawl because it is more difficult for humans to understand.  If the software developer is a deist watchmaker, the file's fate has been sealed by the end of this chunk.  This makes is easier for a human to reason to isolate problems as either existing with (a) the incoming data or (b) the calculations on that data.

Ideally this chunk consumes data from either a plain-text csv or a database.

Many capable R functions and packages ingest data.  We prefer the tidyverse [readr]() for reading conventional files; its younger cousin, [vroom]() has some nice advantages when working with larger files and some forms of jagged rectangles^[Say a csv has 20 columns, but a row has missing values for the last five columns.  Instead of five successive commas to indicate five empty cells exist, a jagged rectangle simply ends after the last nonmissing value.  vroom infers the missing values correctly, while some other packages do not.].

Tweak Data
------------------------------------

(Unique Content)
------------------------------------

Verify Values
------------------------------------

Specify Output Columns
------------------------------------

Save to Disk or Database
------------------------------------
