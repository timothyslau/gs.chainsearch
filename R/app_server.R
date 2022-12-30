
app_server <- function(input, output, session) {
  
  # Disclaimer
  popup_info(package_disclaimer())
  
  # Modules
  mod_session_server("session")
  mod_proxy_server("proxy")
  mod_scrape_server("scrape")
  mod_results_server("results")

}
