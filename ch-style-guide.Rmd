Style Guide {#style-guide}
====================================

Using a consistent style across your projects can increase the overhead as your data science team discusses options, decides on a good choice, and develops in compliant code.  But like in most themes in this document, the cost is worth the effort.  Unforced code errors are reduced when code is consistent, because mistake-prone styles are more apparent.

For the most part, our team follows the [tidyverse style](http://adv-r.had.co.nz/Style.html).  Here are some additional conventions we attempt to follow.

ggplot2
------------------------------------
The expressiveness of [ggplot2](https://ggplot2.tidyverse.org/) allows someone to quickly develop precise scientific graphics.  One graph can be specified in many equivalent styles, which increases the opportunity for confusion.  We formalized much of this style while writing a [textbook for introductory statistics](https://github.com/OuhscBbmc/DeSheaToothakerIntroStats/blob/master/thumbnails/thumbnails.md); the 200+ graphs and their code is publically available.


### Order of commands

ggplot2 is essentially a collection of functions combined with the `+` operator.  Publication graphs common require at least 20 functions, which means the functions can sometimes be redundant or step on each other toes.  The family of functoins should follow a consistent order ideally starting with the more important structural functions and ending with the cosmetic functions.  Our preference is:

1. `ggplot2()` is the primary function to specify the default dataset and aesthetic mappings.  Many arguments can be passed to `aes()`, and we prefer to follow an order consistent with the `scale_*()` order below.
1. `geom_*()` creates the *geom*etric elements that reperesent the data.  Unlike most categories in this list, the order matters.  Geoms specified first are drawn first, and therefore can be obscured by subsequent geoms.
1. `scale_*()` describes how a dimension of data (specified in `aes()`) is translated into a visual element.  We specify the dimensions in descending order of (typical) importance: `x`, `y`, `group`, `color`, `fill`, `size`, `radius`, `alpha`, `shape`, `linetype`.
1. `coord_*()`
1. `facet_*()` and `label_*()`
1. `theme()`
1. `labs()`

### Gotchas

Here are some common mistakes we see not-so-infrequently (even sometimes in our own code).

1. Call `coord_*()` to restrict the plotted *x*/*y* values, not `scale_*()` or `lims()`/`xlim()`/`ylim()`.  `coord_*()` zooms in on the axes, so extreme values essentially fall off the page; in contrast, the latter three functions essentially remove the values from the dataset.  The distinction does not matter for a simple bivariate scatterplot, but likely will mislead you and the viewer in two common scenarios.  First, a call to `geom_smooth()` (*e.g.*, that overlays a loess regression curve) ignore the extreme values entirely; consequently the summary location will be misplaced and its standard errors too tight.  Second, when a line graph or spaghetti plots contains an extreme value, it is sometimes desirable to zoom in on the the primary area of activity; when calling `coord_*()`, the trend line will leave and return to the plotting panel (which implies points exist which do not fit the page), yet when calling the others, the trend line will appear interrupted, as if the extreme point is a missing value.
