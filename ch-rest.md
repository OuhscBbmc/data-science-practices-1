Data at Rest {#rest}
====================================

Data States {#rest-states}
------------------------------------

This is an extension of the [`data-public/`](#repo-data-public) discussion.  This chapter is more theoretical and applies to all forms of data, not just files in a [prototypical repo](#prototype-repo).

It is easiest to demarcate data into two states: raw and derived.  *Raw* data represents the input to the pipelines.  Sometimes their junk.  But usually these files should be cherished as the culmination of all the hard work of the data collection.  *Derived* data represents the output of the pipelines.  Its contents should be completely reproducible when starting with the raw data and the repo's code.  In other words, derived information can be deleted and recreated at ease.

In our terminology, an *original* data file is directly received from your collaborator.  On a good day, "original" and "raw" are synonymous.  Meaning the files received are ingestible directly into your pipeline.  However sometimes a collaborator provides a malformed data file that requires manual intervention.  Once it is rehabilitated, it becomes raw data.  Common offenders are (a) a csv or Excel file with bad or missing column headers, (b) a strange file format that is not readable by an R package, (c) a corrupted file that require a rehabilitation utility.

If an original file isn't perfect, you'll have to decide what blemishes can be programmatically fixed, and what blemishes will be manually fixed.  During this triage process, it is sometimes difficult to determine what is worth investing time to fix with code.  When everything can be fixed with code, the original and raw data are equivalent (and the "original" state can be ignored).

Here are some heuristics to help you decide what to address manually or programmatically.

Arguments for Programmatic Fixes:

1. *The original data is frequently refreshed.*  If your pipeline ingests new files every day, it's probably worth the investment to fix.

1. *The code would

Arguments for Manual Fixes:

1. *The corrections are subjective.*  Sometimes the desired fix does not follow deterministic rules.  In these scenarios, see the "Return the file to your collaborator" alternative.

1. *It's a quick fix for a one-time dataset.*

Alternatives:

1. *Return the file to your collaborator.*  Especially if grad students or interns are available.  One justification is that they're usually the experts in the field, while you are not.  They are better equipped to evaluate the data point and its context and determine the correct correction.  A second justification is your company/university probably doesn't want to pay statisticians and data scientists to clean up

  If you are a corporate consultant, propose that your team is willing to fix the data points and then provide the estimated cost for training your personnel how to correctly evaluate the context so the client can offload this task.

1. *Separate and excise the manual step.*  When the majority of a file can be ingested without manual intervention, try to split the task in two.  Consider a patient's visit record in a hospital database.  Most of the information is well-structured and easily transformed into discrete cells.  However the "visit notes" written by the nurses and physician are not.  Sometimes the notes are

1. Raw
1. Derived
    1. Project-wide File on Repo
    1. Project-wide File on Protected File Server
    1. User-specific File on Protected File Server
    1. Project-wide Database
1. Original

Data Containers
------------------------------------

### csv {#rest-containers-csv}

When exchanging data between two different systems, the preferred format is frequently plain text, where each cell in a record is separated by a comma.  This is commonly called a csv --a [comma separated value](https://en.wikipedia.org/wiki/Comma-separated_values) file.  As opposed to [proprietary formats](#data-containers-avoid) like xlsx or sas7bdat, a csv file is easily opened and parsable by most statistical software, and even conventional text editors and [GitHub](https://help.github.com/en/github/managing-files-in-a-repository/rendering-csv-and-tsv-data).

### rds {#rest-containers-rds}

### yaml, json, and xml {#rest-containers-yaml}

[yaml](https://circleci.com/blog/what-is-yaml-a-beginner-s-guide/), [json](https://www.w3schools.com/js/js_json_intro.asp), and [xml](https://www.w3schools.com/xml/) are three plain-text hierarchical formats commonly used when the data structure cannot be naturally represented by a rectangle or a set of rectangles (and therefore it is not a good fit for csv or rds).  If you are unsure where to start with a nested dataset, see tidyr's [Rectangling vignette](https://tidyr.tidyverse.org/articles/rectangle.html).

In the same way we advocate for the [simplest recoding](https://ouhscbbmc.github.io/data-science-practices-1/coding.html#coding-simplify-recoding) function that is adequate for the task, we prefer yaml over json, and json over xml.  Yaml accommodates most, but not all our needs.  Initially it may be tricky to correctly use whitespacing to specify the correct nesting structure in yaml, but once you are familar, the file is easy to read and edit, and the Git diffs can be quickly reviewed.  The [yaml](http://biostat.mc.vanderbilt.edu/wiki/Main/YamlR) package reads a yaml file, and returns a (nested) [R list](https://www.tutorialspoint.com/r/r_lists.htm); it can also convert an R list into a yaml file.

The [config](https://github.com/rstudio/config) package wraps the yaml package to fill a common need: retrieving repository configuration information from a yaml file.  We recommend using the config package when it fits.  In some ways its functionality is a simplification of the yaml package, but it is an extension in other ways.  For example, when a value follows `!expr`, R will evaluate the expression.   We commonly specify the allowable ranges for variables in [`config.yml`](https://github.com/OuhscBbmc/cdw-skeleton-1/blob/main/config.yml)

```yaml
range_dob: !expr c(as.Date("2010-01-01"), Sys.Date() + lubridate::days(1))
```

See the discussion of the [`config.yml`](https://ouhscbbmc.github.io/data-science-practices-1/prototype-repo.html#repo-config) in our prototypical repository, as well.

### Arrow {#rest-containers-arrow}

[Apache Arrow](https://arrow.apache.org/) is an open source specification that is developed to work with many languages such as [R](https://arrow.apache.org/docs/r/), [Spark](https://towardsdatascience.com/a-gentle-introduction-to-apache-arrow-with-apache-spark-and-pandas-bb19ffe0ddae), [Python](https://spark.apache.org/docs/latest/sql-pyspark-pandas-with-arrow.html), and many others.  It accommodates nice rectangles where CSVs are used, and hierarchical nesting where json and xml are used.

It is both an in-memory specification (which allows a Python process to directly access an R object), and an on-disk specification (which allows a Python process to read a saved R file).  The file format is compressed, so it takes much less space to store on disk and less time to transfer over a network.

Its downside is the file is not plain-text, but binary.  That means the file is not readable and editable by as many programs, which hurts your project's portability.  You wouldn't want to store most metadata files as arrow because then your collaborators couldn't easily help you map the values to qqq

### SQLite {#rest-containers-sqlite}

### Central Enterprise database {#rest-containers-database}

### Central REDCap database {#rest-containers-redcap}

### Containers to avoid {#rest-containers-avoid}

#### Spreadsheets {#rest-containers-avoid-spreadsheets}

Try not to receive data in Excel files.  We think Excel can be useful for light brainstorming and prototyping equations --but is should not be trusted to transport serious information.  Other spreadsheet software like [LibreOffice Calc](https://en.wikipedia.org/wiki/LibreOffice_Calc) is less problematic in our experience, but still less desirable than the formats mentioned above.

If you receive a csv and open it in a typical spreadsheet program, we strongly recommend to you do not save it, because of the potential for mangling values.  After you close the spreadsheet, [review the Git commits](#git-stability) to verify no values were corrupted.

See [the appendix](#snippets-correspondence-excel) for a list of the ways your analyses can be undermined when receiving Excel files, as well as a template to correspond with your less-experienced colleagues that is sending your team Excel files.

#### Proprietary {#rest-containers-avoid-proprietary}

Proprietary formats like [SAS](https://en.wikipedia.org/wiki/SAS_(software))'s "sas7bdat" are less accessible to people without the current expensive software licenses.  Therefore distributing proprietary file formats hurts reproducibility and decreases your project's impact.  On the other hand, using proprietary formats may be advantageous when you need to conceal the project's failure.

We formerly distributed sas7bdat files to supplement (otherwise identical) csvs, in order to cater to the suprisingly large population of SAS users who were unfamiliar with [proc import](https://documentation.sas.com/?docsetId=proc&docsetTarget=n18jyszn33umngn14czw2qfw7thc.htm&docsetVersion=9.4&locale=en) or the Google search engine.  Recently we have distributed only the csvs, with example code for reading the file from SAS.

Storage Conventions {#data-conventions}
------------------------------------

### All Sources {#rest-conventions-all}

Across all file formats, these conventions usually work best.

1. **consistency across versions**: use a script to produce the dataset, and inform the recipient if the dataset's structure changes.  Most of our processes are automated, and changes that are trivial to humans (*e.g.*, `yyyy-mm-dd` to `mm/dd-yy`) will break the automation.

    The specificity in our automation is intentional.  We install guards on our processes so that bad values do not pass.  For instance, we may place bounds on the toddlers' age at 12 and 36 months.  We *want* our automation to break if the next dataset contains age values between 1 and 3 (years).  Our downstream analysis (say, a regression model where age is a predictor variable) would produce misleading results if the shift between months and years went undetected.

1. **date format**: specify as `YYYY-MM-DD` ([ISO-8601](https://www.explainxkcd.com/wiki/index.php/1179:_ISO_8601))

1. **time format**: specify as `HH:MM` or `HH:MM:SS`, preferably in 24-hour time.  Use a leading zero from midnight to 9:59am, with a colon separating hours, minutes, and seconds (*i.e.*, **0**9:59)

1. **patient names**: separate the `name_last`, `name_first`, and `name_middle` as three distinct variables when possible.

1. **currency**: represent money as an integer or floating-point variable.  This representation is more easily parsable by software, and enables mathematical operations (like `max()` or `mean()`) to be performed directly.  Avoid commas and symbols like "$".  If there is a possibility of ambiguity, indicate the denomination in the variable name (*e.g.*, `payment_dollars` or `payment_euros`).

### Text {#rest-conventions-text}

These conventions usually work best within plain-text formats.

1. **csv**: comma separated values are the most common plain-text format, so they have better support than similar formats where cells are separated by tabs or semi-colons.  However, if you are receiving a well-behaved file separated by these characters, be thankful and go with the flow.

1. **cells enclosed in quotes**: a 'cell' should be enclosed in double quotes, especially if it's a string/character variable.

### Excel {#rest-conventions-excel}

As [discussed above]({#data-containers-avoid) avoid Excel.  When that is not possible, these conventions helps reduce ambiguity and corrupted values.  See [the appendix](#snippets-reading-excel) for our preferred approach to reading Excel files.

1. **avoid multiple tabs/worksheets**: Excel files containing multiple worksheets are more complicated to read with automation, and the produces the opportunities for inconsistent variables across tabs/worksheets.

1. **save the cells as text**: avoiding Excel attempting to save cells as dates or numbers.  Admitedly, this is a last-ditch effort.  If someone is using Excel to convert cells to text, the values are probably already corrupted.

### Meditech {#rest-conventions-meditech}

1. **patient identifier**: `mrn_meditech` instead of `mrn`, `MRN Rec#`, or `Med Rec#`.

1. **account/admission identifier**: `account_number` instead of `mrn`, `Acct#`, or `Account#`.

1. **patient's full name**: `name_full` instead of `Patient Name` or `Name`.

1. **long/tall format**: one row per dx per patient (up to 50 dxs) instead of 50 *columns* of `dx` per patient.  Applies to

    1. diagnosis code & description

    1. order date & number

    1. procedure name & number

Meditech Idiosyncracies:

1. **blood pressure**: in most systems the `bp_diastolic` and `bp_systolic` values are stored in separate integer variables.  In Meditech, they are stored in a single character variable, separated by a forward slash.

### Databases {#rest-conventions-database}

When exchanging data between two different systems, ...
