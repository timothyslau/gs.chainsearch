
#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
#'
app_run <- function(
    onStart = NULL,
    options = list(),
    enableBookmarking = NULL,
    uiPattern = "/",
    ...
) {
  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = function() {
        LOG_MSG("Loading Application", type = "title")
        LOG_MSG("R_CONFIG_ACTIVE: ", app_config(), type = "info")
        if (!is.null(onStart)) onStart()
      },
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
