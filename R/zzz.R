
#' @importFrom golem get_golem_name
package_disclaimer <- function() {
  paste0(
    "Methods provided by this package, including the shiny interface, ",
    "violate the robots exclusion standard for `scholar.google.com`",
    " ¯\\_(ツ)_/¯"
  )
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(package_disclaimer())
}
