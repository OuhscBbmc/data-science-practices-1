Data at Rest {#data-at-rest}
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

1. csv
1. rds
1. SQLite
1. Central Enterprise database
1. Central REDCap database
1. Containers to avoid for raw/input
    1. Proprietary like xlsx, sas7bdat

Storage Conventions {#data-rest-conventions}
------------------------------------

#### Plain Text {#data-rest-conventions-text}

When exchange data between two different systems, the preferred format is frequently plain text.  As opposed to proprietary formats like xlsx or sas7badt, the file is easily opened and parsable by most statistical software, and even conventional text editors.


##### All Sources

1. **file format**
    1. *plain text csv*: incoming files should be plain-text [csv](https://en.wikipedia.org/wiki/Comma-separated_values).  
        1. Not Excel or other proprietary or binary format.
        1. If Excel is necessary for some reason, please avoid multiple tabs/worksheets.  (They're slightly more complicated to read with automation, and the produces the opportunities for inconsistent variables across tabs/worksheets.)
    1. *cells enclosed in quotes*: a 'cell' should be enclosed in double quotes, especially if it's a string/character variable.
1. **date format**: use `YYYY-MM-DD` (*i.e.*, [ISO-8601](https://www.explainxkcd.com/wiki/index.php/1179:_ISO_8601))
1. **time format**: use `HH:MM` or `HH:MM:SS`.  Use a leading zero from midnight to 9:59am, witha colon separating hours, minutes, and seconds (*i.e.*, **0**9:59am) 
1. **patient names**: separate the `name_last`, `name_first`, and `name_middle` when possible.
1. **consistency across versions**: Please use a script to produce the data sent to us, and inform us when changes occur.  Most of our processes are automated, and changes that are trivial to humans (*e.g.*, `yyyy-mm-dd` to `mm/dd-yy`) cause problems for the automation.

##### Meditech

1. **patient identifier**: `mrn_meditech` instead of `mrn`, `MRI Rec#`, or `Med Rec#`.
1. **account/admission identifier**: `account_number` instead of `mrn`, `Acct#`, or `Account#`.
1. **patient's full name**: `name_full` instead of `Patient Name` or `Name`.
1. **long/tall format**: one row per dx per patient (up to 50 dxs) instead of 50 *columns* of `dx` per patient.  Applies to
    1. diagnosis code & description
    1. order date & number
    1. procedure name & number

Meditech Rejected:
1. **blood pressure**: `bp_diastolic` and `bp_systolic` as separate integer variables.  --Justin's response: it's stored as combined value in Meditech.
