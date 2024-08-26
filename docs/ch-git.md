\cleardoublepage

(APPENDIX) Appendix {-}
====================================

Git & GitHub {#git}
====================================

Justification {#git-justification}
------------------------------------

(*Written in 2017 to justify the service to a corporation's IT department.*)

Git and GitHub are the de facto version control software and hosting solution for software development in modern data science.  Using GitHub will help our group with three critical tasks: (a) developing our own software, (b) leveraging innovations of others, and (c) attracting top talent.

**Developing Software**: Version control is critical for developing quality software, especially when multiple data scientists are contributing to the same code bank.  Among modern version control software, Git and GitHub are the most popular for new projects, especially among the talent pool that we recruit from.  Compared to outdated approaches using conventional file-servers, version control substantially increases productivity.  Analysts can develop code & report in parallel, and then combine when their branch is mature.  Additionally, all commits are saved indefinitely, allowing us to 'turn back the clock' are resurrect older code when necessary.  It also allows us to organize and manage our proprietary code in a single (distributed) location.

Given the needs of our small data science team, we believe that private GitHub repositories (secured with two-factor authentication) strike a nice balance between (a) security, (b) ease of use for developers, (c) ease of maintenance for administrators, and (d) cost.

**Leveraging Innovation**: Most cutting-edge data science algorithms are released on GitHub.  These algorithms are not stand-alone software; instead they augment the statistical software, R, which has been approved by IT.  Furthermore, GitHub.com hosts the documentation and user forums for most data science algorithms.  Without access to this information, we are at greater risk of misunderstanding and misusing the routines, which could weaken the accuracy of the financial reports we produce.

**Attracting Talent**: As we compete for the top talent in the highly competitive field of data science, we want to provide access its standard tools.  We do not want to send the message that our organization doesn't value the advancements appreciated and employed by our competitors.

**Alternatives**: The GitHub approach described above is the most common, but is not the only approached endorsed by contemporary developers.  Others include:

* GitHub Enterprise: hosting solution developed by GitHub, but hosted on a university-controlled VM.
* GitLab:  A competitor to GitHub.  GitLab uses Git, but has a different hosting options, both cloud and on-premises.
* Mercurial: modern version control that is similar to Git.  It has many of Git's strengths and avoids many of the undesirable features of Subversion/SVN.
* Atlassian: A competitor to GitHub that focuses on businesses.  Altassian/Bitbucket repositories can use Git or Mercurial.  Like GitHub and GitLab, they offers different hosting options.

**Resources**:

1. GitHub for Business
2. Git for Teams

for Code Development {#git-code}
------------------------------------

[Jenny Bryan](https://github.com/jennybc) and [Jim Hester](https://github.com/jimhester) have published a thorough description of using Git from a data scientist's perspective ([Happy Git and GitHub for the useR](https://happygitwithr.com/)), and we recommend following their guidance.  It is consistent with our approach, with a few exceptions noted below.  A complementary resource is *[Team Geek](https://smile.amazon.com/dp/1449302440)*, which has insightful advice for the human and collaborative aspects of version control.

Other Resources

1. [Setting up a CI/CD Process on GitHub with Travis CI](https://blog.travis-ci.com/2019-05-30-setting-up-a-ci-cd-process-on-github).  Travis-CI blob from August 2019.

for Collaboration {#git-collaboration}
------------------------------------

1. Somewhat separate from it's version control capabilities, GitHub provides built-in tools for coordinating projects across people and time.  This tools revolves around [GitHub Issues](https://guides.github.com/features/issues/), which allow teammates to

1. track issues assigned to them and others
1. search if other teammates have encountered similar problems that their facing now (*e.g.*, the new computer can't install the [rJava](https://CRAN.R-project.org/package=rJava) package).

There's nothing magical about GitHub issues, but if you don't use them, consider using a similar or more capable tools like those offered by [Atlassian](https://www.atlassian.com/), [Asana](https://asana.com/), [Basecamp](https://basecamp.com/), and many others.

Here are some tips from our experiences with projects involving between 2 and 10 statisticians are working with an upcoming deadline.

1. If you create an error that describes a problem blocking your progress, include both the raw text (*e.g.*, `error: JAVA_HOME cannot be determined from the Registry`) and possibly a screenshot.  The text allows the problem to be more easily searched by people later; the screenshot usually provides extra context that allows other to understand the situation and help more quickly.

1. Include enough broad context and enough specific details that teammates can quickly understand the problem.  Ideally they can even run your code and debug it.  Good recommendations can be found in the Stack Overflow posts, ['How to make a great R reproducible example'](https://stackoverflow.com/questions/5963269/how-to-make-a-great-r-reproducible-example?rq=1) and ['How do I ask a good question?'](https://stackoverflow.com/help/how-to-ask).  The issues don't need to be as thorough, because your teammates start with more context than a Stack Overflow reader.

    We typically include

    1. a description of the problem or fishy behavior.

    1. the exact error message (or a good description of the fishy behavior).

    1. a snippet of the 1-10 lines of code suspected of causing the problem.

    1. a link to the code's file (and ideally the line number, such as [`https://github.com/OuhscBbmc/REDCapR/blob/main/R/redcap-version.R#L40`](https://github.com/OuhscBbmc/REDCapR/blob/main/R/redcap-version.R#L40)) so the reader can hop over to the entire file.

    1. references to similar GitHub Issues or Stack Overflow questions that could aid troubleshooting.

<!-- Consider including good examples, like https://github.com/OuhscBbmc/miechv-3/issues/2073.  Probably shorten some for clarity. -->

for Stability {#git-stability}
------------------------------------

1. Review Git commits closely

    1. No unintended functional difference (*e.g.*, `!match` accidentally changed to `match`).
    1. No PHI snuck in (*e.g.*, a patient ID used while isolating and debugging).
    1. The metadata format didn't change (*e.g.*, Excel sometimes changes the string '010' to the number '10').  See [the appendix](#snippets-correspondence-excel) for a longer discussion about the problems that Excel typically introduces.

Organization-wide defaults and practices
------------------------------------

Our core-wide goal of being [secure by default](https://en.wikipedia.org/wiki/Secure_by_default) applies to GitHub too.  Some security measures have to be added explicitly (*e.g.*, `.gitignore` blocking common data files like `*.csv` & `*.xlsx`), but these organization-wide settings make new repo more secure as soon as their initialized, even at the cost of accessibility.

*Defaults*

1. Two-factor authentication [is required](https://help.github.com/articles/requiring-two-factor-authentication-in-your-organization/) for all organization members and outside collaborators.  See setting "Security" => "Two-factor authentication"

1. Organization members are [restricted from creating repositories](https://help.github.com/articles/repository-permission-levels-for-an-organization/#restricting-people-from-creating-repositories).  See setting "Member privileges" => "Repository creation".

1. Organization members have [zero permissions on new repositories](https://help.github.com/articles/repository-permission-levels-for-an-organization/#restricting-people-from-creating-repositories).  See setting "Member privileges" => "Default repository permission"
.

*Practices*

1. Authorized teammates outside OUHSC are designated as [outside collaborators](https://help.github.com/articles/adding-outside-collaborators-to-repositories-in-your-organization/), instead of "members".

1. Only three people are [owners](https://help.github.com/articles/permission-levels-for-an-organization/) of the GitHub organization.  Everyone else must be explicitly added to each appropriate repository.  Other important restrictions to members include (a) cannot add/delete/transfer (private or public) repositories and (b) cannot add/delete other members to organization.

1. Every week, an owner (probably @wibeasley) will review the [organization's audit log](https://github.com/organizations/OuhscBbmc/settings/audit-log) (which only owners can view).

1. Two or more owners must discuss and agree upon adding/modifying/deleting any extra entity added to our GitHub Organization, including
    1. [webhooks](https://developer.github.com/webhooks/),
    1. [third-party applications](https://help.github.com/articles/about-third-party-application-restrictions/),
    1. [installed integration](https://developer.github.com/early-access/integrations/), and
    1. [OAuth applications](https://developer.github.com/v3/oauth/).

    Currently, the only approved entity is the [Codecov](https://codecov.io/) integration, which helps us test our package code and quantify its coverage ("Improve code quality. Expose bugs and security vulnerabilities.").  Codecov must be explicitly turned on for each desired repository.

for New Collaborators {#git-collaborators}
------------------------------------

Steps for Contributing to Repo {#git-contribution}
------------------------------------

### Regular Contributions {#git-contribution-regular}

#### Keep your dev branch fresh {#git-contribution-regular-pull}

We recommend doing this at least every day you write code in a repo.  Perhaps more frequently if a lot of developers are pushing code (*e.g.*, right before a reporting deadline).

1. Update the "main" branch on your local machine (from the GitHub server)
1. Merge main *into* your local dev branch
1. Push your local dev branch to the GitHub server

#### Make your code contributions available to other analysts {#git-contribution-regular-push}

At least every few days, push your changes to the main branch so teammates can benefit from your work.  Especially if you are improving the pipeline code (*e.g.* Ellises or REDCap Arches)

1. Make sure you dev branch is updated immediately before you create a [Pull Request]().  Follow the [steps above](#git-contribution-regular-pull).
1. Verify the merged code still works as expected.  In other words, make sure that when your new code is blended with the newest main code, nothing breaks.  Depending on the repo, these steps might include
    1. [Build and Check](https://support.rstudio.com/hc/en-us/articles/200486508-Building-Testing-and-Distributing-Packages) the repo (assuming the rep is also a package).
    1. Run any code that verify's the basic functionality of the repo.  (For example, our MIECHV team should run "high-school-funnel.R" and verify the assertions passed).
1. Commit changes in your dev branch and push to the GitHub server.
1. Create a [Pull Request](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) (otherwise known as a PR) and [assign a reviewer](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/about-pull-request-reviews).  (For example, developers in the MIECHV team are paired together to review each other's code.)
1. The reviewer will pull your dev branch on to their local machine and run the same checks and verification (that you did on the 2nd step above).  This duplicate effort helps verify that your code likely works for everyone on their own machines.
1. The reviewer then accepts the PR and the main branch now contains your changes and are available to teammates.

#### "Main" vs "Master" Branch

If you are using an old repo (that was initialized [before 2021](https://www.theserverside.com/feature/Why-GitHub-renamed-its-master-branch-to-main)) and whose default branch is still called "master", it's fairly simple to [rename to "main"](https://github.com/github/renaming) on the server.

In the client, there are two options.  The first is to delete and reclone (make sure everything is pushed to the central repo before deleting).  The second is to open a command prompt (with Window's cmd, Window's PowerShell, or Linux bash) and paste these four lines.

```sh
git branch -m master main
git fetch origin
git branch -u origin/main main
git remote set-head origin -a
```

GitHub Personal Access Token (PAT)
------------------------------------

The tokens have two purposes that we encounter regularly.

### Pushing to any repo or reading from a private repo

...especially on Linux machines that don't have [GitHub Desktop](https://desktop.github.com/).

{TODO: write this section}

### Using the [remotes](https://remotes.r-lib.org/) package

If you are using the [remotes](https://remotes.r-lib.org/) with a line like
`remotes::install_github("Melinae/TabularManifest")` or `remotes::install_github("tidyverse/ggplot2")`,
you may encounter this error:

```
Using GitHub PAT from the git credential store.
Error: Failed to install 'unknown package' from GitHub:
  HTTP error 401.
  Bad credentials
```

If so,

1.  Create a classic personal access token at <https://github.com/settings/tokens>.
    (Make sure you're logged in.)
    We suggest creating one per machine, so you don't have to juggle them between computers.
1.  Maybe name it "ouhsc-desktop" or "home-laptop" (obligatory reminder to never store PHI on a personal machine).
    Copy the new token to your clipboard.
1.  Then use the [gitcreds](https://gitcreds.r-lib.org/) package by running, `gitcreds::gitcreds_set()`.
    Then select to add/replace the token with the value that you just copied to your clipboard.
1.  Rerun the `remotes::install_github()`.

Repo Style
------------------------------------

Please see the [Code Repositories](#style-repo) section in the [Style Guide](#style) chapter.

-------

{Transfer & update the material from https://github.com/OuhscBbmc/BbmcResources/blob/main/instructions/github.md}
