gs.chainsearch
================

![Current Version](https://img.shields.io/badge/version-0.0.1-blue)
![GitHub
stars](https://img.shields.io/github/stars/timothyslau/gs.chainsearch?style=social)
![GitHub
forks](https://img.shields.io/github/forks/timothyslau/gs.chainsearch?style=social)

This package provides methods to perform a forward chaining search via
Google Scholar, i.e., scrape publications that cite a cornerstone
publication via the “Cited By” search feature. The primary purpose of
this package is to enable researchers to produce comprehensive
literature reviews.

The general strategy is as follows:

1.  Select a working directory within your filesystem.
2.  Identify a cornerstone publication.
3.  Select a list of proxies to cycle through.
4.  Scrape search results and save raw html to working directory.
5.  Parse publication details from raw html.
6.  De-duplicate publication details.

## Contributing

To setup the development environment:

1. `git pull` the code (FYI only the `main` branch is being used for now).
2. Open `gs.chainsearch.Rproj` to open the R project. This will trigger `.Rprofile` which automatically handles some of the development setup.
3. `renv` is used to manage dependencies. When the R project is loaded, this should install itself and warn you if there are any package conflicts. Do `renv::restore()` to restore the package library.
4. **IMPORTANT**: Standalone scripts should be saved within the `dev/` directory. This directory is ignored when the package is built and the code there will not be evaluated.
5. To build the package and run the application, do `golem::run_dev()`.

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
