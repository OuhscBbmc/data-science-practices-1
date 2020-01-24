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

1. **date format**: use `YYYY-MM-DD` ([ISO-8601](https://www.explainxkcd.com/wiki/index.php/1179:_ISO_8601))

1. **time format**: use `HH:MM` or `HH:MM:SS`.  Use a leading zero from midnight to 9:59am, with a colon separating hours, minutes, and seconds (*i.e.*, **0**9:59am) 

1. **patient names**: separate the `name_last`, `name_first`, and `name_middle` when possible.

1. **consistency across versions**: Use a script to produce the data sent to us, and inform us when changes occur.  Most of our processes are automated, and changes that are trivial to humans (*e.g.*, `yyyy-mm-dd` to `mm/dd-yy`) cause problems for the automation.

1. **currency**: represent money as an integer or floating-point variable.  This representation is more easily parsable by software, and enables mathematical operations (like `max()` or `mean()`) to be performed directly.  Avoid commas and symbols like "$".  If there is a possibility of ambiguity, indicate the denomination in the variable name (*e.g.*, `payment_dollars` or `payment_euros`).


### Text {#data-rest-conventions-text}

These conventions usually work best within plain-text formats.

1. **csv**: comma separated values are the most common plain-text format, so they have better support than similar formats where cells are separated by tabs or semi-colons.  However, if you are receiving a well-behaved file separated by these characters, just go with the flow.

1. **cells enclosed in quotes**: a 'cell' should be enclosed in double quotes, especially if it's a string/character variable.


### Excel Exceptions {#data-rest-conventions-excel}

If Excel is necessary for some reason, 

1. **avoid multiple tabs/worksheets**: they are more complicated to read with automation, and the produces the opportunities for inconsistent variables across tabs/worksheets.


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
