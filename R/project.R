
#' @importFrom golem get_golem_name
#' @importFrom tools R_user_dir
project_home <- function() {
  R_user_dir(package = get_golem_name(), which = "cache")
}

#' @importFrom fs dir_create
#' @importFrom httr reset_config
project_onStart <- function() {
  reset_config()
  home <- project_home()
  dir_create(home)
  LOG_MSG("PROJECT_HOME: ", home, type = "info")
}

#' @importFrom fs path
project_path <- function(...) {
  path(project_home(), ...)
}

project_config_file <- function() {
  project_path("config.yaml")
}

#' @importFrom config get
project_config_get <- function(value = NULL) {
  get(
    value = value,
    config = app_config(),
    file = project_config_file(),
    use_parent = FALSE
  )
}

#' @importFrom yaml write_yaml
#' @importFrom config merge
project_config_set <- function(key, value) {
  lst1 <- setNames(list(value), key)
  lst2 <- setNames(list(lst1), app_config())
  lst3 <- project_config_get()
  lst4 <- merge(lst3, lst2)
  file <- project_config_file()
  write_yaml(lst4, file)
}
