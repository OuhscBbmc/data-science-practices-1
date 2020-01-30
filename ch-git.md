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
