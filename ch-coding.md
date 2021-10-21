Coding Principles {#coding}
====================================

Simplify {#coding-simplify}
------------------------------------

### Data Types {#coding-simplify-types}

Use the simplest data type reasonable.  A simpler data type is less likely contain unintended values.  As we have seen, a string variable called `gender` can simultaneously contain the values "m", "f", "F", "Female", "MALE", "0", "1", "2", "Latino", "", and `NA`.  On the other hand, a boolean variable `gender_male` can be only `FALSE`, `TRUE`, and `NA`.^[The equivalent of R's `logical` data type is called a `bit` in [SQL Server](https://docs.microsoft.com/en-us/sql/t-sql/data-types/bit-transact-sql), and a `boolean` in [Postgres](https://www.postgresql.org/docs/current/datatype-boolean.html) and [MySQL](https://dev.mysql.com/doc/refman/8.0/en/boolean-literals.html). SQLite's `integer` is best alternative for boolean variables.]

[SQLite](https://www.sqlite.org/datatype3.html) does not have a dedicated datatype, so you must resort to storing it as `0`, `1` and `NULL` values.  Because a caller can't assume that an ostensible boolean SQLite variable contains only those three values, the variable should be checked.

Once you have cleaned a variable in your initial ETL files (like an [Ellis](https://ouhscbbmc.github.io/data-science-practices-1/patterns.html#pattern-ellis)), establish boundaries so you do not have to spend time in the downstream files verifying that no bad values have been introduced.  As a small bonus, simpler data types are typically faster, consume less memory, and translate more cleanly across platforms.

Within R, numeric-ish variables can be represented by the following four data types.  Use the simplest type that adequately captures the information.  `logical` is the simplest and `numeric` is the most flexible.

1. `logical`/boolean/bit,
1. `integer`,
1. `bit64::integer64`, and
1. `numeric`/double-precision floats.

Categorical variables have a similar spectrum.  After `logical` types, `factor`s are more restrictive and less flexible than `character`s.^[In the database world, `character` variables are typically represented by the `varchar`; when setting the maximum length, consider padding with some extra character.  If most of the entries are eight to ten characters, consider using `varchar(15)`.  Mimicking a `factor` variable is more complicated.  Factor levels are typically defined in a dedicated table (commonly called a lookup table), and then referenced with a foreign key relationship.  In many circumstances saving an R factor to a database, we will use a simple `varchar`.]

1. `logical`/boolean/bit,
1. `factor`, and
1. `character`.

### Categorical Levels {#coding-simplify-categorical}

When a boolean variable would be too restrictive and a factor or character is required, choose the simplest representation.  Where possible:

1. Use only lower case (*e.g.*, 'male' instead of 'Male' for the `gender` variable).
1. avoid repeating the variable in the level (*e.g.*, 'control' instead of 'control condition' for the `condition` variable).

### Recoding {#coding-simplify-recoding}

Almost every project recodes variables.  Choose the simplest function possible.  The functions at the top are easier to read and harder to mess up than the functions below it

1. **Leverage existing booleans:** Suppose you have the logical variable `gender_male` (which can be only `TRUE`, `FALSE`, or `NA`).  Writing `gender_male == TRUE` or `gender_male == FALSE` will evaluate to a boolean --that's unnecessary because `gender_male` is already a boolean.

    1. *Testing for `TRUE`*: use the variable by itself (*i.e.*, `gender_male` instead of `gender_male == TRUE`).

    1. *Testing for `FALSE`*:  use `!`.  Write `!gender_male` instead of `gender_male == FALSE` or `gender_male != TRUE`.

1. **[`dplyr::coalesce()`](https://dplyr.tidyverse.org/reference/coalesce.html)**: The function evaluates a single variable and replaces `NA` with values from another variable.

    A coalesce like

    ```r
    visit_completed = dplyr::coalesce(visit_completed, FALSE)
    ```

    is much easier to read and not mess up than

    ```r
    visit_completed = dplyr::if_else(!is.na(visit_completed), visit_completed, FALSE)
    ```

1. **[`dplyr::na_if()`](https://dplyr.tidyverse.org/reference/na_if.html)** transforms a nonmissing value into an NA.

    Recoding missing values like

    ```r
    birth_apgar = dplyr::na_if(birth_apgar, 99)
    ```

    is easier to read and not mess up than

    ```r
    birth_apgar = dplyr::if_else(birth_apgar == 99, NA_real_, birth_apgar)
    ```

1. **`<=`** (or a similar comparison operator): Compare two quantities to output a boolean variable.  The parentheses are unnecessary, but can help readability.  If either value is `NA`, then the result is `NA`.

    Notice that we prefer to order the variables like a number line.  When the result is `TRUE`, the smaller value is to the left of the larger value.

    ```r
    dob_in_the_future   <- (Sys.Date() < dob)
    dod_follows_dob     <- (dob <= dod)
    premature           <- (gestation_weeks < 37)
    big_boy             <- (threshold_in_kg <= birth_weight_in_kg)
    ```

1. **[`dplyr::if_else()`](https://dplyr.tidyverse.org/reference/if_else.html)**:  The function evaluates a single boolean variable or expression.  The output branches to only three possibilities: the input is (a) true, (b) false, or (c) (optionally) `NA`.  Notice that unlike the `<=` operator, `dplyr::if_else()` lets you specify a value if the input expression evaluates to `NA`. 

    ```r
    date_start  <- as.Date("2017-01-01")

    # If a missing month element needs to be handled explicitly.
    stage       <- dplyr::if_else(date_start <= month, "post", "pre", missing = "missing-month")

    # Otherwise a simple boolean output is sufficient.
    stage_post  <- (date_start <= month)
    ```

    If it is important that the reader understand that an input expression of `NA` will produce an NA, consider using `dplyr::if_else()`.  Even though these two lines are equivalent, a casual reader may not consider that `stage_post` could be `NA`.

    ```r
    stage_post  <- (date_start <= month)
    stage_post  <- dplyr::if_else(date_start <= month, TRUE, FALSE, missing = NA)
    ```

1. **[`dplyr::between()`](https://dplyr.tidyverse.org/reference/between.html)**: The function evaluates a numeric `x` against a `left` and a `right` boundary to return a boolean value.  The output is `TRUE` if `x` is inside the boundaries or equal to either boundary (*i.e.*, the boundaries are *in*clusive).  The output is `FALSE` if `x` is outside either boundary.

    ```r
    too_cold      <- 60
    too_hot       <- 88
    goldilocks_1  <- dplyr::between(temperature, too_cold, too_hot)

    # This is equivalent to the previous line.
    goldilocks_2  <- (too_cold <= temperature & temperature <= too_hot)
    ```
    
    If you need an *ex*clusive boundary, abandon `dplyr::between()` and specify it exactly.

    ```r
    # Left boundary is exclusive
    goldilocks_3  <- (too_cold < temperature & temperature <= too_hot)

    # Both boundaries are exclusive
    goldilocks_4  <- (too_cold < temperature & temperature <  too_hot)
    ```

    If your code starts to nest `dplyr::between()` calls inside `dplyr::if_else()`, consider `base::cut()`.

1. **[`base::cut()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/cut.html)**: The function transforms a single numeric variable into a factor.  Its range is cut into different segments/categories on the one-dimensional number line.  The output branches to single discrete value (either a factor-level or an integer).  Modify the `right` parameter to `FALSE` if you'd like the left/lower bound to be inclusive (which tends to be more natural for me).

    ```r
    mtcars |> 
      tibble::as_tibble() |> 
      dplyr::select(
        disp,
      ) |> 
      dplyr::mutate(
        # Example of a simple inequality operator (see two bullets above)
        muscle_car            = (300 <= disp),
        
        # Divide `disp` into three levels.
        size_default_labels   = cut(disp, breaks = c(-Inf, 200, 300, Inf), right = F),
        
        # Divide `disp` into three levels with custom labels.
        size_cut3             = cut(
          disp, 
          breaks = c(-Inf,   200,      300,   Inf),
          labels = c(  "small", "medium", "big"),
          right = FALSE  # Is the right boundary INclusive ('FALSE' is an EXclusive boundary)
        ),  
        
        # Divide `disp` into five levels with custom labels.
        size_cut5             = cut(
          disp, 
          breaks = c(-Inf,         100,            150,            200,      300,   Inf),
          labels = c(  "small small", "medium small", "biggie small", "medium", "big"),
          right = FALSE
        ),
      )
    ````

1. **[`dplyr::recode()`](https://dplyr.tidyverse.org/reference/recode.html)**: The function accepts an integer or character variable.  The output branches to a single discrete value.  This example maps integers to strings.

    ```r
    # https://www.census.gov/quickfacts/fact/note/US/RHI625219
    race_id        <- c(1L, 2L, 1L, 4L, 3L, 4L, 2L, NA_integer_)
    race_id_spouse <- c(1L, 1L, 2L, 3L, 3L, 4L, 5L, NA_integer_)
    race <-
      dplyr::recode(
        race_id,
        "1"      = "White",
        "2"      = "Black or African American",
        "3"      = "American Indian and Alaska Native",
        "4"      = "Asian",
        "5"      = "Native Hawaiian or Other Pacific Islander",
        .missing = "Unknown"
      )
    ```
    
    If multiple variables have the same mapping, define the mapping once in a named vector, and pass it for multiple calls to `dplyr::recode()`.  Notice that the two variables `race` and `race_spouse` use the same mapping.^[For now, employ the `!!!` operator without understanding it.  When you're more comfortable with R, read about [quosures and lazy evaluation](https://adv-r.hadley.nz/quasiquotation.html#unquoting-many-arguments) so you can use it in more general scenarios.]
    
    ```r
    mapping_race <- c(
      "1" = "White",
      "2" = "Black or African American",
      "3" = "American Indian and Alaska Native",
      "4" = "Asian",
      "5" = "Native Hawaiian or Other Pacific Islander"
    )
    race <-
      dplyr::recode(
        race_id,
        !!!mapping_race,
        .missing = "Unknown"
      )
    race_spouse <-
      dplyr::recode(
        race_id_spouse,
        !!!mapping_race,
        .missing = "Unknown"
      )
    ```
    
    Tips for `dplyr::recode()`:
      * A resuable dedicated mapping vector is very useful for surveys with 10+ Likert items with consistent levels like "disagree", "neutral", "agree".
      * Use [`dplyr::recode_factor()`](https://dplyr.tidyverse.org/reference/recode.html) to map integers to factor levels.  
      * [`forcats::fct_recode()`](https://forcats.tidyverse.org/reference/fct_recode.html) is similar.  We prefer the `.missing` parameter of `dplyr::recode()` that recodes NA values into an explicit value.
      * When using the [REDCap API](https://ouhscbbmc.github.io/REDCapR/), these functions help convert radio buttons to a character or factor variable.

1. **lookup table**:  It is feasible to recode 6 levels of race directly in R, but it's less feasible to recode 200 provider names.  Specify the mapping in a csv, then use [readr](https://readr.tidyverse.org/reference/read_delim.html) to convert the csv to a data.frame, and finally [left join](https://dplyr.tidyverse.org/reference/mutate-joins.html) it.

1. **[`dplyr::case_when()`](https://dplyr.tidyverse.org/reference/case_when.html)**: The function is the most complicated because it can evaluate multiple variables.  Also, multiple cases can be true, but only the first output is returned. This 'water fall' execution helps in complicated scenarios, but is overkill for most.

Defensive Style {#coding-defensive}
------------------------------------

### Qualify functions {#coding-defensive-qualify-functions}

Try to prepend each function with its package.  Write `dplyr::filter()` instead of `filter()`.  When two packages contain public functions with the same name, the package that was most recently called with `library()` takes precedent.  When multiple R files are executed, the packages' precedents may not be predictable.  Specifying the package eliminates the ambiguity, while also making the code easier to follow.  For this reason, we recommend that almost all R files contain a ['load-packages'](#chunk-load-packages) chunk.

See the [Google Style Guide](https://google.github.io/styleguide/Rguide.html#qualifying-namespaces) for more about qualifying functions.

Some exceptions exist, including:

* The [sf](https://r-spatial.github.io/sf/) package if you're using its objects [with dplyr verbs](https://r-spatial.github.io/sf/articles/sf6.html#why-do-dplyr-verbs-not-work-for-sf-objects).

### Date Arithmetic {#coding-defensive-date-arithmetic}

Don't use the minus operator (*i.e.*, `-`) to subtract dates.  Instead use `as.integer(difftime(stop, start, units="days"))`.  It's longer but protects from the scenario that `start` or `stop` are changed upstream to a datetime.  In that case, `stop - start` equals the number of *seconds* between the two points, not the number of *days*.

### Excluding Bad Cases

Some variables are critical to the record, and if it's missing, you don't want or trust any of its other values.  For instance, a hospital visit record rarely useful if missing the patient ID.  In these cases, prevent the record from passing through the [ellis](#pattern-ellis).

In this example, we'll presume we can't trust a patient record if it lacks a clean date of birth (`dob`).

1. Define the permissible range, in either the ellis's [declare-globals](#chunk-declare) chunk, or in the [config-file](#repo-config).  (We'll use the config file for this example.)  We'll exclude anyone born before 2000, or after tomorrow.  Even though it's illogical for someone in a retrospective record to be born tomorrow, consider bending a little for small errors.

    ```yaml
    range_dob   : !expr c(as.Date("2000-01-01"), Sys.Date() + lubridate::days(1))
    ```

1. In the [tweak-data](#chunk-tweak-data) chunk, use [`OuhscMunge::trim_date()`](https://ouhscbbmc.github.io/OuhscMunge/reference/trim.html) to set the cell to `NA` if it falls outside an acceptable range.  After [`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html), call [`tidyr::drop_na()`](https://tidyr.tidyverse.org/reference/drop_na.html) to exclude the entire record, regardless if (a) it was already `NA`, or (b) was "trimmed" to `NA`.

    ```r
    ds <-
      ds %>%
      dplyr::mutate(
        dob = OuhscMunge::trim_date(dob, config$range_dob)
      ) %>%
      tidyr::drop_na(dob)
    ```

1. Near the end of the file, verify the variable for three reasons: (a) there's a chance that the code above isn't working as expected, (b) some later code later might have introduced bad values, and (c) it clearly documents to a reader that `dob` was included in this range at this stage of the pipeline.

    ```r
    checkmate::assert_date(ds$dob, any.missing=F, lower=config$range_dob[1], upper=config$range_dob[2])
    ```
