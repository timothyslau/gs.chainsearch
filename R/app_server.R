
app_server <- function(input, output, session) {
  
  # Disclaimer
  popup_info(package_disclaimer())
  
  mod_project_server("project")
  mod_proxy_server("proxy")

}
