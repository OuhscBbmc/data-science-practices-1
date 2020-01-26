Data at Rest {#data-rest}
====================================

Data States
------------------------------------

1. Raw
1. Derived
    1. Project-wide File on Repo
    1. Project-wide File on Protected File Server
    1. User-specific File on Protected File Server
    1. Project-wide Database
1. Original

Data Containers
------------------------------------

### csv {#data-rest-csv}

When exchanging data between two different systems, the preferred format is frequently plain text.  As opposed to proprietary formats like xlsx or sas7bdat, the file is easily opened and parsable by most statistical software, and even conventional text editors.

Incoming files should be plain-text [csv](https://en.wikipedia.org/wiki/Comma-separated_values) --not Excel or other proprietary or binary format.

### rds {#data-rest-rds}

### SQLite {#data-rest-sqlite}

### Central Enterprise database {#data-rest-database}

### Central REDCap database {#data-rest-redcap}

### Containers to avoid for raw/input {#data-rest-avoid}
    
1. Proprietary like xlsx, sas7bdat


Storage Conventions {#data-rest-conventions}
------------------------------------

### All Sources {#data-rest-conventions-all}

Across all file formats, these conventions usually work best.

1. **consistency across versions**: use a script to produce the dataset, and inform the recipient if the datasets's structure changes.  Most of our processes are automated, and changes that are trivial to humans (*e.g.*, `yyyy-mm-dd` to `mm/dd-yy`) will break the automation.  

    The specificity in our automation is intentional.  We install guards on our processes so that bad values do not pass.  For instance, we may place bounds on the toddlers' age at 12 and 36 months.  We *want* our automation to break if the next dataset contains age values between 1 and 3 (years).  Our downstream analysis (say, a regression model where age is a predictor variable) would produce misleading results if the shift between months and years went undetected.

1. **date format**: specify as `YYYY-MM-DD` ([ISO-8601](https://www.explainxkcd.com/wiki/index.php/1179:_ISO_8601))

1. **time format**: specify as `HH:MM` or `HH:MM:SS`, preferably in 24-hour time.  Use a leading zero from midnight to 9:59am, with a colon separating hours, minutes, and seconds (*i.e.*, **0**9:59) 

1. **patient names**: separate the `name_last`, `name_first`, and `name_middle` as three distinct variables when possible.

1. **currency**: represent money as an integer or floating-point variable.  This representation is more easily parsable by software, and enables mathematical operations (like `max()` or `mean()`) to be performed directly.  Avoid commas and symbols like "$".  If there is a possibility of ambiguity, indicate the denomination in the variable name (*e.g.*, `payment_dollars` or `payment_euros`).


### Text {#data-rest-conventions-text}

These conventions usually work best within plain-text formats.

1. **csv**: comma separated values are the most common plain-text format, so they have better support than similar formats where cells are separated by tabs or semi-colons.  However, if you are receiving a well-behaved file separated by these characters, be thankful and go with the flow.

1. **cells enclosed in quotes**: a 'cell' should be enclosed in double quotes, especially if it's a string/character variable.


### Excel {#data-rest-conventions-excel}

Although it may feel that you are fighting a losing battle, try not to receive data in Excel files.  I think Excel can be useful for light brainstorming and protyping equations --but is should not be used to contain serious data.  When avoiding Excel is not possible: 

1. **avoid multiple tabs/worksheets**: Excel files containing multiple worksheets are more complicated to read with automation, and the produces the opportunities for inconsistent variables across tabs/worksheets.

1. **save the cells as text**: avoiding Excel attempting to save cells as dates or numbers.  Admitedly, this is a last-ditch effort.  If someone is using Excel to convert cells to text, the values are probably already corrupted.

We receive extracts as Excel files frequently, and have the following request ready to email the person sending us Excel files.  Adapt the bold values like "109.19" to your situation.  If you are familiar with their tools, suggest an alternative for saving the file as a csv.  Once presented with these Excel gotchas, almost everyone has an 'aha' moment and recognizes the problem.  Unfortunately, not everyone has the capability to adapt easily.

---

[Start of the letter]

Sorry to be tedious, but could you please resend the extract as a [csv](https://en.wikipedia.org/wiki/Comma-separated_values) file?  Please call me if you have questions.

Excel is being too helpful with some of the values, and essentially corrupting them.  For example, values like **109.19** is interpreted as a number, not a character code (*e.g.*, see cell **L14**).  Because of [limitations of finite precision](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html), this becomes **109.18999999999999773**.  We can't round it, because there are other values in this column that cannot be cast to numbers, such as **V55.0**.  Furthermore, the "E"s in some codes are incorrectly interpreted as the exponent operator (*e.g.*, "4E5" is converted to 400,000).  Finally, values like **41.0** are being converted to a number and the trailing zero is dropped (so cells like "41" are not distinguishable from "41.0").

Unfortunately the problems exist in the Excel file itself.  When we import the columns [as text](https://readxl.tidyverse.org/reference/read_excel.html), the values are already in their corrupted state.

Please compress/zip the csv file if it might be too big to fit into an email.  We've found that an Excel file is 5-10 times larger than a compressed csv. 

As much as Excel interferes with our medical variables, we’re lucky.  It has messed with other branches of science much worse.  Genomics were using it far too late [before they realized their mistakes](https://qz.com/768334/years-of-genomics-research-is-riddled-with-errors-thanks-to-a-bunch-of-botched-excel-spreadsheets/).  I’m guessing some still use it.  

> What happened? By default, Excel and other popular spreadsheet applications convert some gene symbols to dates and numbers. For example, instead of writing out “Membrane-Associated Ring Finger (C3HC4) 1, E3 Ubiquitin Protein Ligase,” researchers have dubbed the gene MARCH1. Excel converts this into a date—03/01/2016, say—because that’s probably what the majority of spreadsheet users mean when they type it into a cell. Similarly, gene identifiers like “2310009E13” are converted to exponential numbers (2.31E+19). In both cases, the conversions strip out valuable information about the genes in question.

[End of the letter]
---


### JSON and XML {#data-rest-conventions-json}

The plain-text format is typically preferred when the data structures cannot be represented by nice rectangles. qqq

### Arrow {#data-rest-conventions-arrow}

[Apache Arrow](https://arrow.apache.org/) is an open source specification that is developed to work with many languages such as [R](https://arrow.apache.org/docs/r/), [Spark](https://towardsdatascience.com/a-gentle-introduction-to-apache-arrow-with-apache-spark-and-pandas-bb19ffe0ddae), [Python](https://spark.apache.org/docs/latest/sql-pyspark-pandas-with-arrow.html), and many others.  It accommodates nice rectangles where CSVs are used, and hierarchical nesting where json and xml are used.  

It is both an in-memory specification (which allows a Python process to directly access an R object), and an on-disk pspecification (which allows a Python process to read a saved R file).  The file format is compressed, so it takes much less space to store on disk and less time to transfer over a network.  

Its downside is the file is not plain-text, but binary.  That means the file is not readable and editable by as many programs, which hurts your project's portability.  You wouldn't want to store most metadata files as arrow because then your collaborators couldn't easily help you map the values to qqq

        
### Meditech {#data-rest-conventions-meditech}

1. **patient identifier**: `mrn_meditech` instead of `mrn`, `MRN Rec#`, or `Med Rec#`.

1. **account/admission identifier**: `account_number` instead of `mrn`, `Acct#`, or `Account#`.

1. **patient's full name**: `name_full` instead of `Patient Name` or `Name`.

1. **long/tall format**: one row per dx per patient (up to 50 dxs) instead of 50 *columns* of `dx` per patient.  Applies to

    1. diagnosis code & description

    1. order date & number

    1. procedure name & number

Meditech Idiosyncracies:

1. **blood pressure**: in most systems the `bp_diastolic` and `bp_systolic` values are stored in separate integer variables.  In Meditech, they are stored in a single character variable, separated by a foward slash.

### Databases {#data-rest-conventions-database}

When exchanging data between two different systems, ...
