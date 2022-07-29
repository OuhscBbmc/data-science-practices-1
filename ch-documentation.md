Documentation {#document}
====================================

Team-wide
------------------------------------

Project-specific
------------------------------------

Dataset Origin & Structure
------------------------------------

Issues & Tasks {#document-issues}
------------------------------------

### GitHub Issue Template {#documentation-issue-template}

If you are going to open up a repo/package to the public, consider creating a [template for GitHub Issues](https://help.github.com/en/github/building-a-strong-community/about-issue-and-pull-request-templates) that's tailored to the repo's unique characteristics.  Furthermore, invite feedback from your user base to improve the template.  Here is our appeal in [REDCapR](https://github.com/OuhscBbmc/REDCapR/issues/291) that produced the [Unexpected Behavior issue template](https://github.com/OuhscBbmc/REDCapR/blob/master/.github/ISSUE_TEMPLATE/unexpected-behavior-issue-template.md):

> \@nutterb \@haozhu233, \@rparrish, \@sybandrew, and any one else, if you have time, please look at the [new issue template](https://github.com/OuhscBbmc/REDCapR/blob/master/.github/ISSUE_TEMPLATE/unexpected-behavior-issue-template.md) that is customized for REDCapR/redcapAPI.  I'd appreciate any feedback that could improve the experience for someone encountering a problem.
>
> I'd like something to (a) make it easier for the user to provide useful information with less effort and (b) make it easier for us to help more accurately with fewer back-and-forths.  And if the template happens to help the user identify and solve the problem without creating the issue  ...then I think everyone is happier too.
>
> I think the issue should leverage the [Troubleshooter](https://ouhscbbmc.github.io/REDCapR/articles/TroubleshootingApiCalls.html) that 10+ people have contributed to.  It should help locate the problematic area more quickly.
>
> \@haozhu233, it seems you've liked the [template in kableExtra](https://github.com/haozhu233/kableExtra/issues/new?template=bug_report.md).  REDCapR is different in the sense it's more difficult to provide a minimal & self-contained example to reproduce the problem.  But with your experience with so many users and issues, I'd love any advice.
>
> \@nutterb, I'd like this template to be helpful to [redcapAPI](https://github.com/nutterb/redcapAPI) too.  There are only three quick find-and-replace occurrences of 'REDCapR' -> 'redcapAPI'.  And those were mostly to distinguish the R package from REDCap itself.

Flow Diagrams
------------------------------------

Setting up new machine {#document-workstation}
------------------------------------

Thoroughly describe the programs and configuration settings your team should follow.  Feel free to adapt [our list](#workstation) for your needs.

You'll see a handful of benefits:

1. New hires will be more productive sooner, and you will be able to spend more time on conceptual issues instead of walking them through tedious installation issues.
1. When everyone on the team has a similar environment, it is easier to share code. And the quality of the code hopefully improves because everyone can leverage each others contributions.
1. Sometimes an IT department is reluctant grant admin rights, especially to new users.  IT is more likely to trust your team when your installation documentation demonstrates you have thought carefully through the issues.  Typically most users just need a few programs like Office and Adobe; IT may not realize how many tools are used by a well-round data scientist.

    If IT is still reluctant to grant admin privileges, make sure they realize that (a) it takes ~45 minutes to install the ~12 programs on a fresh machine, (b) many of the programs are updated every few months, and (c) a data scientist typically installs a 5+ R packages a month as they explore tools and stay current with the field.  Installing and maintaining everyone's workstation would require a significant amount of their time.  You and your team are willing to help alleviate that burden and maintain your own software.

Documenting with Markdown in a GitHub Repo {#document-mechanics}
------------------------------------

This quick demo walks through https://national-covid-cohort-collaborative.github.io/book-of-n3c-v1/

1. Select correct file in repo.
1.
