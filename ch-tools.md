Considerations when Selecting Tools {#tools}
====================================

General
------------------------------------

### The Component's Goal

While discussing the advantages and disadvantages of tools, a colleague once said, "Tidyverse packages don't do anything that I can't already do in Base R, and sometimes it even requires more lines of code".  Regardless if I agree, I feel these two points are irrelevant.  Sometimes the advantage of a tool isn't to expand existing capabilities, but rather to facilitate development and maintenance for the same capability.

Likewise, I care less about the line count, and more about the readability.  I'd prefer to maintain a 20-line chunk that is familiar and readable than a 10-line chunk with dense phrases and unfamiliar functions.  The bottleneck for most of our projects is human time, not execution time.

### Current Skillset of Team

### Desired Future Skillset of Team

### Skillset of Audience

Languages
------------------------------------

R Packages
------------------------------------

1. When developing a codebase used by many people, choose packages both on their functionality, as well as their ease of installation and maintainability.  For example, the [rJava](https://CRAN.R-project.org/package=rJava) package is a powerful package that allows R package developers to leverage the widespread [Java](https://www.java.com/en/) framework and many popular Java packages.  However, installing Java and setting the appropriate [path](https://en.wikipedia.org/wiki/PATH_(variable)) or [registry](https://en.wikipedia.org/wiki/Windows_Registry) settings can be error-prone, especially for non-developers.  

    Therefore when considering between two functions with comparable capabilities (*e.g.*, [`xlsx::read.xlsx()`](https://CRAN.R-project.org/package=xlsx) and [`readxl::read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html)), avoid the package that requires a proper installation and configuration of Java and rJava.
    
    If the more intensive choice is required (say, you need to a capability in [xslx](https://CRAN.R-project.org/package=xlsx) missing from [readxl](https://readxl.tidyverse.org/)), take:
    
    1. 20 minutes to **start a markdown file** that enumerates the package's direct and indirect dependencies that require manual configuration (*e.g.*, rJava and Java), where to download them, and the typical installation steps.
    
    1. 5 minutes to **create a GitHub Issue** that (a) announces the new requirement, (b) describes who/what needs to install the requirement, (c) points to the markdown documentation, and (d) encourages teammates to post their problems, recommendations, and solutions in this issue.  We've found that a dedicated Issue helps communicate that the package dependency necessitates some intention and encourages people to assist other people's troubleshooting.  When something potentially useful is posted in the Issue, move it to the markdown document.  Make sure the document and the issue hyperlink to each other.
    
    1. 15 minutes every year to re-evaluate the landscape.  Confirm that the package is still actively maintained, and that no newer (and easily- maintained) package offers the desired capability.^[In this case, the [openxlsx](https://ycphs.github.io/openxlsx) package is worth consideration because it writes to an Excel file, but uses a C++ library, not a Java library.]  If better fit now exists, evaluate if the effort to transition to the new package is worth the benefit.  Be more willing to transition is the project is relatively green, and more development is upcoming.  Be more willing to transition if the transition is relatively in-place, and will not require much modification of code or training of people.
    
Finally, consider how much traffic passes through the dependency  A brittle dependency will not be too disruptive if isolated in a downstream analysis file run by only one statistician. On the other hand, be very protective in the middle of the pipeline where typically most of your team runs.

Database
------------------------------------

1. Ease of installation & maintenance

1. Support from IT --which database engine are they most comfortable supporting.

1. Integration with LDAP, Active Directory, or Shibboleth.

1. Warehouse vs transactional performance
