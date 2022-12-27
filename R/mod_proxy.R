
# MAIN --------------------------------------------------------------------

mod_proxy_ui <- function(id) {
  ns <- NS(id)
  tagList(
    mod_proxy_table_ui(ns("table")),
    mod_proxy_blacklist_ui(ns("blacklist"))
  )
}

mod_proxy_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    mod_proxy_table_server("table")
    mod_proxy_blacklist_server("blacklist")
    
  })
}

# PROXY TABLE -------------------------------------------------------------

#' @importFrom DT DTOutput
#' @importFrom shinyjs disabled
mod_proxy_table_ui <- function(id) {
  ns <- NS(id)
  card_primary(
    title = "Proxy Table",
    icon = icon("table"),
    DTOutput(ns("dt_proxytab")),
    footer = tagList(
      btn_primary(
        inputId = ns("btn_reload"),
        label = "Reload Proxy Table",
        icon = icon("sync")
      ),
      disabled(btn_primary(
        inputId = ns("btn_blacklist"),
        label = "Blacklist Selected Proxy",
        icon = icon("cancel")
      ))
    )
  )
}

#' @importFrom DT renderDT
mod_proxy_table_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Proxy table
    rv_proxytab <- reactiveVal(proxytab_read())
    output$dt_proxytab <- renderDT(dt_proxytab(rv_proxytab()))
    selected_row <- reactive(input$dt_proxytab_rows_selected)
    
    # Proxy blacklist
    rv_proxybl <- reactiveVal(proxybl_read())
    
    # Toggle UI
    bind_state("btn_blacklist", selected_row)
    
    # Reload proxy table
    observeEvent(input$btn_reload, {
      tryCatch(
        expr = {
          popup_loading("Reloading proxy table...")
          tmp <- proxytab_make()
          proxytab_write(tmp)
          rv_proxytab(tmp)
          popup_success("Proxy table updated!")
        },
        error = popup_error
      )
    })
    
    # Blacklist proxy
    observeEvent(input$btn_blacklist, {
      tryCatch(
        expr = {
          popup_loading("Blacklisting proxy...")
          # Selected proxy
          df <- rv_proxytab()
          row <- as.list(df[selected_row(), ])
          # Add to blacklist
          tmp1 <- rv_proxybl()
          tmp1 <- rbind(tmp1, row)
          proxybl_write(tmp1)
          rv_proxybl(tmp1)
          # Remove from table
          tmp2 <- df[-selected_row(), ]
          proxytab_write(tmp2)
          rv_proxytab(tmp2)
          popup_success("Proxy blacklisted!")
        },
        error = popup_error
      )
    })
    
  })
}

# PROXY BLACKLIST ---------------------------------------------------------

#' @importFrom DT DTOutput
#' @importFrom shinyjs disabled
mod_proxy_blacklist_ui <- function(id) {
  ns <- NS(id)
  card_primary(
    title = "Proxy Blacklist",
    icon = icon("cancel"),
    DTOutput(ns("dt_proxytab")),
    footer = tagList(
      disabled(btn_primary(
        inputId = ns("btn_whitelist"),
        label = "Whitelist Selected Proxy",
        icon = icon("check")
      ))
    )
  )
}

#' @importFrom DT renderDT
mod_proxy_blacklist_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Proxy table
    rv_proxytab <- reactiveVal(proxybl_read())
    output$dt_proxytab <- renderDT(dt_proxytab(rv_proxytab()))
    selected_row <- reactive(input$dt_proxytab_rows_selected)
    
    # Toggle UI
    bind_state("btn_whitelist", selected_row)
    
    # Whitelist proxy
    observeEvent(input$btn_whitelist, {
      df <- rv_proxytab()
      row <- df[selected_row(), ]
      print(as.list(row))
      
      browser()
      
    })
    
  })
}
