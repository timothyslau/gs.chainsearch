
#' @importFrom bs4Dash bs4DashPage
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    bs4DashPage(
      header = app_header(),
      sidebar = app_sidebar(),
      body = app_body(),
      controlbar = app_controlbar(),
      footer = app_footer(),
      title = app_title(),
      preloader = app_waiter_opts(),
      fullscreen = TRUE,
      help = FALSE,
      dark = NULL,
      scrollToTop = TRUE
    )
  )
}

#' @importFrom bs4Dash bs4DashBrand bs4DashNavbar
#' @importFrom golem get_golem_name
app_header <- function() {
  bs4DashNavbar(
    title = bs4DashBrand(
      title = app_title(),
      color = "primary",
      href = app_config_get("app_github"),
      image = "https://picsum.photos/200",
      opacity = 1
    ),
    status = "primary"
  )
}

#' @importFrom bs4Dash bs4SidebarMenu bs4SidebarMenuItem bs4DashSidebar
app_sidebar <- function() {
  bs4DashSidebar(
    skin = "light",
    status = "primary",
    elevation = 5,
    collapsed = FALSE,
    minified = TRUE,
    expandOnHover = TRUE,
    fixed = TRUE,
    id = "sidebar",
    customArea = NULL,
    bs4SidebarMenu(
      id = "tab",
      bs4SidebarMenuItem(
        text = "Session Settings",
        icon = icon("folder-tree"),
        # badgeLabel = NULL,
        # badgeColor = "success",
        tabName = "session"
      ),
      bs4SidebarMenuItem(
        text = "Proxy Settings",
        icon = icon("network-wired"),
        # badgeLabel = NULL,
        # badgeColor = "success",
        tabName = "proxy"
      ),
      bs4SidebarMenuItem(
        text = "Scrape",
        icon = icon("magnifying-glass"),
        # badgeLabel = NULL,
        # badgeColor = "success",
        tabName = "scrape"
      ),
      bs4SidebarMenuItem(
        text = "Results",
        icon = icon("table-list"),
        # badgeLabel = NULL,
        # badgeColor = "success",
        tabName = "results"
      )
    )
  )
}

#' @importFrom bs4Dash bs4DashBody tabItem tabItems
app_body <- function() {
  bs4DashBody(
    tabItems(
      tabItem(
        tabName = "session",
        mod_session_ui("session")
      ),
      tabItem(
        tabName = "proxy",
        mod_proxy_ui("proxy")
      ),
      tabItem(
        tabName = "scrape",
        mod_scrape_ui("scrape")
      ),
      tabItem(
        tabName = "results",
        mod_results_ui("results")
      )
    )
  )
}

#' @importFrom bs4Dash bs4DashControlbar
app_controlbar <- function() {
  bs4DashControlbar(
    id = "controlbar",
    collapsed = TRUE,
    overlay = TRUE,
    skin = "light"
  )
}

#' @importFrom bs4Dash bs4DashFooter
app_footer <- function() {
  bs4DashFooter("FOOTER")
}

#' @importFrom waiter bs4_spinner
app_waiter_opts <- function() {
  # list(
  #   html = tags$div(
  #     tags$h1("Loading gs.chainsearch..."),
  #     bs4_spinner()
  #   ),
  #   color = "primary"
  # )
}

# Add external resources
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @importFrom shinyjs useShinyjs
#' @importFrom waiter useWaiter
golem_add_external_resources <- function() {
  add_resource_path("www", app_sys("app/www"))
  tags$head(
    favicon(),
    bundle_resources(path = app_sys("app/www"), app_title = app_config_get("app_title")),
    useShinyjs(),
    useWaiter(),
    # Initialize working session
    session_init()
  )
}
