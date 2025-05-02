Workstation {#workstation}
====================================

We believe it is important to keep software updated and consistent across workstations in your project.  This material was originally posted at https://github.com/OuhscBbmc/RedcapExamplesAndPatterns/blob/main/DocumentationGlobal/ResourcesInstallation.md.  It should help establish our tools on a new development computer.ff

Required Installation {#workstation-required}
------------------------------------

The installation order matters.

### R {#workstation-r}

[R](http://cran.r-project.org/) is the centerpiece of the analysis. Every few months, you'll need to download the most recent version.  {added Sept 2012}

### RStudio {#workstation-rstudio}

[RStudio Desktop](https://posit.co/download/rstudio-desktop/) is the IDE (integrated design interface) that you'll use to interact with R, GitHub, and Markdown. Updates can be checked easily through the menus `Help` -> `Check for Updates`.  {added Sept 2012}

Note: here are some non-default changes that facilitate our workflow.  Choose "Global Options" from the "Tools menu bar.

1. General | Basic | **Restore .RData into wokspace at startup: unchecked**
1. General | Basic | **Save workspace to >RData on exit: never**
1. General | Basic | **Always save history: unchecked**
1. Code | Editing | **Use native pipe operator, |>: checked**
1. Code | Editing | **Auto-indent code after paste: UNchecked**
1. Code | Saving | **Ensure that source files end with newline: checked**
1. Code | Saving | **Strip trailing horizontal whitespace when saving: checked**
1. Sweave | **Weave Rnw file using: knitr**
 
### R Tools {#workstation-rtools}

[R Tools for Windows](https://cran.r-project.org/bin/windows/Rtools/) is necessary to build some packages in development hosted on GitHub.  If running Windows, follow the page's instructions, especially the "Putting Rtools on the PATH" section.  If running Linux, the components of R Tools are likely already installed on your machine. {added Feb 2017}

### Installing R Packages {#workstation-r-package-installation}

Dozens of R Packages will need to be installed.  Choose between one of the two related scripts.  It will install [from our list of packages that our data analysts typically need](https://github.com/OuhscBbmc/RedcapExamplesAndPatterns/blob/main/utility/package-dependency-list.csv).  The script installs a package only if it's not already installed; also an existing package is updated if a newer version is available.  Create a new 'personal library' if it prompts you.  It takes at least fifteen minutes, so start it before you go to lunch.  The list of packages will evolve over time, so please help keep the list updated.

To install our frequently-used packages, run the following snippet.  The first lines installs an important package.  The second line calls the online [Gist](https://gist.github.com/wibeasley/2c5e7459b88ec28b9e8fa0c695b15ee3)^[As an alternative to the Gist, run the local R script [`install-packages.R`](https://github.com/OuhscBbmc/RedcapExamplesAndPatterns/blob/main/utility/install-packages.R) (located in that repository's `utility/` directory). The workhorse of this function is [`OuhscMunge::package_janitor()`](https://github.com/OuhscBbmc/OuhscMunge/blob/main/R/package-janitor.R).], which defines the `package_janitor_remote()` function.  This function then installs the packages listed in the two CSVs, [package-dependency-list.csv](https://github.com/OuhscBbmc/RedcapExamplesAndPatterns/blob/main/utility/package-dependency-list.csv) and [package-dependency-list-more.csv](https://github.com/OuhscBbmc/RedcapExamplesAndPatterns/blob/main/utility/package-dependency-list-more.csv).

```r
if (!base::requireNamespace("devtools")) utils::install.packages("devtools")
devtools::source_gist("2c5e7459b88ec28b9e8fa0c695b15ee3", filename="package-janitor-bbmc.R")

# Important packages required by most BBMC projects
package_janitor_remote(
  "https://raw.githubusercontent.com/OuhscBbmc/RedcapExamplesAndPatterns/main/utility/package-dependency-list.csv"
)

# Nonessential packages used in a few BBMC projects
package_janitor_remote(
  "https://raw.githubusercontent.com/OuhscBbmc/RedcapExamplesAndPatterns/main/utility/package-dependency-list-more.csv"
)
```

Some of our projects require specialized packages that are not typically used.  In these cases, we will develop the git repo as an R package that includes a proper [DESCRIPTION](http://r-pkgs.had.co.nz/description.html) file.  See [RAnalysisSkeleton](https://github.com/wibeasley/RAnalysisSkeleton/blob/main/DESCRIPTION) for an example.

When the project is opened in RStudio, [`update_packages_addin()`](http://ouhscbbmc.github.io/OuhscMunge/reference/update_packages_addin.html) in [OuhscMunge](https://ouhscbbmc.github.io/OuhscMunge) will find the DESCRIPTION file and install the package dependencies.

```r
if( !base::requireNamespace("remotes"   ) ) utils::install.packages("remotes")
if( !base::requireNamespace("OuhscMunge") ) remotes::install_github("OuhscBbmc/OuhscMunge")
OuhscMunge::update_packages_addin()
```

### Updating R Packages {#workstation-r-package-update}

Several R packages will need to be updated every weeks.  Unless you have been told not to (because it would break something -this is rare), periodically update the packages by executing the following code `update.packages(checkBuilt = TRUE, ask = FALSE)`.

### GitHub {#workstation-github}

[GitHub](https://github.com/) registration is necessary to push modified files to the repository.    First, register a free user account, then tell the repository owner your exact username, and they will add you as a collaborator  (*e.g.*, to https://github.com/OuhscBbmc/RedcapExamplesAndPatterns).  {added Sept 2012}

### GitHub Desktop {#workstation-github-client}

[GitHub Desktop](http://desktop.github.com/) does the basic tasks a little easier than the git features built into RStudio.  This client is available for Windows and macOS. (Occasionally, someone might need to use git from the command line to fix problems, but this is not required to start.)  {added Sept 2012}

Recommended Installation {#workstation-recommended}
------------------------------------

The installation order does not matter.

### ODBC Driver {#workstation-odbc}

[ODBC Driver for SQL Server](https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server) is for connecting to the [token server](https://github.com/OuhscBbmc/REDCapR/blob/main/vignettes/SecurityDatabase.Rmd), if your institution is using one.  As of this writing, version 18 is the most recent driver version.  See if a new one exists. {updated Feb 2022}

### Quarto {#workstation-quarto}

[Quarto](https://quarto.org/docs/get-started/) is Posit's/RStudio's successor to knitr.  It uses an embedded version of [Pandoc](https://pandoc.org/) to translate R/Python/Julia code into html or pdf reports (via [Markdown](https://www.markdownguide.org/)).  Reporting and reproducible research has been a foundation of our workflow and Quarto will be will be used the upcoming generation of reports.  If an existing Rmd file is delivering what you need (for something like an article or federal report), continue using knitr and R Markdown.  If you are developing a new report from scratch, strongly consider Quarto. {added Nov 2022}

Quarto's [Get Started](https://quarto.org/docs/get-started/) page has instructions.  You'll want it installed for the RStudio IDE, and probably VS Code too.  See the [troubleshooting tips](#workstation-troubleshooting) if necessary.
    
### Notepad++ {#workstation-notepadpp}

[Notepad++](http://notepad-plus-plus.org/) is a text editor that allows you look at the raw text files, such as code and CSVs.  For CSVs and other data files, it is helpful when troubleshooting (instead of looking at the file through Excel, which masks & causes some issues).  {added Sept 2012}

### Azure Data Studio {#workstation-ads}

[Azure Data Studio (ADS)](https://docs.microsoft.com/en-us/sql/azure-data-studio/download) is now recommended by [Microsoft](https://cloudblogs.microsoft.com/sqlserver/2018/09/25/azure-data-studio-for-sql-server/) and [others](https://www.brentozar.com/archive/2019/04/if-you-work-with-sql-server-youre-really-lucky/) for analysts (and some other roles) --ahead of SQL Server Management Studio.

  Note: here are some non-default changes that facilitate our workflow.

  1. Settings | Text Editor | **Tab Size: 2** {`"editor.tabSize": 2`}
  1. Settings | Text Editor | **Detect Indentation: uncheck** {`"editor.detectIndentation": false`}
  1. Settings | Text Editor | **Insert Final Newlines: check** {`"files.insertFinalNewline": true`}
  1. Settings | Text Editor | **Trim Final Newlines: check** {`"files.trimFinalNewlines": true`}
  1. Settings | Text Editor | **Trim Trailing Whitespace: check** {`"files.trimTrailingWhitespace": true`}
  1. Data | Sql | **Show Connection Info In Title: uncheck** {`"sql.showConnectionInfoInTitle": false`}
  1. Data | Sql | **Include Headers: check** {`"sql.copyIncludeHeaders": false`}

```json
{
  "workbench.enablePreviewFeatures": true,
  "workbench.colorTheme": "Default Dark Azure Data Studio",
  "editor.tabSize": 2,
  "editor.detectIndentation": false,
  "files.insertFinalNewline": true,
  "files.trimFinalNewlines": true,
  "files.trimTrailingWhitespace": true,
  "queryEditor.showConnectionInfoInTitle": false,
  "queryEditor.results.copyIncludeHeaders": false
}
```

### Visual Studio Code {#workstation-vscode}

[Visual Studio Code](https://code.visualstudio.com/) is an extensible text editor that runs on Windows and Linux.  It's much [lighter](https://stackoverflow.com/questions/30527522/what-are-the-differences-between-visual-studio-code-and-visual-studio) than the full [Visual Studio](https://visualstudio.microsoft.com/).  Like [Atom](#workstation-retired), it supports browsing through the directory structure, replacing across files, interaction with git, and previewing markdown. VS Code has good documentation for [Basic Editing](https://code.visualstudio.com/docs/editor/codebasics).

Productivity in VS Code is enhanced with the following extensions:  {added Dec 2018}

* [Excel Viewer](https://marketplace.visualstudio.com/items?itemName=GrapeCity.gc-excelviewer) isn't a good name, but I've liked the capability.  It displays CSVs and other files in a grid. {added Dec 2018}

* [Rainbow CSV](https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv) color codes the columns, but still allows you to see and edit the raw plain-text file. {added Dec 2018}

* [SQL Server](https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql) allows you to execute against a database, and view/copy/save the grid results.  It doesn't replicate all SSMS features, but is nice as your scanning through files. {added Dec 2018}

* [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) produces  green squiggly lines under words not in its dictionary.  You can add words to your user dictionary, or a project dictionary.

* [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one) has some useful markdown capabilities, such as converting the file to html.

* [Markdown PDF](https://marketplace.visualstudio.com/items?itemName=yzane.markdown-pdf) has some useful markdown capabilities, such as converting the file to pdf.

* [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint) has linting and style checking.

* [Select Compare Tabs](https://marketplace.visualstudio.com/items?itemName=outofsync42.select-compare-tabs) quickly produces diffs between tabs.

These extensions [can be installed by command line](https://code.visualstudio.com/docs/editor/command-line#_working-with-extensions).

```sh
code --list-extensions
code --install-extension GrapeCity.gc-excelviewer
code --install-extension mechatroner.rainbow-csv
code --install-extension ms-mssql.mssql
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension yzhang.markdown-all-in-one
code --install-extension yzane.markdown-pdf
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension outofsync42.select-compare-tabs
```

Note: here are some non-default changes that facilitate our workflow.  Either copy this configuration into [`settings.json`](https://code.visualstudio.com/docs/getstarted/tips-and-tricks#_tune-your-settings), or manually specify the options with the [settings editor](https://code.visualstudio.com/docs/getstarted/settings).

```json
{
  "diffEditor.ignoreTrimWhitespace": false,
  "diffEditor.maxComputationTime": 0,
  "editor.acceptSuggestionOnEnter": "off",
  "editor.renderWhitespace": "all",
  "explorer.confirmDragAndDrop": false,
  "files.associations": {
      "*.Rmd": "markdown"
  },
  "files.trimFinalNewlines": true,
  "files.trimTrailingWhitespace": true,
  "git.autofetch": true,
  "git.confirmSync": false,
  "window.zoomLevel": 2,

  "markdown.extension.orderedList.autoRenumber": false,
  "markdown.extension.orderedList.marker": "one",
  "markdownlint.config": {
      "MD003": { "style": "setext_with_atx" },
      "MD007": { "indent": 2 },
      "MD022": { "lines_above": 1,
                  "lines_below": 1 },
      "MD024": { "siblings_only": true },
      "no-bare-urls": false,
      "no-inline-html": {
        "allowed_elements": [
          "mermaid",
          "a",
          "br",
          "details",
          "img"
        ]
      }
  }
}
```

1. Settings | Extensions |Markdown All in One | Ordered List | **Auto Renumber: false** {`"markdown.extension.orderedList.autoRenumber": false`}
1. Settings | Extensions |Markdown All in One | Ordered List | **Marker: one** {`"markdown.extension.orderedList.marker": "one"`}

Optional Installation {#workstation-optional}
-----------------------------------

The installation order does not matter.

### Git {#workstation-git}

[Git](https://git-scm.com/downloads) command-line utility enables some advanced operations that the GitHub client doesn't support.  Use the default installation options, except these preferences of ours:
    1. Nano is the default text editor.

### LibreOffice Calc {#workstation-calc}

[LibreOffice Calc](https://www.libreoffice.org/discover/calc/) is an alternative to Excel.  Unlike it Excel, it doesn't guess much with formatting (which usually mess up things, especially dates).

### pandoc {#workstation-pandoc}

[pandoc](https://pandoc.org/) converts files from one markup format into another. {added Sept 2012}

### Tad {#workstation-tad}

[Tad](https://www.tadviewer.com/) A simple viewer for DuckDB, csv, and other rectangular data files. {added Feb 2024}

### Python {#workstation-python}

[Python](https://www.python.org/) is used by some analysts.  The prototypical installation involves two options.

* **[Anaconda](https://www.anaconda.com/distribution/#download-section)**, which include Jupyter Notebooks, Jupyter Lab, and Spyder. Plus two programs that are already on this list: RStudio and VS Code.  In Windows, open "Anaconda Prompt" with administrative privileges

  ```python
  conda install numpy pandas scikit-learn matplotlib
  ```

* **[Standard Python](https://www.python.org/downloads/)**, while installing packages through pip3 in the terminal.  If the `pip3` command is unrecognized because it's missing from the OS [path](https://en.wikipedia.org/wiki/PATH_(variable)) variable, an alternative is `py -3 -mpip install paramiko`; this calls pip through the `py` command which is sometimes in the path variable after installation.

  When using the Windows .msi installer, the recommended options are
  
  * Check "Add Python 3.10 to PATH"

  * Check "Install launcher for all users (recommended)"
  
  * Click "Customize Installation"
  
  * Optional Features

    * Check "Documentation"
    * Check "pip"
    * "for all users (requires elevation)"

  * Advanced Options

    * Check "Install for all users" (This will set the install path to something like `C:\Program Files\Python310`.)
    * Check "Add Python to environment variables"
    * Check "Precompile standard library"

  * After the msi completes:
  
    * Add an entry like `C:\Users\USERNAME\AppData\Roaming\Python\Python310` or `C:\Users\USERNAME\AppData\Local\Programs\Python\Python310` to the [System Variables](https://www.computerhope.com/issues/ch000549.htm) for the scripts in your personal `AppData` directory (even if you clicked "Install for all users").  This helps RStudio/[reticulate](https://CRAN.R-project.org/package=reticulate) run python scripts.

    * Install Python packages from PowerShell or the command line (not from Python)
    
      ```ps
      py -3 -mpip install biopython matplotlib numpy pandas paramiko pyarrow pyodbc pyyaml scikit-learn scipy sqlalchemy strictyaml
      ```

* **Updating Packages** Python packages don't need to be updated as frequently as R packages, but it's still good to do it every few months.  

    Paste this single line into PowerShell on Windows.  ([Stack Overflow solution](https://stackoverflow.com/a/51022937/1082435) from [Sébastien Wieckowski](https://stackoverflow.com/users/8275142/s%c3%a9bastien-wieckowski))

    ```ps
    pip list -o --format json | ConvertFrom-Json | foreach {pip install $_.name -U --no-warn-script-location}
    ```
    
    Paste this single line into a Bash terminal on Linux.  ([ActiveState.com post]([https://stackoverflow.com/a/51022937/1082435](https://www.activestate.com/resources/quick-reads/how-to-update-all-python-packages/)).

    ```sh
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U 
    ```

### PilotEdit {#workstation-pilot-edit}

[PilotEdit](https://www.pilotedit.com/) can load huge text files that cannot fit into RAM, such as files that are over 100MB that choke Excel, [Calc](#workstation-calc),  [Notepad++](#workstation-notepadpp), and [Visual Studio Code](#workstation-vscode).

Like Notepad++ and VS Code, PilotEdit has good Find features that can (a) present all search hits within a file, (b) scan multiple files, and (c) use regular expressions.  This helps trace the origin of problems in a pipeline.  For example, if our data warehouse has a suspicious character in patient 10009's BMI value, the [regex](https://www.regular-expressions.info/) `\b10009\tbmi\b` locates the origin among the multiple 1+GB files we received.

PilotEdit is also a good tool for the occasional data extract with an encoding problem.  You can side-by-side inspect the hex code and (visible or non-visible) character produced ([for example with ascii](https://www.binaryhexconverter.com/ascii-text-to-hex-converter), "76" produces "v" and "0A" produces a line feed).  {Added Sept 2020}

### Node.js {#workstation-node}

[Node.js](https://nodejs.org/en/download) is a JavaScript runtme environment.
You probably won't use Node directly, but some of these tools will,
such VS Code extensions like Sqltools.
On Windows, let the msi executable automatically install node's recommended dependencies like 
[chocolatey](https://community.chocolatey.org/packages/nodejs).
{Added Dec 2023}

### Omnissa Horizon Client {#workstation-horizon}

The [Omnissa Horizon Client](https://customerconnect.omnissa.com/downloads) (formerly VMWare Horizon Client) permits remote access to the OU and OUH VDIs.

{Added Feb 2025}

Asset Locations {#workstation-assets}
-----------------------------------

* **GitHub repository** https://github.com/OuhscBbmc/RedcapExamplesAndPatterns {added Sept 2012}

* **File server directory** Ask your PI.  For Peds, it's typically on the "S" drive.

* **SQL Server Database** Ask Thomas, Will or David

* **REDCap database** Ask Thomas, Will or David.  It is a http url, and we're trying not to publicize its value.

* **ODBC UserDsn** The name depends on your specific repository, and SQL Server database.  Ask Thomas, Will or David for how to set it up.

Administrator Installation {#workstation-administrator}
-----------------------------------

These programs are useful to people administrating servers, but not to the typical data scientist.

### MySQL Workbench {#workstation-mysql}

[MySQL Workbench](https://dev.mysql.com/downloads/workbench/) is useful occasionally for REDCap admins.

### Postman {#workstation-postman}

[Postman Native App](https://www.getpostman.com/downloads/) is useful for developing with the API and has [replaced the Chrome app](https://blog.getpostman.com/2017/03/14/going-native/).  If that's not possible, a [web client](https://web.postman.co/) is available as well.  With either program, do not access any PHI.

### SQL Server Management Studio (SSMS) {#workstation-ssms}

[SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) has been replaced by Azure Data Studio for some roles, but is still recommended for database administrators.  It is an easy way to access the database and write queries (and transfer the SQL to an R file).   It's not required for the REDCap API, but it's usually necessary when integrating REDCap with other databases.

Note: here are some non-default changes that facilitate our workflow.  The first two help when we save the database *structure* (not data) on GitHub, so we can easily track/monitor the structural changes over time.    The *tabs* options keeps things consistent between editors.  In the SSMS 'Tools | Options' dialog box:

1. SQL Server Object Explorer | Scripting | Include descriptive headers: False
1. SQL Server Object Explorer | Scripting | Script extended properties: False
1. Text Editor | All Languages | Tabs | Tab size: 2
1. Text Editor | All Languages | Tabs | Indent size: 2
1. Text Editor | All Languages | Tabs | Insert Spaces: true

These don't affect the saved files, but make life easier.  The first makes the [result font bigger](https://blog.sqlauthority.com/2016/05/31/sql-server-ssms-tip-get-larger-fonts-results-grid-output/).

1. Environment | Fonts and Colors | Show settings for: Grid Results | Size: 10
1. Query Results | SQL Server | Results to Grid | Include column headers when copying or saving the results: false
1. Designers | Table and Database Designers | Prevent saving changes that require table-recreation: false
1. SQL Server Tools | Transact-SQL Editor | Editor Tab and Status Bar<sup>1</sup> | Tab Text | Include Server Name: false
1. SQL Server Tools | Transact-SQL Editor | Editor Tab and Status Bar<sup>1</sup> | Tab Text | Include Database Name: false
1. SQL Server Tools | Transact-SQL Editor | Editor Tab and Status Bar<sup>1</sup> | Tab Text | Include Login Name: false
1. Text Editor | All Languages | General | Line Numbers: true

Note 1: Prior to SSMS V20, "Editor Tab and Status Bar" was nested in "Text Editor".

A dark theme is unofficially supported in SSMS 18.  If you have write privileges in the "Program Files" directory, [a quick modification](https://blog.sqlauthority.com/2019/09/12/sql-server-management-studio-18-enable-dark-theme/) to a config file will reduce eye strain.  This change also prevents your screen from flashing dark-to-light-to-dark, which broadcasts your wandering attention during a Zoom meeting.

For more details, see [setting-up-dev-machine.md](https://github.com/OuhscBbmc/bbmc-database-management/blob/main/maintenance/setting-up-server/setting-up-dev-machine.md) (in a private repo that's restricted to BBMC members).

### WinSCP {#workstation-winscp}

[WinSCP](https://winscp.net/eng/download.php) is a GUI for SCP and SFTP file transfer using SSH keys.  The tool is occasionally useful for admins when collaborating with other institutions or [other OU computing resources](https://www.ou.edu/oscer).  Because PHI can accidentally be sent to collaborators without a DUA, we recommend that WinSCP be installed only informed administrators.  The typical data scientist on our teams does not need this tool.

An alternative is FileZilla.  It works with multiple OSes, but currently doesn't support scp (only sftp).

Installation Troubleshooting {#workstation-troubleshooting}
-----------------------------------

* **Git**: Will Beasley resorted to this workaround Sept 2012: http://stackoverflow.com/questions/3431361/git-for-windows-the-program-cant-start-because-libiconv2-dll-is-missing.  And then he copied the following four files from `D:/Program Files/msysgit/mingw/bin/` to `D:/Program Files/msysgit/bin/`: (1) `libiconv2.dll`, (2) `libcurl-4.dll`, (3) `libcrypto.dll`, and (4) `libssl.dll`. (If you install to the default location, you'll  move instead from `C:/msysgit/mingw/bin/` to `C:/msysgit/bin/`) {added Sept 2012}

* **Git**: On a different computer, Will Beasley couldn't get RStudio to recognize msysGit, so installed the `Full installer for official Git for Windows 1.7.11` from (http://code.google.com/p/msysgit/downloads/list) and switched the Git Path in the RStudio Options. {added Sept 2012}

* **RStudio**
    * If something goes wrong with RStudio, re-installing might not fix the issue, because your personal preferences aren't erased.  To be safe, you can be thorough and delete the equivalent of `C:\Users\wibeasley\AppData\Local\RStudio\`.  The options settings are stored (and can be manipulated) in this extensionless text file: `C:\Users\wibeasley\AppData\Local\RStudio\monitored\user-settings\user-settings`. See RStudio's support page, [Resetting RStudio Desktop's State](https://support.rstudio.com/hc/en-us/articles/200534577-Resetting-RStudio-s-State). {added Sept 2012}
    * Hold down the ctrl button when clicking on RStudio in the Windows Start Menu.  Try switching up the 64/32-bit option.  For a VDI, forcing it to a software-rendering option fixed a problem where the RStudio window opened, but nothing was visible inside.  {added Jan 2022}
    * It might help to look in the logs, which are stored in the equivalent of `C:\Users\wibeasley\AppData\Local\RStudio\logs`  {added Jan 2022}

* **Quarto**

    * If (while rendering a document) you encounter this error like `compilation failed- no matching packages ...LaTeX Error: File 'scrreprt.cls' not found.`, you'll need to [replace your installation of tinytex](https://github.com/quarto-dev/quarto-cli/issues/679).

      First uinstall & remove it via R.

      ```r
      tinytex::uninstall_tinytex()
      remove.packages("tinytex")
      ```

      Then reinstall it via the command line or PowerShell.

      ```ps
      quarto tools install tinytex
      ```
    
Windows Installation {#workstation-windows}
-----------------------------------

### File Explorer {#workstation-windows-explorer}

When reviewing repo files, it's frequently important to see file extensions and hidden files in [File Explorer](https://en.wikipedia.org/wiki/File_Explorer).

* View Menu: check the box for "File name extensions"
* View Menu: check the box for "Hidden items"


Ubuntu Installation {#workstation-ubuntu}
-----------------------------------

### R {#workstation-ubuntu-r}

Check <https://cran.r-project.org/bin/linux/ubuntu/> for the most recent instructions.

```sh
  ### Add the key, update the list, then install base R.
  sudo apt update -qq
  sudo apt install --no-install-recommends software-properties-common dirmngr
  wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
  sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
  sudo apt-get install r-base r-base-dev
```

### RStudio {#workstation-ubuntu-rstudio}

Download the most recent version from  <https://www.rstudio.com/products/rstudio/download/#download>. Then run the two `gdebi()` lines.
Alternatively, update the `wget` line with the most recent version.

```sh
  # wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.4.1717-amd64.deb
  sudo apt-get install gdebi-core
  sudo gdebi rstudio-*-amd64.deb
```

### apt-get Packages {#workstation-ubuntu-packages}

This next block can be copied and pasted (ctrl-shift-v) into the console [entirely](https://stackoverflow.com/a/43164204).  Or lines can be pasted individual (without the `( function install-packages {` line, or the last three lines).

```sh
( function install-packages {

  ### Git
  sudo apt-get install git
  git config --global user.email "wibeasley@hotmail.com"
  git config --global user.name "Will Beasley"
  git config --global credential.helper 'cache --timeout=3600000'

  ### Ubuntu & Bioconductor packages that are indirectly needed for packages and BBMC scripts

  # Supports the `locate` command in bash
  sudo apt-get install plocate

  # The genefilter package is needed for 'modeest' on CRAN.
  # No longer a modeest dependency: Rscript -e 'BiocManager::install("genefilter")'

  ### CRAN packages that are also on the Ubuntu repositories

  # For the 'devtools' package dependencies
  sudo apt-get --yes install libharfbuzz-dev libfribidi-dev

  # For the 'devtools' package dependencies
  sudo apt-get --yes install libharfbuzz-dev libfribidi-dev

  # The 'git2r' package; https://CRAN.R-project.org/package=git2r
  sudo apt-get --yes install libgit2-dev

  # The 'curl' package, and others; https://CRAN.R-project.org/package=curl
  sudo apt-get --yes install libssl-dev libcurl4-openssl-dev

  # The 'udunits2' package: https://cran.r-project.org/web/packages/udunits2/index.html
  sudo apt-get --yes install libudunits2-dev

  # The 'odbc' package: https://github.com/r-dbi/odbc#linux---debian--ubuntu
  sudo apt-get --yes install unixodbc-dev tdsodbc odbc-postgresql libsqliteodbc

  # The 'rgl' package; https://stackoverflow.com/a/39952771/1082435
  sudo apt-get --yes install libcgal-dev libglu1-mesa-dev

  # The 'gsl' package; https://cran.rstudio.com/web/packages/gsl/INSTALL
  sudo apt-get --yes install libgsl0-dev

  # The 'magick' package; https://docs.ropensci.org/magick/articles/intro.html#build-from-source
  sudo apt-get --yes install 'libmagick++-dev'

  # To compress vignettes when building a package; https://kalimu.github.io/post/checklist-for-r-package-submission-to-cran/
  sudo apt-get --yes install qpdf

  # The 'pdftools' and 'Rpoppler' packages, which involve PDFs
  sudo apt-get --yes install libpoppler-cpp-dev libpoppler-glib-dev

  # The 'sys' package
  sudo apt-get --yes install libapparmor-dev

  # The 'archive' package; https://CRAN.R-project.org/package=archive
  sudo apt-get --yes install libarchive-dev

  # The 'nloptr' package; https://CRAN.R-project.org/package=nloptr
  sudo apt-get install cmake

  # The 'sf' and other spatial packages: https://github.com/r-spatial/sf#ubuntu; https://github.com/r-spatial/sf/pull/1208
  sudo apt-get --yes install libudunits2-dev libgdal-dev libgeos-dev libproj-dev libgeos++-dev

  # For Cairo package, a dependency of Shiny & plotly; https://gykovacsblog.wordpress.com/2017/05/15/installing-cairo-for-r-on-ubuntu-17-04/
  sudo apt-get --yes install libcairo2-dev

  # 'rJava' and others; https://www.r-bloggers.com/installing-rjava-on-ubuntu/
  sudo apt-get --yes install default-jre default-jdk
  sudo R CMD javareconf
  sudo apt-get --yes install r-cran-rjava

  # For reprex and sometimes ssh keys; https://github.com/tidyverse/reprex#installation
  sudo apt-get --yes install xclip

  # gifski -apparently the rust compiler is necessary
  sudo apt-get --yes install cargo

  # For databases
  sudo apt-get --yes install sqlite sqliteman
  sudo apt-get --yes install postgresql postgresql-contrib pgadmin3

  # pandoc
  sudo apt-get --yes install pandoc

  # For checking packages. Avoid `/usr/bin/texi2dvi: not found` warning.
  sudo apt-get install texinfo
}
install-packages
)
```

### Pandoc {#workstation-ubuntu-pandoc}

The version of pandoc from the Ubuntu repository may be delayed.  To install the latest version, [download the .deb file](https://github.com/jgm/pandoc/releases) then install from the same directory.  Finally, verify the version.

```sh
sudo dpkg -i pandoc-*
pandoc -v
```

### Postman {#workstation-ubuntu-postman}

The Postman native app for Ubuntu is [installed](https://learning.postman.com/docs/getting-started/installation-and-updates/#installing-postman-on-linux) through [snap](https://tutorials.ubuntu.com/tutorial/basic-snap-usage), which is [updated daily automatically](https://tutorials.ubuntu.com/tutorial/basic-snap-usage#2).

```sh
snap install postman
```

Retired Tools {#workstation-retired}
-----------------------------------

We previously installed the software below.  Most have been replaced by software above that's either newer or more natural to use.

* **GitLab SSL Certificate** isn't software, but still needs to be configured.
    1. Talk to Will for the server URL and the `*.cer` file.
    1. Save the file in something like `~/keys/ca-bundle-gitlab.cer`
    1. Associate the file with `git config --global http.sslCAInfo ...path.../ca-bundle-gitlab.cer` (but replace `...path...`).

* **[MiKTeX](http://miktex.org/)** is necessary only if you're using knitr or Sweave to produce *LaTeX* files (and not just *markdown* files).  It's a huge, slow installation that can take an hour or two.  {added Sept 2012}

* **[Pulse Secure](https://connect.ouhsc.edu)** is VPN client for OUHSC researchers.  It's not required for the REDCap API, but it's usually necessary to communicate with other campus data sources.

* **[msysGit](http://msysgit.github.com/)** allows RStudio to track changes and commit & sync them to the GitHub server. Connect RStudio to GitHub repository.  I moved this to optional (Oct 14, 2012) because the GitHub client (see above) does almost everything that the RStudio plugin does; and it does it a little better and a little more robust; and its installation hasn't given me problems.  {added Oct 2012}
  * Starting in the top right of RStudio, click: Project -> New Project -> Create Project from Version Control -> Git  {added Sept 2012}
  * An example of a repository URL is https://github.com/OuhscBbmc/RedcapExamplesAndPatterns. Specify a location to save (a copy of) the project on your local computer.  {added Sept 2012}

* **[CSVed](http://csved.sjfrancke.nl/)** is a lightweight program for viewing data files.  It fits somewhere between a text editor and Excel.

* **[SourceTree](http://www.sourcetreeapp.com/)** is a rich client that has many more features than the GitHub client.  I don't recommend it for beginners, since it has more ways to mess up things.  But for developers, it nicely fills a spot in between the GitHub client and command-line operations.  The branching visualization is really nice too. Unfortunately and ironically, it doesn't currently support Linux. {added Sept 2014}.

* **[git-cola](http://git-cola.github.io/)** is probably the best GUI for Git supported on Linux.  It's available through the official [Ubuntu repositories](http://packages.ubuntu.com/search?keywords=git-cola) with `apt-get` (also see [this](https://apps.ubuntu.com/cat/applications/git-cola/)).  The branch visualization features are in a different, but related program, 'git dag'.  {added Sept 2014}

* **[GitHub for Eclipse](http://eclipse.github.com/)** is something I discourage for a beginner, and I strongly recommend you start with RStudio (and [GitHub Client](http://windows.github.com/) or the git capabilities within RStudio) for a few months before you even consider Eclipse.  It's included in this list for the sake of completeness. When installing EGit plug-in, ignore eclipse site and check out this youtube video:http://www.youtube.com/watch?v=I7fbCE5nWPU.

* **[Color Oracle](http://colororacle.org/)** simulates the three most common types of color blindness.  If you have produce a color graph in a report you develop, check it with Color Oracle (or ask someone else too).  If it's already installed, it takes less than 10 second to check it against all three types of color blindness. If it's not installed, extra work may be necessary if Java isn't already installed.  When you download the zip, extract the `ColorOracle.exe` program where you like. {added Sept 2012}
* **[Atom](https://atom.io/)** is a text editor, similar to Notepad++.  Notepad++ appears more efficient opening large CSVs.  Atom is better suited when editing a lot of files in a repository.  For finding and replacing across a lot of files, it is superior to Notepad++ and RStudio; it permits regexes and has a great GUI preview of the potential replacements.

    Productivity is enhanced with the following [Atom packages](https://atom.io/packages):

    1. [Sublime Style Column Selection](https://atom.io/packages/Sublime-Style-Column-Selection): Enable Sublime style 'Column Selection'. Just hold 'alt' while you select, or select using your middle mouse button.
    1. [atom-language-r](https://atom.io/packages/atom-language-r) allows Atom to recognize files as R.  This prevents spell checking indicators and enable syntax highlighting.  When you need to browse through a lot of scattered R files quickly, Atom's tree panel (on the left) works well.  An older alternative is [language-r](https://atom.io/packages/language-r).
    1. [language-csv](https://atom.io/packages/language-csv): Adds syntax highlighting to [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) files.  The highlighting is nice, and it automatically disables spell checking lines.
    1. [atom-beautify](https://atom.io/packages/atom-beautify): Beautify HTML, CSS, JavaScript, PHP, Python, Ruby, Java, C, C++, C#, Objective-C, CoffeeScript, TypeScript, Coldfusion, SQL, and more in Atom.
    1. [atom-wrap-in-tag](https://atom.io/packages/atom-wrap-in-tag): wraps tag around selection; just select a word or phrase and hit Alt + Shift + w.
    1. [minimap](https://atom.io/packages/minimap): A preview of the full source code (in the right margin).
    1. [script](https://atom.io/packages/script): Run scripts based on file name, a selection of code, or by line number.
    1. [git-plus](https://atom.io/packages/git-plus): Do git things without the terminal (I don't think this is necessary anymore).

    The packages can be installed through Atom, or through the `apm` utility in the command line:

    ```bash
    apm install sublime-style-column-selection atom-language-r language-csv atom-beautify atom-wrap-in-tag minimap script
    ```

    And the following settings keep files consistent among developers.

    1. File | Settings | Editor | Tab Length: 2 (As opposed to 3 or 4, used in other conventions)
    1. File | Settings | Editor | Tab Type: soft (This inserts 2 spaces instead of a tab when 'Tab' is pressed)
