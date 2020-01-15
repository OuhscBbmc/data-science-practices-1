Automation & Reproducibility {#automation}
====================================

Automation is an important prerequisite of reproducibility.

Mediator {#automation-mediator}
------------------------------------

A nontirivial project usually has multiple stages in its pipeline.  Instead of a human deciding when to execute which piece, a single file should execute the pieces.  This single file is a special cases of the [mediator pattern](https://en.wikipedia.org/wiki/Mediator_pattern), in the sense that it defines how each piece relates to each other.

### Flow File in R {#automation-flow}

See also the [prototypical repo](#repo-flow).

### Makefile {#automation-makefile}

### SSIS {#automation-ssis}

Scheduling {#automation-scheduling}
------------------------------------

### cron  {#automation-cron}

[cron](https://en.wikipedia.org/wiki/Cron) is the common choice when scheduling tasks on Linux.  A plain text file specifies which file to run, and on what recurring schedule.  A lot of [helpful documentation and tutorials](https://www.computerhope.com/unix/ucrontab.htm) exists, as well as sites that help construct and validate your entries like [crontab guru](https://crontab.guru/).

### Task Scheduler {#automation-task-scheduler}

[Windows Task Scheduler](https://en.wikipedia.org/wiki/Windows_Task_Scheduler) is the common choice when scheduling tasks on Windows.

Many of the GUI options are easy to specify, but three are error-prone, and must be specified carefully.  The exist under “Actions” | “Start a program”.

* **Program/script:** is the absolute path to `Rscript.exe`.  It needs to be updated every time you upgrade R (unless you're doing something tricky with the `PATH` environmental OS variable.).  Notice we are using the "patched" version of R.  The entry should be enclosed in quotes.

    ```
    "C:\Program Files\R\R-3.6.2patched\bin\Rscript.exe"
    ```

* **Add arguments (optional):** specifies the flow file to run.  In this case, the repo 'butcher-hearing-screen-1' is under in the 'Documents/cdw/` directory; the [flow file](#automation-flow) is located in the repo's root directory, as discussed in the [prototypical repo](#repo-flow).  The entry should be enclosed in quotes.

    ```
    "C:\Users\wbeasley\Documents\cdw\butcher-hearing-screen-1\flow.R"
    ```
    
* **Start in (optional):** sets the working directory.  If not properly set, the relative paths of the files will not point to the correct locations.  This should be identical to the entry above, but (a) do not include '/flow.R' and (b) does not contains quotes.  We repeate, the entry should NOT be enclosed in quotes.

    ```
    C:\Users\wbeasley\Documents\cdw\butcher-hearing-screen-1
    ```

Other options we typically specify are:

1. "Run whether the user is logged in or not."
1. "Run as the highest available version of Windows."
1. "Wake the computer ot run this task" is probably necessary if this is located on a normal desktop.  It is not something we specify, because our tasks are located on a [VM](https://en.wikipedia.org/wiki/System_virtual_machine)-based workstation that is never turned off.

Following these instructions, you are required to enter your password every time you modify the task, and every time you update your password.  If you are using network credentials, you probably should specify your account like "domain/username".  Be careful: when you modify a task and are prompted for a password, the GUI subtly alters the account entry to just "username" (instead of "domain/username").  Make sure you prepend the username with the domain, as you enter the password.
  
### SQL Server Agent  {#automation-sql-server-agent}

[SQL Server Agent](https://docs.microsoft.com/en-us/sql/ssms/agent/sql-server-agent) executes jobs on a specified schedule.  It also naturally interfaces with [SSIS packages](#automation-ssis) deployed to the server, but can also execute other formats, like a plain sql file.

An important distinction is that it runs as a service *on the database server*, as opposed to Task Schedular, which runs as a service on the client machine.  We prefer running jobs on the server when the job either
1. requires elevated/administrative privileges,
1. would require a lot of network constraints when passing large amount of data between the server and client, or
1. "feels" like it is the server's responsibility, such as rebuilding a database index, or archiving server logs.

Auxiliary Issues
------------------------------------

The following subsections do not execute or scheule any code, but should be considered.

### Sink Log Files


### Package Versions

When a project runs repeatedly on a schedule without human intervention, errors can easily go undetected, and when they are, the error messages may not be as clear as when you are running the procedure in RStudio.  For these and other reasons, plan your strategy for maintaining the version of R and its packages.  Here are some approaches, with different tradeoffs.

1. Meticulously specifies the desired version of each R package.  Packages sometimes release backwards-incompatibilities (commonly called "breaking changes" in the [news file](https://style.tidyverse.org/news.html#breaking-changes)).  This approach reduces the chance of a new version of a package breaking existing pipeline code.  We recommend this approach when uptime is important.

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
    
    ```
    Imports:
       dplyr       (== 0.4.3 )
       ggplot2     (== 2.0.0 )
       data.table  (== 1.10.4)
       lubridate   (== 1.6.0 )
       openxlsx    (== 4.0.17)
    ```

    A downside is that it can be difficult to set up a identical machine in a few months.  Sometimes these packages have depend on packages that are incompatible with other package versions.  For example, at one point, the current version of dplyr was 0.4.3.  A few months later, the rlang package (which wasn't explicitly specified in the list of 42 packages) required at least version 0.8.0 of dplyr.  The developer on the new machine needs to decide wether to upgrade dplyr (and test for breaking changes in the pipeline) or to install an older version of rlang.

    A second important downside is that this approach can lock all the user's projects to specific outdate package version.

    We and others^[[Chris Modzelewski](https://insightindustry.com/)] advocate this approach when your team is experienced with only R, and has a machine dedicated to an important line-of-business workflow.

1. For most conventional projects, we keep all packages up to date, and live with the occasional breaks.  Stick to a practice of (a) run our weekly workflow, (b) update the packages (and R & RStudio if necessary), (c) rereun that same week's workflow, and finally (d) verify that the results from a & c are the same.  If something is different, we have a week to adapt the  pipeline code to the breaking changes in the packages.

1. A compromise between these two approaches in the 'renv' - R Environmentals package (https://rstudio.github.io/renv).  It is a successor to [packrat](https://rstudio.github.io/packrat/).  It requires some learning and cognitive overhead.  But if you were running hourly predictions and downtime is a big deal, this investment becomes a lot more appealing.
