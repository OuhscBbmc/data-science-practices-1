Coding Principles {#coding}
====================================

Simplify
------------------------------------

### Data Types

Use the simplest data type reasonable.  A simpler data type is less likely contain unintended values.  As we have seen, a string variable called `gender` can simultaneously contain the values "m", "f", "F", "Female", "MALE", "0", "1", "2", "Latino", "", and `NA`.  On the other hand, a boolean variable `gender_male` can be only `FALSE`, `TRUE`, and `NA`.^[The equivalent of R's `logical` data type is called a `bit` in [SQL Server](https://docs.microsoft.com/en-us/sql/t-sql/data-types/bit-transact-sql), and a `boolean` in [Postgres](https://www.postgresql.org/docs/current/datatype-boolean.html) and [MySQL](https://dev.mysql.com/doc/refman/8.0/en/boolean-literals.html). 

[SQLite](https://www.sqlite.org/datatype3.html) does not have a dedicated datatype, so you must resort to storing it as `0`, `1` and `NULL` values.  Because a caller can't assume that an obstensible boolean SQLite variable contains only those three values, the variable should be checked.]

Once you have cleaned a variable in your initial ETL files (like an Ellis), lock it down so you do not have to spend time in the downstream files verifying that no bad values have been introduced.  As a small bonus, simpler data types are typically faster, consume less memory, and translate more cleanly across platforms.

Within R, the preference for numeric-ish variables is 

1. `logical`/boolean/bit, 
1. `integer`, 
1. `bit64::integer64`, and 
1. `numeric`/double-precision floats.  

The preference for categorical variables is 

1. `logical`/boolean/bit, 
1. `factor`, and 
1. `character`.

### Categorical Levels

When a boolean variable would be too restrictive and a factor or character is required, choose the simplest representation.  Where possible:

1. Use only lower case (*e.g.*, 'male' instead of 'Male' for the `gender` variable).
1. avoid repeating the variable in the level (*e.g.*, 'control' instead of 'control condition' for the `condition` variable).

### Recoding

Almost every project recodes many variables.  Choose the simplest function possible.  The functions at the top are much easier to read and harder to mess up.

1. **`!`**: instead of `gender_male == FALSE` or `gender_male != TRUE`, write `!gender_male`.

1. **`dplyr::coalesce()`**: The function evaluates a single variable and replaces `NA` with values from another variable.

    A coalesce like
    
    ```r
    visit_completed = dplyr::coalesce(visit_completed, FALSE)
    ```
    
    is much easier to read and not mess up than
    
    ```r
    visit_completed = dplyr::if_else(!is.na(visit_completed), visit_completed, FALSE)
    ```

1. **`dplyr::na_if()`** transforms a nonmissing value into an NA.

    Recoding missing values like
    
    ```r
    birth_apgar = dplyr::na_if(birth_apgar, 99)
    ```
    
    is easier to read and not mess up than
    
    ```r
    birth_apgar = dplyr::if_else(birth_apgar == 99, NA_real_, birth_apgar)
    ```

1. **`<=`** (or a similar comparison operator): Compare two quantities to output a boolean variable.

1. **`dplyr::if_else()`**:  The function evaluates a single boolean variable.  The output branches to only three possibilities: condition is (a) true, (b) false, or (c) (optionally) `NA`.  An advantage over `<=` is that `NA` values can be specified directly.

    ```r
    date_start <- as.Date("2017-01-01")
    
    # If a missing month element needs to be handled explicitly.
    stage       = dplyr::if_else(date_start <= month, "pre", "post", missing = "missing-month")
    
    # Otherwise a simple boolean output is sufficient.
    stage_post  = (date_start <= month)
    ```

1. **`base::cut()`*: The function evaluations only a single numeric variable.  It's range is cut into different segments/categories on the one-dimensional number line.  The output branches to single discrete value (either a factor-level or an integer).

1. *`dplyr::recode()`**: The function evaluates a single integer or character variable.  The output branches to a single discrete value.

1. **lookup table**:  It feasible recode 6 levels of race directly in R.  It's less feasible to recode 200 provider names.  Specify the mapping in a csv, `readr` the csv to a data.frame, and left-join it.

1. **`dplyr::case_when()`**: The function is the most complicated because it can evaluate multiple variables.  Also, multiple cases can be true, but only the first output is returned. This 'water fall' execution helps in complicated scenarios, but is overkill for most.

Defensive Style
------------------------------------

### Qualify functions {#qualify-functions}  

Try to prepend each function with its package.  Write `dplyr::filter()` instead of `filter()`.  When two packages contain public functions with the same name, the package that was most recently called with `library()` takes precedent.  When multiple R files are executed, the packages' precedents may not be predictable.  Specifying the package eliminates the ambiguity, while also making the code easier to follow.  For this reason, we recommend that almost all R files contain a ['load-packages'](#chunk-load-packages) chunk.

See the [Google Style Guide](https://google.github.io/styleguide/Rguide.html#qualifying-namespaces) for more about qualifying functions
