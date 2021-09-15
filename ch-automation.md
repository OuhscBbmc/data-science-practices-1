Automation & Reproducibility {#automation}
====================================

Automation is an important prerequisite of reproducibility.

Mediator {#automation-mediator}
------------------------------------

A nontrivial project usually has multiple stages in its pipeline.  Instead of a human deciding when to execute which piece, a single file should execute the pieces.  The single file makes the project more portable, and also clearly documents the process.

This single file is a special cases of the [mediator pattern](https://en.wikipedia.org/wiki/Mediator_pattern), in the sense that it defines how each piece relates to each other.

### Flow File in R {#automation-flow}

{Describe https://github.com/wibeasley/RAnalysisSkeleton/blob/master/flow.R.}

See also the [prototypical repo](#repo-flow).

### Makefile {#automation-makefile}

{Briefly describe this language, how it can be more efficient, and what additional obstacles it presents.}

### SSIS {#automation-ssis}

{Describe SSIS package development.}

Scheduling {#automation-scheduling}
------------------------------------

### cron  {#automation-cron}

[cron](https://en.wikipedia.org/wiki/Cron) is the common choice when scheduling tasks on Linux.  A plain text file specifies which file to run, and on what recurring schedule.  A lot of [helpful documentation and tutorials](https://www.computerhope.com/unix/ucrontab.htm) exists, as well as sites that help construct and validate your entries like [crontab guru](https://crontab.guru/).

### Task Scheduler {#automation-task-scheduler}

[Windows Task Scheduler](https://en.wikipedia.org/wiki/Windows_Task_Scheduler) is the common choice when scheduling tasks on Windows.

Many of the GUI options are easy to specify, but three are error-prone, and must be specified carefully.  They exist under "Actions" | "Start a program".

1. **Program/script:** is the absolute path to `Rscript.exe`.  It needs to be updated every time you upgrade R (unless you're doing something tricky with the `PATH` environmental OS variable).  Notice we are using the "patched" version of R.  The entry should be enclosed in quotes.

    ```sh
    "C:\Program Files\R\R-4.1.1patched\bin\Rscript.exe"
    ```

1. **Add arguments (optional):** specifies the flow file to run.  In this case, the repo 'butcher-hearing-screen-1' is under in the 'Documents/cdw/` directory; the [flow file](#automation-flow) is located in the repo's root directory, as discussed in the [prototypical repo](#repo-flow).  The entry should be enclosed in quotes.

    ```shell
    "C:\Users\wbeasley\Documents\cdw\butcher-hearing-screen-1\flow.R"
    ```

1. **Start in (optional):** sets the working directory.  If not properly set, the relative paths of the files will not point to the correct locations.  It should be identical to the entry above, but (a) does not include '/flow.R' and (b) does NOT contains quotes.

    ```shell
    C:\Users\wbeasley\Documents\cdw\butcher-hearing-screen-1
    ```

Other options we typically specify are:

<ol start="4">
  <li>"Run whether the user is logged in or not."</li>
  <li>"Run as the highest available version of Windows."</li>
  <li>"Wake the computer to run this task" is probably necessary if this is located on a normal desktop.  It is not something we specify, because our tasks are located on a [VM](https://en.wikipedia.org/wiki/System_virtual_machine)-based workstation that is never turned off.</li>
</ol>

Following these instructions, you are required to enter your password every time you modify the task, and every time you update your password.  If you are using network credentials, you probably should specify your account like "domain/username".  Be careful: when you modify a task and are prompted for a password, the GUI may subtly alter the account entry to just "username" (instead of "domain\username").  Make sure you prepend the username with the domain, as you enter the password.

If you have 10+ tasks, consider creating a [System Environment Variable](https://www.computerhope.com/issues/ch000549.htm) called `%rscript_path%` whose value is something like `"C:\Program Files\R\R-4.1.1patched\bin\Rscript.exe"`.  The text `%rscript_path%` goes into step one ("Program/script" above).  When R is updated every few months, you need to change the path in only one place (*i.e.*, in the Environment Variables GUI) instead of in each task, which requires repeatedly re-entering your username and password.  If you defined the tasks differently than describe here, you may need to restart your machine to load the fresh variable value into the Task Scheduler environment.

If code executed by the task scheduler accesses a network drive or file share, the path cannot naturally reference the mapped letter.  The easiest solution is to spell out the full path.  For instance in the Python/R code, replace "<b>Q:/</b>subdirectory/hospital-location.csv" with "<b>//server-name/data-files/</b>subdirectory/hospital-location.csv".

### SQL Server Agent  {#automation-sql-server-agent}

[SQL Server Agent](https://docs.microsoft.com/en-us/sql/ssms/agent/sql-server-agent) executes jobs on a specified schedule.  It also naturally interfaces with [SSIS packages](#automation-ssis) deployed to the server, but can also execute other formats, like a plain sql file.

An important distinction is that it runs as a service *on the database server*, as opposed to Task Scheduler, which runs as a service on the client machine.  We prefer running jobs on the server when the job either:

1. requires elevated/administrative privileges (for instance, to access sensitive data),
1. would require a lot of network constraints when passing large amounts of data between the server and client, or
1. feels like it is the server's responsibility, such as rebuilding a database index, or archiving server logs.

Auxiliary Issues
------------------------------------

The following subsections do not execute or schedule any code, but should be considered.

### Sink Log Files

{Describe how to sink output to a file that can be examined easily.}

### Package Versions

When a project runs repeatedly on a schedule without human intervention, errors can easily go undetected in simple systems.  And when they are, the error messages may not be as clear as when you are running the procedure in RStudio.  For these and other reasons, plan your strategy for maintaining the version of R and its packages.  Here are some approaches, with different tradeoffs.

1. For most conventional projects, we keep all packages up to date, and live with the occasional breaks.  We stick to a practice of (a) run our daily workflow, (b) update the packages (and R & RStudio if necessary), (c) rereun that same week's workflow, and finally (d) verify that the results from a & c are the same.  If something is different, we have a day to adapt the pipeline code to the breaking changes in the packages.

Before updating a package, read the NEWS file for changes that are not  backwards-compatible (commonly called "breaking changes" in the [news file](https://style.tidyverse.org/news.html#breaking-changes)).

If the changes to the pipeline code are too difficult to complete in a day, we can roll back to a previous version with [`remotes::install_version()`](https://remotes.r-lib.org/reference/install_version.html).

1. On the other side of the spectrum, you can meticulously specify the desired version of each R package.  This approach reduces the chance of a new version of a package breaking existing pipeline code.   We recommend this approach when uptime is very important.

    The most intuitive implementation is to install with explicit code in a file like `utility/install-dependencies.R`:

    ```r
    remotes::install_version("dplyr"     , version = "0.4.3" )
    remotes::install_version("ggplot2"   , version = "2.0.0" )
    remotes::install_version("data.table", version = "1.10.4")
    remotes::install_version("lubridate" , version = "1.6.0" )
    remotes::install_version("openxlsx"  , version = "4.0.17")
    # ... package list continues ...
    ```

    Another implementation is to convert the repo to a package itself, and [specify the versions](http://r-pkgs.had.co.nz/description.html#dependencies) in the `DESCRIPTION` file.

    ```r
    Imports:
       dplyr       (== 0.4.3 )
       ggplot2     (== 2.0.0 )
       data.table  (== 1.10.4)
       lubridate   (== 1.6.0 )
       openxlsx    (== 4.0.17)
    ```

    A downside is that it can be difficult to set up a identical machine in a few months.  Sometimes these packages have depend on packages that are incompatible with other package versions.  For example, at one point, the current version of dplyr was 0.4.3.  A few months later, the rlang package (which wasn't explicitly specified in the list of 42 packages) required at least version 0.8.0 of dplyr.  The developer on the new machine needs to decide whether to upgrade dplyr (and test for breaking changes in the pipeline) or to install an older version of rlang.

    A second important downside is that this approach can lock all the user's projects to specific outdated package version.

    We and others^[[Chris Modzelewski](https://insightindustry.com/)] advocate this approach when your team is experienced with only R, and has a machine dedicated to an important line-of-business workflow.

    When uptime is important and your team is experienced with other languages like Java, Python, or C#, consider if those would be better suited.

1. A compromise between these two previous approaches in the [renv](https://rstudio.github.io/renv) package - R Environmentals.  It is a successor to [packrat](https://rstudio.github.io/packrat/).  It requires some learning and cognitive overhead.  But this investment becomes very appealing if (a) you were running hourly predictions and downtime is a big deal, or (b) your machine contains multiple projects that require different versions of the same package (such as dplyr 0.4.3 and dplyr 0.8.0).
