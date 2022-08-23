Validation {#validation}
====================================

Intro {#validation-intro}
--------------------------------

Once you learn the tools to efficiently generate informative descriptive reports, the time you invest almost always pays off.

Validating your dataset serves many beneficial roles, including

1. exploring basic descriptive patterns,
1. verifying that you understand the variable's definition,
1. communicating to your team what you already understand,
1. describing variation between locations or time periods,
1. evaluating preliminary hypotheses, and
1. assessing the likelihood that the assumptions of your inferential models are reasonable.

Ad-hoc Manual Inspections {#validation-ad-hoc}
--------------------------------

We recommend starting with a basic question and developing a quick and dirty report that addresses an immediate need.  Once your initial curiosity is satisfied, consider if the report can evolve to address future needs.  One common evolutionary path is for the report to inform an inferential model.  A second common path is being assimilated in an automated report that is frequently run.

Inferential Support {#validation-inferential}
--------------------

### Brief Intro to Inferential Statistics {#validation-inferential-background}

*Descriptive* statistics differ from *inferential* statistics.  A descriptive statistic concerns only the observed elements in a sample, such as the average height or the range between the weakest and strongest systolic blood pressure.  There is no fuzziness or forecasting in a descriptive statistic --it's simply a straight-forward equation from observed points.^[Of course sometimes life isn't this easy, but that's the overall idea]

An inferential statistic tries to reach beyond a descriptive statistic: it projects beyond an observed sample.  It assesses if a pattern within a collected sample is likely to exist in the larger population.  Suppose a group of 40 newborns tended to have faster heart rates than 33 infants.  Stated differently, the average of the 40 newborns was faster than the average of the 33 infancts.  A large Student *t* (and its accompanying small *p*-value) may indicate that this difference exists among *all* babies --not just among the 73.  (Notice we're comparing the average of the two groups, and we are not saying the slowest newborn is still faster than the fastest infant)

However in order for its conclusions to be valid, several assumptions must be met.  See [@deshea] for information about the *t*-test and other analyses commonly used in health care.  

In this sense, the *t*-test resembles the broad category of inferential statistics: the validity of some assumptions can be evaluated from the research design (*e.g.*, each kid is measured independently), while other assumptions are best evaluated from the data (*e.g.*, the residuals/errors follow an approximate bell-shaped distribution).

These graphs that are useful assessing the appropriateness of an inferential statistic:

* for beginners: histograms
* for beginners: scatterplot of observed
* for beginners: plots of residuals (*i.e.*, the descrepancy between each point's observed & predicted value)
* for more advanced users, see the [suite of graphs](http://www.sthda.com/english/articles/39-regression-model-diagnostics/161-linear-regression-assumptions-and-diagnostics-in-r-essentials/) built into base R

In other words, these can help you establish the foundation that justifies the inferential statistic.

It is important to ... to be comfortable that an inferential statistic reasonably meet the assumptions and the conclusions are valid.
 
Automated Reports
--------------------

The two strategies (of ad-hoc inspections and inferential support) can be connected.  If an ad-hoc inspection is enlightening, consider spending ~15 minutes making the report easily reproducible as things change.  Here are some reasons why the report should be be monitored repeatedly are changes in

* Temporal Trends (*e.g.*, the dataset from Jan 2020 to Dec 2020 looks different that from Jan 2020 to Dec 2022)
* Inclusion criteria (*e.g.*, you further restrict the list of diagnosis code)
* Data Partner sites (*e.g.*, a new site contributes data with patterns you didn't anticipate)
