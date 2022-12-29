
# Contributing to gs.chainsearch

This document outlines the procedure for proposing a change to `gs.chainsearch`. For more details, see the [tidyverse constributing guide](https://rstd.io/tidy-contrib).


## Fixing Typos

You can fix typos, spelling mistakes, or grammatical errors in the documentation directly using the GitHub web interface, as long as the changes are made in the _source_ file. This generally means you'll need to edit [roxygen2 comments](https://roxygen2.r-lib.org/articles/roxygen2.html) in an `.R`, not a `.Rd` file. You can find the `.R` file that generates the `.Rd` by reading the comment in the first line.


## Bigger Changes

If you want to make a bigger change, it's a good idea to first file an issue and make sure someone from the core team agrees that it’s needed. If you’ve found a bug, please file an issue that illustrates the bug with a minimal [reprex](https://www.tidyverse.org/help/#reprex) (this will also help you write a unit test, if needed).


### Development Environment Setup

If you have any issues with the below process, please do not hesitate to reach out to the core team for assistance.

* Fork the repository to your github account and clone your fork into your local filesystem. If you haven't done this before, we recommend following the guide [here](https://happygitwithr.com/).

* Open `gs.chainsearch.Rproj` to open the R project in RStudio. This is necessary in order to perform automated development environment setup.

* The `renv` package is used to track dependencies. When the R session begins, the package installs itself and restores the package library. If any issues occur, a message will be displayed. *Follow any suggestions these messages make*. For instance, you should expect a message when you open the R project for the first time after cloning, instructing you to do `renv::restore()`. This is because actual package installations aren't tracked in Github.

* **IMPORTANT**: Standalone scripts should be saved within the `dev/` directory. This directory is ignored when the package is built and the code there will not be evaluated. This is a good place to store demo code.

* To rebuild the package during development, do `golem::document_and_reload()`. This will load the package and make exported methods available in the current session. It is a good idea to have this command binded to a shortcut since you will probably be doing it a lot.

* Make your changes, commit them to git, and then create a PR into upstream. The title of your PR should briefly describe the change and the body should contain `Fixes #issue-number`.

* For user-facing changes, add a bullet to the top of `NEWS.md` (i.e. just below the first header). Follow the style described in <https://style.tidyverse.org/news.html>.


### Adding Packages

If your code changes require a new package to be installed, please follow the below procedure:

1. Do `renv::install(<pkg>)` to install the package.

2. Do `usethis::use_package(<pkg>, min_version = TRUE)` to add the package to `DESCRIPTION`.

3. Do `renv::snapshot()` to update `renv.lock`, which is used for tracking purposes.

4. Include the appropriate `roxygen2` tags ("#' @importFrom <pkg> <method1> <method2> <...>") in the method that uses the new package.


### Code Style

* New code should follow the tidyverse [style guide](https://style.tidyverse.org). You can use the [styler](https://CRAN.R-project.org/package=styler) package to apply these styles, but please don't restyle code that has nothing to do with your PR.  

* We use [roxygen2](https://cran.r-project.org/package=roxygen2), with [Markdown syntax](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd-formatting.html), for documentation.

* We use [testthat](https://cran.r-project.org/package=testthat) for unit tests. Contributions with test cases included are easier to accept.


## Code of Conduct

Please note that the gs.chainsearch project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project you agree to abide by its terms.
