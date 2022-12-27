
# SERVER ------------------------------------------------------------------

#' @importFrom shinyjs toggleState
bind_state <- function(id, condition, invert = FALSE, asis = FALSE) {
  rx1 <- reactive(isTruthy(condition()))
  rx2 <- reactive(ifelse(invert, !rx1(), rx1()))
  observe({
    for (idx in id) {
      toggleState(id = idx, condition = rx2(), asis = asis)
    }
  })
}

# INTERNAL ----------------------------------------------------------------

#' @importFrom cli cli_alert_danger cli_alert_info cli_alert_success cli_alert_warning cli_h1 cli_verbatim
LOG_MSG <- function(..., type = c("default", "info", "success", "warning", "error", "title")) {
  type <- match.arg(type)
  msg <- paste0(..., collapse = "")
  switch(
    EXPR = type,
    default = cli_verbatim(msg),
    info = cli_alert_info(msg),
    success = cli_alert_success(msg),
    warning = cli_alert_warning(msg),
    error = cli_alert_danger(msg),
    title = cli_h1(msg)
  )
}
