
# LOGGING -----------------------------------------------------------------

make_log_text <- function(...) {
  lst <- lapply(list(...), function(x) paste0(x, collapse = ", "))
  paste0(unlist(lst), collapse = "")
}

#' @importFrom cli cli_alert_danger cli_alert_info cli_alert_success cli_alert_warning cli_h1 cli_verbatim
LOG_MSG <- function(..., type = c("default", "info", "success", "warning", "error", "title")) {
  type <- match.arg(type)
  msg <- make_log_text(...)
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

# POPUPS ------------------------------------------------------------------

#' @importFrom shinyalert shinyalert
popup_template <- function(
  title = "", text = "", type = "", easyClose = TRUE, showConfirm = TRUE,
  confirmText = "OK", timer = 0, callback = NULL, immediate = TRUE
) {
  shinyalert(
    title = title,
    text = as.character(text),
    type = type,
    closeOnEsc = easyClose,
    closeOnClickOutside = easyClose,
    showConfirmButton = showConfirm,
    confirmButtonText = confirmText,
    timer = timer,
    html = TRUE,
    callbackR = callback,
    immediate = immediate
  )
}

# Close a popup
#' @importFrom shinyalert closeAlert
popup_close <- function() {
  closeAlert()
}

# Info
popup_info <- function(..., title = "Heads up!") {
  msg <- make_log_text(...)
  popup_template(
    title = title,
    text = tags$p(style = "overflow-wrap: break-word;", msg),
    type = "info"
  )
}

# Loading
#' @importFrom waiter spin_throbber
popup_loading <- function(...) {
  msg <- make_log_text(...)
  popup_template(
    title = msg,
    text = spin_throbber(),
    easyClose = FALSE,
    showConfirm = FALSE
  )
}

# Success
popup_success <- function(..., title = "Success!", timer = NULL) {
  msg <- make_log_text(...)
  # Auto-assign timer if not specified
  if (is.null(timer)) timer <- 2000 + nchar(msg) * 15
  popup_template(
    title = title,
    text = tags$p(style = "overflow-wrap: break-word;", msg),
    type = "success",
    timer = timer
  )
}

# Fail
popup_fail <- function(..., title = "Whoops!") {
  msg <- make_log_text(...)
  popup_template(
    title = title,
    text = tags$p(style = "overflow-wrap: break-word;", msg),
    type = "error"
  )
}

# Error handler function
popup_error <- function(..., title = "Whoops!") {
  msg1 <- make_log_text(...)
  function(e) {
    msg2 <- conditionMessage(e)
    LOG_MSG(msg2, type = "error")
    msg <- msg1 %||% msg2
    popup_fail(msg, title = title)
  }
}

# TOAST -------------------------------------------------------------------

#' @importFrom bs4Dash toast
toast_template <- function(title, body = NULL, subtitle = NULL, icon = NULL) {
  toast(
    title = title,
    body = body,
    subtitle = subtitle,
    options = list(
      position = "bottomRight",
      fixed = "true",
      autohide = TRUE,
      delay = 5000,
      icon = icon
    )
  )
}

toast_info <- function(..., title = "Heads up!", subtitle = NULL) {
  msg <- make_log_text(...)
  toast_template(
    title = title,
    body = msg,
    subtitle = subtitle,
    icon = "fas fa-info"
  )
}

toast_success <- function(..., title = "Success!", subtitle = NULL) {
  msg <- make_log_text(...)
  toast_template(
    title = title,
    body = msg,
    subtitle = subtitle,
    icon = "fas fa-check"
  )
}

toast_warning <- function(..., title = "Heads up!", subtitle = NULL) {
  msg <- make_log_text(...)
  toast_template(
    title = title,
    body = msg,
    subtitle = subtitle,
    icon = "fas fa-warning"
  )
}

toast_error <- function(..., title = "Whoops!", subtitle = NULL) {
  msg <- make_log_text(...)
  toast_template(
    title = title,
    body = msg,
    subtitle = subtitle,
    icon = "fas fa-bug"
  )
}
