Snippets {#snippets}
====================================

Reading External Data {#snippets-reading}
------------------------------------

### Reading from Excel {#snippets-reading-excel}

*Background*: Avoid Excel for the [reasons previously discussed]({#data-containers-avoid).  But if there isn't another good option, be protective.  [`readxl::read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html) allows you to specify column types, but not column order.  The names of `col_types` is ignored by `readxl::read_excel()`.  To defend against roaming columns (*e.g.*, the files changed over time), `tesit::assert()` that the order is what you expect.

See the readxl vignette, [Cell and Column Types](https://readxl.tidyverse.org/articles/cell-and-column-types.html), for more info.

*Last Modified*: 2019-12-12 by Will

```r
# ---- declare-globals ---------------------------------------------------------
config                         <- config::get()

# cat(sprintf('  `%s`             = "text",\n', colnames(ds)), sep="") # 'text' by default --then change where appropriate.
col_types <- c(
  `Med Rec Num`     = "text",
  `Admit Date`      = "date",
  `Tot Cash Pymt`   = "numeric"
)

# ---- load-data ---------------------------------------------------------------
ds <- readxl::read_excel(
  path      = config$path_admission_charge,
  col_types = col_types
  # sheet   = "dont-use-sheets-if-possible"
)

testit::assert(
  "The order of column names must match the expected list.",
  names(col_types) == colnames(ds)
)
```

### Removing Trailing Comma from Header {#snippets-reading-trailing-comma}

*Background*: Occasionally a Meditech Extract will have an extra comma at the end of the 1st line.  For each subsequent line, [`readr:read_csv()`](https://readr.tidyverse.org/reference/read_delim.html) appropriately throws a new warning that it is missing a column.  This warning flood can mask real problems.

*Explanation*: This snippet (a) reads the csv as plain text, (b) removes the final comma, and (c) passes the plain text to `readr::read_csv()` to convert it into a data.frame.

*Instruction*: Modify `Dx50 Name` to the name of the final (real) column.

*Real Example*: [truong-pharmacist-transition-1](https://github.com/OuhscBbmc/truong-pharmacist-transition-1/blob/eec6d7eb8aaa9e3df52dafb826dbc53aaf515c63/manipulation/ellis/dx-ellis.R#L158-L162) (Accessible to only CDW members.)

*Last Modified*: 2019-12-12 by Will

```r
# The next two lines remove the trailing comma at the end of the 1st line.
raw_text  <- readr::read_file(path_in)
raw_text  <- sub("^(.+Dx50 Name),", "\\1", raw_text)

ds        <- readr::read_csv(raw_text, col_types=col_types)
```

### Removing Trailing Comma from Header {#snippets-reading-vroom}

*Background*: When incoming data files are on the large side to comfortably accept with [readr](https://readr.tidyverse.org/), we use [vroom](https://vroom.r-lib.org/).  The two packages are developed by the same group and [might be combined](https://github.com/tidyverse/tidyverse.org/pull/375#issuecomment-564781603) in the future.

*Explanation*: This snippet defines the `col_types` list with names to mimic [our approach](https://ouhscbbmc.github.io/data-science-practices-1/prototype-r.html#chunk-declare) of using readr.  There are some small differences with our readr approach:
  1. `col_types` is a [list](https://stat.ethz.ch/R-manual/R-devel/library/base/html/list.html) instead of a [`readr::cols_only`](https://readr.tidyverse.org/reference/cols.html) object.
  1. The call to [`vroom::vroom()`](https://vroom.r-lib.org/reference/vroom.html) passes `col_names = names(col_types)` explicitly.
  1. If the data file contains columns we don't need, we define them in `col_types` anyway; vroom needs to know the file structure if it's missing a header row.

*Real Example*: [akande-medically-complex-1](https://github.com/OuhscBbmc/akande-medically-complex-1/tree/main/manipulation/ohca) (Accessible to only CDW members.)  Thesee files did not have a header of variable names; the first line of the file is the first data row.

*Last Modified*: 2020-08-21 by Will

```r
# ---- declare-globals ---------------------------------------------------------
config            <- config::get()

col_types <- list(
  sak                      = vroom::col_integer(),  # "system-assigned key"
  aid_category_id          = vroom::col_character(),
  age                      = vroom::col_integer(),
  service_date_first       = vroom::col_date("%m/%d/%Y"),
  service_date_lasst       = vroom::col_date("%m/%d/%Y"),
  claim_type               = vroom::col_character(),
  provider_id              = vroom::col_character(),
  provider_lat             = vroom::col_double(),
  provider_long            = vroom::col_double(),
  provider_zip             = vroom::col_character(),
  cpt                      = vroom::col_integer(),
  revenue_code             = vroom::col_integer(),
  icd_code                 = vroom::col_character(),
  icd_sequence             = vroom::col_integer(),
  vocabulary_coarse_id     = vroom::col_integer()
)

# ---- load-data ---------------------------------------------------------------
ds <- vroom::vroom(
  file      = config$path_ohca_patient,
  delim     = "\t",
  col_names = names(col_types),
  col_types = col_types
)

rm(col_types)
```

Grooming {#snippets-grooming}
------------------------------------

### Correct for misinterpreted two-digit year {#snippets-grooming-two-year}

*Background*: Sometimes the Meditech dates are specified like `1/6/54` instead of `1/6/1954`.  `readr::read_csv()` has to choose if the year is supposed to be '1954' or '2054'.  A human can use context to guess a birth date is in the past (so it guesses 1954), but readr can't (so it guesses 2054).  For avoid this and other problems, request dates in an [ISO-8601](https://www.explainxkcd.com/wiki/index.php/1179:_ISO_8601) format.

*Explanation*: Correct for this in a `dplyr::mutate()` clause; compare the date value against today.  If the date is today or before, use it; if the day is in the future, subtract 100 years.

*Instruction*: For future dates such as loan payments, the direction will flip.

*Last Modified*: 2019-12-12 by Will

```r
 ds |>
 dplyr::mutate(
    dob = dplyr::if_else(dob <= Sys.Date(), dob, dob - lubridate::years(100))
  )
```

Identification {#snippets-identification}
------------------------------------

### Generating "tags"  {#snippets-identification-tags}

*Background*: When you need to generate unique identification values for future people/clients/patients, as described in the [style guide](#style-number).

*Explanation*: This snippet will create a 5-row csv with random 7-character "tags" to send to the research team collecting patients.  The

*Instruction*: Set `pt_count`, `tag_length`, `path_out`, and execute.  Add and rename the columns to be more appropriate for your domain (*e.g.*, change "patient tag" to "store tag").

*Last Modified*: 2019-12-30 by Will

```r
pt_count    <- 5L   # The number of rows in the dataset.
tag_length  <- 7L   # The number of characters in each tag.
path_out    <- "data-private/derived/pt-pool.csv"

draw_tag <- function (tag_length = 4L, urn = c(0:9, letters)) {
  paste(sample(urn, size = tag_length, replace = T), collapse = "")
}

ds_pt_pool <-
  tibble::tibble(
    pt_index    = seq_len(pt_count),
    pt_tag      = vapply(rep(tag_length, pt_count), draw_tag, character(1)),
    assigned    = FALSE,
    name_last   = "--",
    name_first  = "--"
  )

readr::write_csv(ds_pt_pool, path_out)
```

The resulting dataset will look like this, but with different randomly-generated tags.

```csv
# A tibble: 5 x 5
  pt_index pt_tag  assigned name_last name_first
     <int> <chr>   <lgl>    <chr>     <chr>
1        1 seikyfr FALSE    --        --
2        2 voiix4l FALSE    --        --
3        3 wosn4w2 FALSE    --        --
4        4 jl0dg84 FALSE    --        --
5        5 r5ei5ph FALSE    --        --
```

Correspondence with Collaborators {#snippets-correspondence}
------------------------------------

### Excel files {#snippets-correspondence-excel}

Receiving and storing [Excel files should almost always be avoided](#data-containers-avoid) for the reasons explained in this letter.

We receive extracts as Excel files frequently, and have the following request ready to email the person sending us Excel files.  Adapt the bold values like "109.19" to your situation.  If you are familiar with their tools, suggest an alternative for saving the file as a csv.  Once presented with these Excel gotchas, almost everyone has an 'aha' moment and recognizes the problem.  Unfortunately, not everyone has flexible software and can adapt easily.

---

[Start of the letter]

Sorry to be tedious, but could you please resend the extract as a [csv](https://en.wikipedia.org/wiki/Comma-separated_values) file?  Please call me if you have questions.

Excel is being too helpful with some of the values, and essentially corrupting them.  For example, values like **109.19** is interpreted as a number, not a character code (*e.g.*, see cell **L14**).  Because of [limitations of finite precision](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html), this becomes **109.18999999999999773**.  We can't round it, because there are other values in this column that cannot be cast to numbers, such as **V55.0**.  Furthermore, the "E"s in some codes are incorrectly interpreted as the exponent operator (*e.g.*, "4E5" is converted to 400,000).  
Finally, values like [001.0](http://www.icd9data.com/2015/Volume1/001-139/001-009/001/001.0.htm) are being converted to a number and any leading or trailing zeros are dropped (so cells like "1" are not distinguishable from "001.0").

Unfortunately the problems exist in the Excel file itself.  When we import the columns [as text](https://readxl.tidyverse.org/reference/read_excel.html), the values are already in their corrupted state.

Please compress/zip the csv if the file is be too large to email.  We've found that an Excel file is typically 5-10 times larger than a compressed csv.

As much as Excel interferes with our medical variables, we’re lucky.  It has messed with other branches of science much worse.  Genomics were using it far too late [before they realized their mistakes](https://qz.com/768334/years-of-genomics-research-is-riddled-with-errors-thanks-to-a-bunch-of-botched-excel-spreadsheets/).

> What happened? By default, Excel and other popular spreadsheet applications convert some gene symbols to dates and numbers. For example, instead of writing out “Membrane-Associated Ring Finger (C3HC4) 1, E3 Ubiquitin Protein Ligase,” researchers have dubbed the gene MARCH1. Excel converts this into a date—03/01/2016, say—because that’s probably what the majority of spreadsheet users mean when they type it into a cell. Similarly, gene identifiers like “2310009E13” are converted to exponential numbers (2.31E+19). In both cases, the conversions strip out valuable information about the genes in question.

[End of the letter]
