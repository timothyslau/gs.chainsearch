
#' @importFrom bs4Dash actionButton
btn_primary <- function(inputId, label = NULL, icon = NULL) {
  actionButton(
    inputId = inputId,
    label = label,
    icon = icon,
    status = "primary"
  )
}

#' @importFrom bs4Dash bs4Card
card_primary <- function(title, ..., width = NULL, icon = NULL, footer = NULL) {
  bs4Card(
    title = title,
    width = width,
    status = "primary",
    icon = icon,
    ...,
    footer = footer
  )
}

#' @importFrom DT datatable formatRound
dt_minimal <- function(data, colnames) {
  datatable(
    data = data,
    rownames = NULL,
    colnames = colnames,
    class = "display",
    options = list(),
    escape = TRUE,
    style = "bootstrap4",
    width = NULL,
    height = NULL,
    elementId = NULL,
    selection = list(mode = "single", target = "row")
  ) |>
    formatRound(columns = which(sapply(data, is.numeric)), digits = 2)
}
