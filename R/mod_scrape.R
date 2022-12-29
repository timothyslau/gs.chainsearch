
# MAIN --------------------------------------------------------------------

mod_scrape_ui <- function(id) {
  ns <- NS(id)
  card_primary(
    title = "Scrape",
    icon = icon("magnifying-glass"),
    tags$p("TODO: Scrape"),
    footer = tagList(
      btn_primary(
        inputId = ns("btn_save"),
        label = "Save Settings",
        icon = icon("save")
      )
    )
  )
}

mod_scrape_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    
  })
}
