
# MAIN --------------------------------------------------------------------

mod_session_ui <- function(id) {
  ns <- NS(id)
  card_primary(
    title = "Session Settings",
    icon = icon("folder-tree"),
    tags$p("TODO: Project settings"),
    footer = tagList(
      btn_primary(
        inputId = ns("btn_save"),
        label = "Save Settings",
        icon = icon("save")
      )
    )
  )
}

mod_session_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    
  })
}
