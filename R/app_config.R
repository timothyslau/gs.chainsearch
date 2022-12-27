#' Access files in the current app
#'
#' NOTE: If you manually change your package name in the DESCRIPTION,
#' don't forget to change it here too, and in the config file.
#' For a safer name change mechanism, use the `golem::set_golem_name()` function.
#'
#' @param ... character vectors, specifying subdirectory and file(s)
#' within your package. The default, none, returns the root of the app.
#'
#' @noRd
app_sys <- function(...) {
  system.file(..., package = "gs.chainsearch")
}

# Read app config
#' @importFrom config get
app_config_get <- function(value = NULL) {
  get(
    value = value,
    config = app_config(),
    file = app_sys("golem-config.yml"),
    use_parent = FALSE
  )
}

app_config <- function() {
  Sys.getenv("R_CONFIG_ACTIVE", "default")
}

#' @importFrom golem get_golem_name get_golem_version
app_title <- function() {
  paste0(get_golem_name(), " (v", get_golem_version(), ")")
}
