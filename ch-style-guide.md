Style Guide {#style-guide}
====================================

Using a consistent style across your projects can increase the overhead as your data science team discusses options, decides on a good choice, and develops in compliant code.  But like in most themes in this document, the cost is worth the effort.  Unforced code errors are reduced when code is consistent, because mistake-prone styles are more apparent.

For the most part, our team follows the [tidyverse style](https://style.tidyverse.org/).  Here are some additional conventions we attempt to follow.  Many of these were inspired by [@balena-dimauro].

Readability
------------------------------------

### Abbreviations {#style-abbreviation}

Try to avoid abbreviations.  Different people tend to shorten words differently; this variability increases the chance that people reference the wrong variable.  At very least, it wastes time trying to remember if `subject_number`, `subject_num`, or `subject_no` was used.  The [Consistency](#architecture-consistency) section describes how this can reduce errors and increase efficiency.

However, some terms are too long to reasonably use without shortening.  We make some exceptions, such as the following scenarios:

1. humans commonly use the term orally.  For instance, people tend to say "OR" instead of "operating room".

1. your team has agreed on set list of abbreviations.  The list for our [CDW](https://github.com/OuhscBbmc/prairie-outpost-public#readme) team includes:
[appt](https://www.merriam-webster.com/dictionary/appointment), 
[cdw](https://en.wikipedia.org/wiki/Clinical_data_repository), 
[cpt](https://en.wikipedia.org/wiki/Current_Procedural_Terminology), 
[drg](https://en.wikipedia.org/wiki/Diagnosis-related_group) (stands for diagnosis-related group),
[dx](https://www.medicinenet.com/script/main/art.asp?articlekey=33829),
[hx](https://medical-dictionary.thefreedictionary.com/Hx),
[icd](https://www.cdc.gov/nchs/icd/icd10cm.htm)
[pt](https://www.medicinenet.com/script/main/art.asp?articlekey=39154), and
[vr]() (vital records).

When your team choose terms (*e.g.*, 'apt' vs 'appt'), try to use a standard vocabulary, such as [MedTerms Medical Dictionary](https://www.medicinenet.com/medterms-medical-dictionary/article.htm).

### Filtering Rows {#style-filter)

Removing datasets rows is an important operation that is a frequent source of sneaky errors.  These practices have hopefully reduced our mistakes and improved maintainability.  

#### Dropping rows with missing values {#style-filter-drop_na}

[`tidyr::drop_na()`]() drops rows with a missing value in a specific column.  

```r
ds %>%
  tidyr::drop_na(dob)
```

is cleaner to read and write than these two styles.  In particular, it's easy to forget/overllok a `!`.

```r
ds %>%
  dplyr::filter(!is.na(dob))
  
ds[!is.na(ds$dob), ]  
```


#### Mimic number line {#style-filter-number-line}

When ordering quantities, go smallest-to-largest as you type left-to-right.


#### Searchable verbs {#style-filter-searchable}

You've probably asked in frustration, "Where did all the rows go?  I had 1,000 in the middle of the file, but now have only 782."  Try to keep a consistent tools for filtering, so you can 'ctrl+f' only a handful of terms, such as
`filter`,
`drop_na`, and
`summarize/summarise`.

It's more difficult to highlight the When using the base R's filtering style, (*e.g.*, `ds <- ds[4 <= ds$count, ]`).

### Number {#style-number}

The word 'number' is ambiguous, especially in data science.  Try for more specific terms like 'count', 'id', 'index', and 'tally'.

Categorical Variables {#style-factor}
------------------------------------

There are lots of names for a categorical variable across the different disciplines (*e.g.*, factor, categorical, ...).  

### Explicit Missing Values {#style-factor-unknown}

Define a level like `"unknown"` so the data manipulation doesn't have to test for both `is.na(x)` and `x=="unknown"`.  The explicit labels also helps when included in a statistical procedure and coefficient table.

### Granularity {#style-factor-granularity}

Sometimes it helps to represent the values differently, say a granular and a coarse way.  We say `cut7` or `cut3` to denotes the number of levels; this is related to [`base::cut()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/cut.html).  'unknown' and 'other' are frequently levels, and they counts toward the quantity.

```r
education_cut7      = dplyr::recode(
  education_cut7,
  "No Highschool Degree / GED"  = "no diploma",
  "High School Degree / GED"    = "diploma",
  "Some College"                = "some college",
  "Associate's Degree"          = "associate",
  "Bachelor's Degree"           = "bachelor",
  "Post-graduate degree"        = "post-grad",
  "Unknown"                     = "unknown",
  .missing                      = "unknown",
),
education_cut3      = dplyr::recode(
  education_cut7,
  "no diploma"    = "no bachelor",
  "diploma"       = "no bachelor",
  "some college"  = "no bachelor",
  "associate"     = "no bachelor",
  "bachelor"      = "bachelor",
  "post-grad"     = "bachelor",
  "unknown"       = "unknown",
),
education_cut7 = factor(education_cut7, levels=c(
  "no diploma",
  "diploma",
  "some college",
  "associate",
  "bachelor",
  "post-grad",
  "unknown"
)),
education_cut3 = factor(education_cut3, levels=c(
  "no bachelor",
  "bachelor",
  "unknown"
))
```

Dates {#style-dates}
------------------------------------

* yob is an integer, but mob and wob are dates.  Typically months are collapsed to the 15th day and weeks are collapsed to Monday, which are the defaults of [`OuhscMunge::clump_month_date()`](http://ouhscbbmc.github.io/OuhscMunge/reference/clump_date.html) and [`OuhscMunge::clump_week_date()`](http://ouhscbbmc.github.io/OuhscMunge/reference/clump_date.html).  These help obfuscate the real value, if PHI is involved.  Months are centered because the midpoint is usually a better representation of the month's performance than the month's initial day.

* `birth_month_index` can be values 1 through 12, while `birth_month` (or commonly `mob`) contains the year (*e.g.*, 2014-07-15).

Naming
------------------------------------

### Semantic sorting {#style-naming-semantic}

Put the "biggest" term on the left side of the variable.



ggplot2 {#style-ggplot}
------------------------------------

The expressiveness of [ggplot2](https://ggplot2.tidyverse.org/) allows someone to quickly develop precise scientific graphics.  One graph can be specified in many equivalent styles, which increases the opportunity for confusion.  We formalized much of this style while writing a [textbook for introductory statistics](https://github.com/OuhscBbmc/DeSheaToothakerIntroStats/blob/master/thumbnails/thumbnails.md) (@deshea); the 200+ graphs and their code is publically available.


### Order of commands {#style-ggplot-order}

ggplot2 is essentially a collection of functions combined with the `+` operator.  Publication graphs common require at least 20 functions, which means the functions can sometimes be redundant or step on each other toes.  The family of functoins should follow a consistent order ideally starting with the more important structural functions and ending with the cosmetic functions.  Our preference is:

1. `ggplot()` is the primary function to specify the default dataset and aesthetic mappings.  Many arguments can be passed to `aes()`, and we prefer to follow an order consistent with the `scale_*()` order below.
1. `geom_*()` and `annotate()` creates the *geom*etric elements that reperesent the data.  Unlike most categories in this list, the order matters.  Geoms specified first are drawn first, and therefore can be obscured by subsequent geoms.
1. `scale_*()` describes how a dimension of data (specified in `aes()`) is translated into a visual element.  We specify the dimensions in descending order of (typical) importance: `x`, `y`, `group`, `color`, `fill`, `size`, `radius`, `alpha`, `shape`, `linetype`.
1. `coord_*()`
1. `facet_*()` and `label_*()`
1. `guides()`
1. `theme()`  (call the 'big' themes like `theme_minimal()` before overriding the details like `theme(panel.grid = element_line(color = "gray"))`)
1. `labs()`

### Gotchas {#style-ggplot-gotchas}

Here are some common mistakes we see not-so-infrequently (even sometimes in our own code).

#### Zooming {#style-ggplot-zoom}

Call `coord_*()` to restrict the plotted *x*/*y* values, not `scale_*()` or `lims()`/`xlim()`/`ylim()`.  `coord_*()` zooms in on the axes, so extreme values essentially fall off the page; in contrast, the latter three functions essentially remove the values from the dataset.  The distinction does not matter for a simple bivariate scatterplot, but likely will mislead you and the viewer in two common scenarios.  First, a call to `geom_smooth()` (*e.g.*, that overlays a loess regression curve) ignore the extreme values entirely; consequently the summary location will be misplaced and its standard errors too tight.  Second, when a line graph or spaghetti plots contains an extreme value, it is sometimes desirable to zoom in on the the primary area of activity; when calling `coord_*()`, the trend line will leave and return to the plotting panel (which implies points exist which do not fit the page), yet when calling the others, the trend line will appear interrupted, as if the extreme point is a missing value.
