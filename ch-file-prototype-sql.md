Prototypical SQL File {#file-prototype-sql}
====================================

New data scientists typically import entire tables from a database into R, and then merge, filter, and groom the data.frames.  A more efficient approach is to submit [sql](https://en.wikipedia.org/wiki/SQL) that executes on the database and returns a more specialized dataset.

This provides several advantages:

1. A database will be much more efficient when filtering and [joining](https://www.w3schools.com/sql/sql_join.asp) tables than any programing language, such as R or Python.  A well-designed database will have [indexed columns](https://en.wikipedia.org/wiki/Database_index#:~:text=A%20database%20index%20is%20a,maintain%20the%20index%20data%20structure.) and other optimizations that surpass R and Python capabilities.
1. A database handles datasets that are thousands of times larger than what R and Python can accommodate in RAM.  For large datasets, database engines persist the data on a hard drive (instead of just RAM) and are optimized to read the necessary information into RAM the moment before it is needed, and then return the processed back to disk before progressing to the next block of data.
1. Frequently, only a portion of the table's rows and columns are ultimately needed by the analysis.  Reducing the size of the dataset leaving the database has two benefits: less information travels across the network and R's and Python's limited memory space is conserved.

In some scenarios, it is desirable to use the `INSERT` SQL command to transfer data within the database; and never travel across the network and never touch R or your local machine.  For our large and complicated projects, the majority of data movement uses `INSERT` commands within SQL files.  Among these scenarios, the analysis-focused projects use R to call the sequence of SQL files (see [`flow.R`](#repo-flow)), while the database-focused project uss [SSIS](https://en.wikipedia.org/wiki/SQL_Server_Integration_Services).

In both cases, we try to write the SQL files to conform to similar standards and conventions.  As stated in [Consistency across Files](#consistency-files) (and in the [previous chapter](#file-prototype-r)), using a consistent file structure can (a) improve the quality of the code because the structure has been proven over time to facilitate good practices and (b) allow your intentions to be more clear to teammates because they are familiar with the order and intentions of the chunks.

Default Databases {#sql-default-database}
------------------------------------

```sql
```