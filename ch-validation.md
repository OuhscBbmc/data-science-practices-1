Validation {#validation}
====================================

Intro {#validation-intro}
--------------------------------

Once you learn the tools to efficiently generate informative descriptive reports, the time you invest almost always pays off.

Validating your dataset has many benefits and can serve many roles, including

1. exploring basic descriptive patterns,
1. verifying that you understand the variable's definition,
1. communicating to your team what you already understand,
1. describing variation between locations or time periods,
1. evaluating preliminary hypotheses, and
1. assessing the likelihood that the assumptions of your inferential models are reasonable.

Ad-hoc Manual Inspections {#validation-ad-hoc}
--------------------------------

We recommend starting with a basic question and developing a quick and dirty report that addresses the immediate need.  Once your initial curiosity is satisfied, consider if the report can evolve into to address future needs.  One common evolutionary path is informing an inferential model.  A second common path is being assimilated in an automated report that is frequently run.

Inferential Support
--------------------

Automated Reports
--------------------


The two strategies can be connected.  If a ad-hoc inspection is enlightening, consider spending ~15 minutes to make the report easily reproducible as things change.  Here are some reasons why the report should be be monitored repeatedly are changes in

* Temporal Trends (*e.g.*, the dataset from Jan 2020 to Dec 2020 looks different that from Jan 2020 to Dec 2022)
* Inclusion criteria (*e.g.*, you further restrict the list of diagnosis code)
* Data Partner sites (*e.g.*, a new site contributes data with patterns you did't anticipate)
