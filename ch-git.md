\cleardoublepage

(APPENDIX) Appendix {-}
====================================

Git & GitHub {#git}
====================================

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

    1. a link to the code's file (and ideally the line number, such as [`https://github.com/OuhscBbmc/REDCapR/blob/master/R/redcap-version.R#L40`](https://github.com/OuhscBbmc/REDCapR/blob/master/R/redcap-version.R#L40)) so the reader can hop over to the entire file.

    1. references to similar GitHub Issues or Stack Overflow questions that could aid troubleshooting.

<!-- Consider including good examples, like https://github.com/OuhscBbmc/miechv-3/issues/2073.  Probably shorten some for clarity. -->

for Stability {#git-stability}
------------------------------------

1. Review Git commits closely

    1. No unintended functional difference (*e.g.*, `!match` accidentally changed to `match`).
    1. No PHI snuck in (*e.g.*, a patient ID used while isolating and debugging).
    1. The metadata format didn't change (*e.g.*, Excel sometimes changes the string '010' to the number '10').  See [the appendix](#snippets-correspondence-excel) for a longer discussion about the problems that Excel typically introduces.

for New Collaborators {#git-collaborators}
------------------------------------

Steps for Contributing to Repo {#git-contribution}
------------------------------------

### Regular Contributions {#git-contribution-regular}

#### Keep your dev branch fresh {#git-contribution-regular-pull}

We recommend doing this at least every day you write code in a repo.  Perhaps more frequently if a lot of developers are pushing code (*e.g.*, right before a reporting deadline).

1. Update master on your local machine (from the GitHub server)
1. Merge master *into* your local dev branch
1. Push your local dev branch to the GitHub server

#### Make your code contributions available to other analysts {#git-contribution-regular-push}

At least every few days, push your changes to the master branch so teammates can benefit from your work.  Especially if you are improving the pipeline code (*e.g.* Ellises or REDCap Arches)

1. Make sure you dev branch is updated immediately before you create a [Pull Request]().  Follow the [steps above](#git-contribution-regular-pull).
1. Verify the merged code still works as expected.  In other words, make sure that when your new code is blended with the newest master code, nothing breaks.  Depending on the repo, these steps might include
    1. [Build and Check](https://support.rstudio.com/hc/en-us/articles/200486508-Building-Testing-and-Distributing-Packages) the repo (assuming the rep is also a package).
    1. Run any code that verify's the basic functionality of the repo.  (For example, our MIECHV team should run "high-school-funnel.R" and verify the assertions passed).
1. Commit changes in your dev branch and push to the GitHub server.
1. Create a [Pull Request](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) (otherwise known as a PR) and [assign a reviewer](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/about-pull-request-reviews).  (For example, developers in the MIECHV team are paired together to review each other's code.)
1. The reviewer will pull your dev branch on to their local machine and run the same checks and verification (that you did on the 2nd step above).  This duplicate effort helps verify that your code likely works for everyone on their own machines.
1. The reviewer then accepts the PR and the master branch now contains your changes and are available to teammates.

-------

{Transfer & update the material from https://github.com/OuhscBbmc/BbmcResources/blob/master/instructions/github.md}
