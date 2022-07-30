Scratch Pad of Loose Ideas {#scratch-pad}
====================================

Chapters & Sections to Form
------------------------------------

1. Tools to Consider
    1. tidyverse
    1. odbc

1. ggplot2
    1. use factors for explanatory variables when you want to keep the order consistent across graphs. ([genevamarshall](https://github.com/genevamarshall))

1. automation on a remote server or VDI

    There's always a chance that my machine is configured a little differently than yours, which may affect results.  Will you glance at those results too?  I forgot what this project is about, and I wouldn't be able to spot problems like you can. The S drive file and the tables don't seem to have any obvious problems

1. public reports (and dashboards)
    1. when developing a report for a external audience (ie, people outside your immediate research team), choose one or two pals who are unfamiliar with your aims/methods as an impromptu focus group.  Ask them what things need to be redesigned/reframed/reformated/further-explained. ([genevamarshall](https://github.com/genevamarshall))
        1. plots
        1. plot labels/axes
        1. variable names
        1. units of measurement (eg, proportion vs percentage on the *y* axis)

1. documentation - bookdown

    > Bookdown has worked well for us so far.  It's basically independent markdown documents stored on a dedicated git repo.  Then you click "build" in RStudio and it converts all the markdown files to static html files.  Because GitHub is essentially serving as the backend, everyone can make changes to sections and we don't have to be too worried about
    >
    > Here's a version that's hosted publicly, but I tested that it can be hosted on our shared file server.  (It's possible because the html files are so static.)  If this is what you guys want for OU's collective CDW, please tell me:
    >
    > * who you want to be able to edit the documents without review.  I'll add them to the GitHub repo.
    > * who you want to be able to view the documents.  I'll add them to a dedicate file server space.
    >
    >
    > https://ouhscbbmc.github.io/data-science-practices-1/workstation.html#installation-required
    >
    > I was thinking that each individual database gets it own chapter.  The BBMC has ~4 databases in this sense: a Centricity staging database, a GECB staging database, the central warehouse, and the (fledgling) downstream OMOP database.  Then there are ~3 sections within each chapter: (a) a black-and-white description of the tables, columns, & indexes (written mostly for consumers), (b) recommendations how to use each table (written mostly for consumers), and (c) a description of the ETL process (written mostly for developers & admins).
    >
    > My proposal uses GitHub and Markdown because they're so universal (no knowledge of R is required --really you could write it with any text editor & commit, and let someone else click "build" in RStudio on their machine).  But I'm very flexible on all this.  I'll support & contribute to any system that you guys feel will work well across the teams.

1. developing packages

    * [*R packages*](http://r-pkgs.had.co.nz/) by Hadley Wickham

    * http://mangothecat.github.io/goodpractice/

1. Cargo cult programming "is a style of computer programming characterized by the ritual inclusion of code or program structures that serve no real purpose." ([Wikipedia](https://en.wikipedia.org/wiki/Cargo_cult_programming))

    Your team should decide which elements of [a file prototype](https://ouhscbbmc.github.io/data-science-practices-1/prototype-r.html) and [repo prototype](https://ouhscbbmc.github.io/data-science-practices-1/prototype-repo.html) are best for you.

Practices
------------------------------------

* `on.exit()` should have `add = TRUE` (@wickham-advanced-r, [Exit handlers](https://adv-r.hadley.nz/functions.html#on-exit)).

Good Sites
------------------------------------

Posts on these sites are almost always worth your time reading.  The frequently improve how you develop with the common components used in our data pipelines.

* [Yihui Xie](https://yihui.org/en/), created [knitr](https://yihui.org/knitr/) and other important contributions to reproducible research.
* [RStudio](https://blog.rstudio.com/), in addition to their IDE, many of the packages used here were created by their developers.
* [Explain xkcd](www.explainxkcd.com) because it's good.

Occasionally skim the titles on these sites and pick a few relevant to your interests.  We think it helps keep you aware of developments in the field, so your skills continually grow and our approaches don't become stagnant.

* [O'Reilly's Data science ideas and resources](https://www.oreilly.com/topics/data-science)
* [Towards Data Science](https://towardsdatascience.com/)

These books haven't been referenced (yet), but have good guidance and could be worth your time skimming to see what is relevant.

* [*The Tidynomicon*](http://tidynomicon.tech/) by Dhavide Aruliah & Greg Wilson

* [*Efficient R programming*](https://bookdown.org/csgillespie/efficientR/) by Colin Gillespie & Robin Lovelace

* [Mastering Software Development in R](https://bookdown.org/rdpeng/RProgDA/)
