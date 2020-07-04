Prototypical SQL File {#file-prototype-sql}
====================================

New data scientists typically import entire tables from a database into R, and then merge, filter, and groom the data.frames.  A more efficient approach is to submit [sql](https://en.wikipedia.org/wiki/SQL) that executes on the database and returns a more specialized dataset.

This provides several advantages:

1. A database will be much more efficient when filtering and [joining](https://www.w3schools.com/sql/sql_join.asp) tables than any programing language, such as R or Python.  A well-designed database will have [indexed columns](https://en.wikipedia.org/wiki/Database_index#:~:text=A%20database%20index%20is%20a,maintain%20the%20index%20data%20structure.) and other optimizations that surpass R and Python capabilities.
1. A database handles datasets that are thousands of times larger than what R and Python can accommodate in RAM.  For large datasets, database engines persist the data on a hard drive (instead of just RAM) and are optimized to read the necessary information into RAM the moment before it is needed, and then return the processed back to disk before progressing to the next block of data.
1. Frequently, only a portion of the table's rows and columns are ultimately needed by the analysis.  Reducing the size of the dataset leaving the database has two benefits: less information travels across the network and R's and Python's limited memory space is conserved.

In some scenarios, it is desirable to use the `INSERT` SQL command to transfer data within the database; and never travel across the network and never touch R or your local machine.  For our large and complicated projects, the majority of data movement uses `INSERT` commands within SQL files.  Among these scenarios, the analysis-focused projects use R to call the sequence of SQL files (see [`flow.R`](#repo-flow)), while the database-focused project uss [SSIS](https://en.wikipedia.org/wiki/SQL_Server_Integration_Services).

In both cases, we try to write the SQL files to conform to similar standards and conventions.  As stated in [Consistency across Files](#consistency-files) (and in the [previous chapter](#file-prototype-r)), using a consistent file structure can (a) improve the quality of the code because the structure has been proven over time to facilitate good practices and (b) allow your intentions to be more clear to teammates because they are familiar with the order and intentions of the chunks.

Ferry {#sql-ferry}
------------------------------------

This basic sql file moves data within a database to create a table named `dx`, which is contained in the `ley_covid_1` schema of the `cdw_staging` database.

```sql
--use cdw_staging
declare @start_date date = '2020-02-01';                               -- sync with config.yml
declare @stop_date  date = dateadd(day, -1, cast(getdate() as date));  -- sync with config.yml

DROP TABLE if exists ley_covid_1.dx;
CREATE TABLE ley_covid_1.dx(
  dx_id           int identity(1, 1) primary key,
  patient_id      int         not null,
  covid_confirmed bit         not null,
  problem_date    date            null,
  icd10_code      varchar(20) not null
);
-- TRUNCATE TABLE ley_covid_1.dx;

INSERT INTO ley_covid_1.dx
SELECT
  pr.patient_id
  ,ss.covid_confirmed
  ,pr.invoice_date     as problem_date
  ,pr.code             as icd10_code
  -- into ley_covid_1.dx
FROM cdw.star_1.fact_problem       as pr
  inner join beasley_covid_1.ss_dx as ss on pr.code = ss.icd10_code
WHERE
  pr.problem_date_start between @start_date and @stop_date
  and
  pr.patient_id is not null
ORDER BY pr.problem_date_start

CREATE INDEX ley_covid_1_dx_patient_id on ley_covid_1.dx (patient_id);
CREATE INDEX ley_covid_1_dx_icd10_code on ley_covid_1.dx (icd10_code);
```

Default Databases {#sql-default-database}
------------------------------------

We prefer not to specify the database of each table, and instead control it through the connection (such as the DSN's "default database" value).  Nevertheless, it's helpful to include the default database behind a comment for two reasons.  First, it communicates to the default database to the human reader.  Second, during debugging, the code can be highlighted in [ADS](#workstation-ads)/[SSMS](#workstation-ssms) and executed with "F5"; this will mimic what happens when the file is run via automation with a DSN.

```sql
--use cdw_staging
```

Declare Values Databases {#sql-default-database}
------------------------------------

Similar to the [Declare Globals](#chunk-declare) chunk in a [prototypical R file](file-prototype-r), values set at the top of the file are easy to read and modify.

```sql
declare @start_date date = '2020-02-01';                               -- sync with config.yml
declare @stop_date  date = dateadd(day, -1, cast(getdate() as date));  -- sync with config.yml
```

Recreate Table {#sql-recreate}
------------------------------------

When batch-loading data, it is typically easiest drop and recreate a database table.  In the snippet below, any table with the specific name is dropped/deleted from the database and replaced with a (possibly new) definition.  We like to dedicate a line to each table column, with at least three elements per line: the name, the [data type](https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql), and if nulls are allowed.

Many other features and keywords are available when designing tables.  The ones we occasionally use are:

1. [`primary key`](https://www.w3schools.com/sql/sql_primarykey.ASP) helps database optimization when later querying the table, and enforces uniqueness, such as a patient table should not have any two rows with the same `patient_id` value.  Primary keys must be nonmissing, so the `not null` keyword is redundant.
1. [`unique`](https://www.w3schools.com/sql/sql_unique.asp) is helpful when a table has additional columns that need to be unique (such as `patient_ssn` and `patient_id`).  A more advanced scenario using a [clustered columnar table](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-overview#when-should-i-use-a-columnstore-index), which is incompatible with the `primary key` designation.
1. `identity(1, 1)` creates a 1, 2, 3, ... sequence, which relieves the client of creating the sequence with something like [`row_number()`](https://docs.microsoft.com/en-us/sql/t-sql/functions/row-number-transact-sql).  Note that when identity column exists, the number columns in the `SELECT` clause will be one fewer than the columns defined in `CREATE TABLE`.

```sql
DROP TABLE if exists ley_covid_1.dx;
CREATE TABLE ley_covid_1.dx(
  dx_id           int identity(1, 1) primary key,
  patient_id      int         not null,
  covid_confirmed bit         not null,
  problem_date    date            null,
  icd10_code      varchar(20) not null
);
```

To jump-start the creation of the table definition, we frequently use the [`INTO`](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-into-clause-transact-sql) clause.  This operation creates a new table, informed the column properties of the source tables.  Within [ADS](#workstation-ads) and [SSMS](#workstation-ssms), refresh the list of tables and select the new table; there will be an option to copy the `CREATE TABLE` statement (similar to the snippet above) and paste it into the sql file.  The definition can then be modified, such as tightening from `null` to `not null`.

```sql
  -- into ley_covid_1.dx
```

Truncate Table {#sql-truncate}
------------------------------------

In scenarios where the table definition is stable and the data is refreshed frequently (say, daily), consider [TRUNCATE](https://docs.microsoft.com/en-us/sql/t-sql/statements/truncate-table-transact-sql)-ing the table.  When taking this approach, we prefer to keep the `DROP` and `CREATE` code in the file, but commented out.  This saves development time in the future if the table definition needs to be modified.

```sql
-- TRUNCATE TABLE ley_covid_1.dx;
```

```sql
INSERT INTO ley_covid_1.dx
```

```sql
SELECT
  pr.patient_id
  ,ss.covid_confirmed
  ,pr.invoice_date     as problem_date
  ,pr.code             as icd10_code
```

```sql
FROM cdw.star_1.fact_problem       as pr
  inner join beasley_covid_1.ss_dx as ss on pr.code = ss.icd10_code
```

```sql
WHERE
  pr.problem_date_start between @start_date and @stop_date
  and
  pr.patient_id is not null
```

```sql
ORDER BY pr.problem_date_start
```

```sql
CREATE INDEX ley_covid_1_dx_patient_id on ley_covid_1.dx (patient_id);
CREATE INDEX ley_covid_1_dx_icd10_code on ley_covid_1.dx (icd10_code);
```