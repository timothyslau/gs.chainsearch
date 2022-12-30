
# MAIN --------------------------------------------------------------------

mod_results_ui <- function(id) {
  ns <- NS(id)
  card_primary(
    title = "Results",
    icon = icon("table-list"),
    tags$p("TODO: Results"),
    footer = tagList(
      btn_primary(
        inputId = ns("btn_save"),
        label = "Save Settings",
        icon = icon("save")
      )
    )
  )
}

mod_results_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    
  })
}
