Regular Expressions {#regex}
====================================

A "regular expression" (commonly called a "regex") allows a programmer to leverage a pattern that identifies (and possibly extracts) nuggets of information buried within text fields that are otherwise unparsable.  You can't be too comfortable with regexes while data sciencing.  As you learn new regex capabilities, you'll see more opportunities to extract information with more efficiency and more integrity.

Regexes may be confusing at first (and they may always remain a little confusing) but the following resources will help you become proficient.

Tools:

* <http://regex101.com> is a easy tool for developing and testing regex patterns and replacements.  Cool features include (a) a panel with a thorough explanation of every characteristic of the regex and (b) the ability to save your regex and publicly share with collaborators.  It supports different flavors --the latest PCRE version corresponds with R's regex engine.

  When transferring the regex from the website to R, don't forget to "backslash the backslashes".  In other words, if the regex pattern is `\d{3}` (which matches three consecutive digits), declare the R variable as `pattern <- "\\d{3}"`.

Books:

* [Regular Expressions Chapter](https://r4ds.hadley.nz/regexps.html) of [*R for Data Science, 2nd edition*](https://r4ds.hadley.nz/).
* [*Introducing Regular Expressions*](https://www.oreilly.com/library/view/introducing-regular-expressions/9781449338879/)
* [*Regular Expressions Cookbook, 2nd Edition*](https://www.oreilly.com/library/view/regular-expressions-cookbook/9781449327453/)
* [*Mastering Regular Expressions, 3rd edition*](https://www.oreilly.com/library/view/mastering-regular-expressions/0596528124/)

Presentations:

* [Regex SCUG Presentation](https://rawgit.com/OuhscBbmc/StatisticalComputing/master/2019-presentations/11-november/beasley-scug-regex-part-2-2019-11.html#/)
