
# MAIN --------------------------------------------------------------------

mod_project_ui <- function(id) {
  ns <- NS(id)
  card_primary(
    title = "Project Settings",
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

mod_project_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    
  })
}
