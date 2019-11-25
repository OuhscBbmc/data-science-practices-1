Security & Private Data {#security}
====================================

File-level permissions
------------------------------------

Database permissions
------------------------------------

Public & Private Repositories
------------------------------------

### Scrubbing GitHub history

Occassionaly files may be committed to your git repository that need to be removed completely.  Not just from the current collections of files (*i.e.*, the branch's [head](https://git-scm.com/docs/gitglossary#gitglossary-aiddefHEADaHEAD)), but from the entire history of the repo.  

Scrubbing is require typically when (a) a sensitive file has been accidentally commited and pushed to GitHub, or (b) a huge file has bloated your repository and disrupted productivity.

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
1. Ask your collaborators to reclone the repo to their local machine.  It is important they restart with a fresh copy, so the once-scrubbed file is not reintroduced into the repo's history. 

1. If the file contains sensitive information, like passwords or PHI, ask GitHub to refresh the cache so the file's history isn't accessible through their website, even if the repo is private.

##### Resources

* [BFG Repo-Cleaner site](https://rtyley.github.io/bfg-repo-cleaner/)
* [Additional BFG instructions](https://github.com/IBM/BluePic/wiki/Using-BFG-Repo-Cleaner-tool-to-remove-sensitive-files-from-your-git-repo)
* [GitHub Sensitive Data Removal Policy](https://help.github.com/articles/github-sensitive-data-removal-policy/)
