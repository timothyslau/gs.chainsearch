
# Create an observer to toggle DOM based on truthiness of a reactive expression
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
