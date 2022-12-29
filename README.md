gs.chainsearch
================

![Current Version](https://img.shields.io/badge/version-0.0.1-blue)
![GitHub
stars](https://img.shields.io/github/stars/timothyslau/gs.chainsearch)
![GitHub
forks](https://img.shields.io/github/forks/timothyslau/gs.chainsearch)

This package provides methods to perform a forward chaining search via
[Google Scholar](https://scholar.google.com/). It accomplishes this by
scraping publications that cite a cornerstone publication via the “Cited
By” search feature. The primary purpose of this package is to enable
researchers to produce comprehensive literature reviews.

The general strategy is as follows:

1.  Identify a cornerstone publication.
2.  Scrape the search results for citing publications and save the raw
    html.
3.  Parse and combine key metadata (publication details) from the raw
    html.
4.  Process metadata (e.g., remove duplicates).

Contributions are more than welcome. Please see
[Contributing](#contributing) for guidance.

## <a id = "contributing">Contributing</a>

To setup the development environment:

1.  Fork the repository to your github account and clone your fork into
    your local filesystem. See <https://happygitwithr.com/> for
    instructions on how to do this.
2.  Open `gs.chainsearch.Rproj` to open the R project in RStudio. This
    is necessary in order to perform automated development environment
    setup.
3.  The `renv` package is used to track dependencies. When the R session
    begins, the package installs itself and restores the package
    library. If any issues occur, a message will be displayed. *Follow
    any suggestions these messages make*. For instance, you should
    expect a message when you open the R project for the first time
    after cloning, instructing you to do `renv::restore()`. This is
    because actual package installations aren’t tracked in Github.
4.  **IMPORTANT**: Standalone scripts should be saved within the `dev/`
    directory. This directory is ignored when the package is built and
    the code there will not be evaluated. This is a good place to store
    demo code.
5.  To rebuild the package, do `golem::document_and_reload()`. This will
    load the package and make exported methods available in the current
    session.

**Packages**

To add a dependency, the following procedure should be followed: 1. Do
`renv::install(<pkg>)` to install the package. 2. Do
`usethis::use_package(<pkg>, min_version = TRUE)` to add the package to
`DESCRIPTION`. 3. Do `renv::snapshot()` to update `renv.lock`, which is
used for tracking purposes. 4. Include the appropriate `roxygen2` tags
to import methods to use with the function like so:

``` r
#' @importFrom httr GET
foo <- function(url) {
  GET(url)
}
```

## Package Data

Package data is stored in the R user package cache (see
`tools::R_user_dir`). Each cornerstone publication operates under a
dedicated subdirectory within that. The structure is as follows:

    ├── .../gs.chainsearch/cache/
    │  ├── proxy_table.csv
    │  ├── proxy_blacklist.csv
    │  ├── <publication_id>
    │    ├── pages/
    │      ├── page1.html
    │      ├── page2.html
    │      ├── ...
    │    ├── meta_raw.csv
    │    ├── meta_final.csv

- `proxy_table.csv`: A table of proxy IPs. The table includes `ip`,
  `port`, and `active` (either TRUE or FALSE, indicating if the proxy is
  the current default\`.
- `proxy_blacklist.csv`: A table of proxy IPs that are marked as
  “blacklisted”, either manually via `blacklist_ip` or automatically via
  `save_gs_page(..., auto_cycle_ip = TRUE)`. The table includes `ip` and
  `mark_method` (either “manual” or “automatic”).
- `<publication_id>/`: Dedicated storage for a cornerstone publication.
- `pages/`: A subdirectory used as storage for raw HTML files that are
  scraped.
- `meta_raw.csv`: A table of raw metadata extracted from raw HTML pages.
- `meta_final.csv`: A table of processed metadata.

## Proxy

In order to help avoid IP bans when scraping Google Scholar, this
package leverages the public proxies provided by the API at
<https://geonode.com/free-proxy-list/>. It ignores any IPs that have not
passed their internal “google check”.

## Shiny App

This package includes a shiny interface accessible by running
`gs.chainsearch::app_run()`.

### Project Settings

Via the `Project Settings` interface, the user is able to select the
working directory (based on the cornerstone publication), browse project
progress, and manage project files.

### Proxy Settings

Via the `Proxy Settings` interface, the user is able to browse the
active proxy list, reload the proxy list with updated entries, and
blacklist individual proxies.
