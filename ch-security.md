Security & Private Data {#security}
====================================

Overview

*{Include a few paragraphs that describe principles and mentality, and how the following sections contribute.}*


The report's dataset(s) are preferably stored in REDCap or SQL Server.
They're absolutely not stored not on GitHub or the local machine.
Avoid Microsoft Access, Excel, CSVs, or anything without user accounts.
If the PHI must be stored as a loose file (eg, CSV), keep it on the encrypted file server.
Any PHI on a fileserver should be stored in a directory controlled by a fairly restrictive Windows AD group. Only ~4 people on a project probably need access to those files, not all ~20 people on a project.
There are many benefits of SQL Server over CSVs or Excel files .
It's protected by Odyssey (not just the VPN).
It provides auditing logs.
It provides schemas to further partition authorization.
Real databases aren't accidentally emailed or copied to an unsecured location.
Transfer PHI into REDCap & SQL Server as early as possible (particularly the CSVs & XLSXs we regularly receive from partners).
Temporary and derivative datasets are stored in SQL Server, not as a CSV on the fileserver.

Security Guidelines
------------------------------------

If you encounter a decision that's not described by this chapter's the security practices, follow these underlying concepts.  And of course, consult other people.

* Principle of least privilege: expose as little as possible.
  * Limit the number of team members.
  * Limit the amount of data (consider rows & columns).
  * Obfuscate values and remove unnecessary PHI in derivative datasets.
* Redundant layers of protection.
  * A single point of failure shouldn't be enough to breach PHI security.
* Simplicity when possible.
  * Store data in only two houses (eg, REDCap & SQL Server).
  * Easier to identify & manage than a bunch of PHI CSVs scattered across a dozen folders, with versions.
    * Manipulate your data programmatically, not manually.
  * Your Windows AD account controls everything, indirectly or directly:
    * VPN, Odyssey, file server, SQL, REDCap, & REDCap API.
* Lock out team members when possible.
  * It's not that you don't trust them with a lot of unnecessary data, it's that you don't trust their ex-boyfriends and their coffee shop hackers.


Dataset-level Redaction
------------------------------------

Several multi-layered strategies exist to prevent exposing PHI.  One approach is simply to reduce the information contained in each variable.  Much of the information in a medical record is not useful for modeling or descriptive statistics, and therefore can be omitted from downstream datasets.  The techniques include:

1. *Remove the variable*: An empty bucket has nothing to leak.
1. *Decrease the resolution*: Many times, a patient's year of birth is adequate for analysis, and include the month and day are unnecessary risks.
1. *Hash and salt identifiers*: use cryptographic-quality algorithms transform an ID to a derived value.  For example, "234" becomes "1432c1a399".  The original value of 234 is not recoverable from 1432c1a399.  But two rows with 1432c1a399 are still attributed to the same patient by the statistical model.

Security for Data at Rest
------------------------------------

* The report's dataset(s) are preferably stored in REDCap or SQL Server.
  * They're absolutely not stored not on GitHub or the local machine.
  * Avoid Microsoft Access, Excel, CSVs, or anything without user accounts.
  * If the PHI must be stored as a loose file (eg, CSV), keep it on the encrypted file server.
* Any PHI on a fileserver should be stored in a directory controlled by a fairly restrictive Windows AD group.  Only ~4 people on a project probably need access to those files, not all ~20 people on a project.
* There are many benefits of SQL Server over CSVs or Excel files .
  * It's protected by Odyssey (not just the VPN).
  * It provides auditing logs.
  * It provides schemas to further partition authorization.
  * Real databases aren't accidentally emailed or copied to an unsecured location.
* Transfer PHI into REDCap & SQL Server as early as possible (particularly the CSVs & XLSXs we regularly receive from partners).
* Temporary and derivative datasets are stored in SQL Server, not as a CSV on the fileserver.
* Hash values when possible.  For instance, when we determine families/networks of people, we use things like SSNs.  But the algorithm that identifies the clusters doesn't need to know the *actual* SSN, just that two records have the *same* SSN.  Something like a [SHA-256 hash](http://en.wikipedia.org/wiki/SHA-2) is good for this.  The algorithm can operate on the hashed SSN just as effectively as the real SSN. However the original SSN can't be determined from its hashed value.  If the table is accidentally exposed to the public, no PHI is compromised. The following two files help the hashing & salting process: [HashUtility.R](https://github.com/OuhscBbmc/RedcapExamplesAndPatterns/blob/main/CodeUtilities/HashUtility.R) and [CreateSalt.R](https://github.com/OuhscBbmc/RedcapExample/blob/main/CodeUtilities/CreateSalt.R).

File-level permissions
------------------------------------

Database permissions
------------------------------------

Public & Private Repositories
------------------------------------

### Repo Rules

* A code repository should be private, and restricted to only the necessary project members.
* The repo should be controled by an OUHSC organization, and not by an individual's private account.
* The `.gitignore` file prohibits common data file formats from being pushed/uploaded to the central repository.
  * Examples: accdb, mdb, xlsx, csv, sas7bdat, rdata, RHistory.
  * If you have a text file without PHI that must be on GitHub, create a new extension for it like '*.PhiFree'.
  * Or you can include a specific exception to the .gitignore file, but adding an exclamation point in front of the file, such as `!RecruitmentProductivity/RecruitingZones/ZipcodesToZone.csv`.  An example is included in the current repository's [.gitignore file(https://github.com/OuhscBbmc/RedcapExamplesAndPatterns/blob/main/.gitignore).

### Scrubbing GitHub history

Occasionally files may be committed to your git repository that need to be removed completely.  Not just from the current collections of files (*i.e.*, the branch's [head](https://git-scm.com/docs/gitglossary#gitglossary-aiddefHEADaHEAD)), but from the entire history of the repo.

Scrubbing is require typically when (a) a sensitive file has been accidentally committed and pushed to GitHub, or (b) a huge file has bloated your repository and disrupted productivity.

The two suitable scrubbing approaches both require the command line.  The first is the `git-filter-branch` command within git, and the second is the [BFG repo-cleaner](https://rtyley.github.io/bfg-repo-cleaner/).  We use the second approach, which is [recommended by GitHub]; it requires 15 minutes to install and configure from scratch, but then is much easier to develop against, and executes much faster.

The [bash](https://www.gnu.org/software/bash/)-centric steps below remove any file*s* from the repo history called 'monster-data.csv' from the 'bloated' repository.

1. If the file contains passwords, change them immediately.
1. Delete 'monster-data.csv' from your branch and push the commit to GitHub.
1. Ask your collaborators to push any outstanding commits to GitHub and delete their local copy of the repo.  Once scrubbing is complete, they will re-clone it.
1. Download and install the most recent Java JRE from the Oracle site.
1. Download the most recent jar file from the BFG site to the home directory.
1. Clone a fresh copy of the repository in the user's home directory.  The `--mirror` argument avoids downloading every file, and downloads only the bookkeeping details required for scrubbing.

    ```bash
    cd ~
    git clone --mirror https://github.com/your-org/bloated.git
    ```

1. Remove all files (in any directory) called 'monster-data.csv'.

    ```bash
    java -jar bfg-*.jar --delete-files monster-data.csv bloated.git
    ```

1. [Reflog](https://git-scm.com/docs/git-reflog) and [garbage collect](https://git-scm.com/docs/git-gc) the repo.

    ```bash
    cd bloated.git
    git reflog expire --expire=now --all && git gc --prune=now --aggressive
    ```

1. Push your local changes to the GitHub server.

    ```bash
    git push
    ```

1. Delete the bfg jar from the home directory.

    ```bash
    cd ~
    rm bfg-*.jar
    ```

1. Ask your collaborators to re-clone the repo to their local machine.  It is important they restart with a fresh copy, so the once-scrubbed file is not reintroduced into the repo's history.

1. If the file contains sensitive information, like passwords or PHI, ask GitHub to refresh the cache so the file's history isn't accessible through their website, even if the repo is private.

##### Resources

* [BFG Repo-Cleaner site](https://rtyley.github.io/bfg-repo-cleaner/)
* [Additional BFG instructions](https://github.com/IBM/BluePic/wiki/Using-BFG-Repo-Cleaner-tool-to-remove-sensitive-files-from-your-git-repo)
* [GitHub Sensitive Data Removal Policy](https://help.github.com/articles/github-sensitive-data-removal-policy/)
