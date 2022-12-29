
# CONFIG ------------------------------------------------------------------

#' @importFrom httr config
httr_config <- function() {
  config()
}

# FILESYSTEM --------------------------------------------------------------

# Proxy table
proxytab_file <- function() {
  storage_path("proxy_table.csv")
}
proxytab_read <- function() {
  file <- proxytab_file()
  if (file.exists(file)) read_csv(file)
}
proxytab_write <- function(x) {
  file <- proxytab_file()
  write_csv(x, file)
}
proxytab_set <- function(tab) {
  shinyOptions(GS_CHAINSEARCH_PROXYTAB = tab)
}
proxytab_get <- function() {
  getShinyOption("GS_CHAINSEARCH_PROXYTAB")
}

# Proxy blacklist
proxybl_file <- function() {
  storage_path("proxy_blacklist.csv")
}
proxybl_read <- function() {
  file <- proxybl_file()
  if (file.exists(file)) read_csv(file)
}
proxybl_write <- function(x) {
  file <- proxybl_file()
  write_csv(x, file)
}
proxybl_set <- function(tab) {
  shinyOptions(GS_CHAINSEARCH_PROXYBL = tab)
}
proxybl_get <- function() {
  getShinyOption("GS_CHAINSEARCH_PROXYBL")
}
proxybl_add <- function(ip, port, method) {
  tmp <- proxybl_get()
  tmp <- rbind(tmp, data.frame(ip = ip, port = port, method = method))
  proxybl_set(tmp)
  proxybl_write(tmp)
}
proxybl_remove <- function(ip, port) {
  tmp <- proxybl_get()
  i1 <- which(tmp$ip == ip)
  i2 <- which(tmp$port == port)
  row <- intersect(i1, i2)
  tmp <- tmp[-row, ]
  proxybl_set(tmp)
  proxybl_write(tmp)
}

# Active proxy
proxy_set <- function() {
  tmp <- proxylist_sample()
  LOG_MSG("Activating proxy: ", tmp$ip, ":", tmp$port)
  Sys.setenv(PROXY_IP = tmp$ip)
  Sys.setenv(PROXY_PORT = tmp$port)
}
proxy_get <- function() {
  list(
    ip = Sys.getenv("PROXY_IP"),
    port = Sys.getenv("PROXY_PORT")
  )
}

# API ---------------------------------------------------------------------

#' Refresh the Active Proxy Table.
#' 
#' Fetch a new proxy table via the API provided by Geonode (see
#'   https://geonode.com/free-proxy-list/) and update the proxy list used for
#'   scraping.
#' 
#' @param limit (Default 100) The maximum number of proxy entries to fetch. The
#'   larger this number, the longer evaluation will take. The number of entries
#'   actually returned may be less, depending on current availability.
#'   
refresh_proxy_table <- function(limit = 100) {
  # Fetch new table
  tab <- fetch_proxy_table(limit)
  # Remove blacklisted entries
  tab <- filter_proxy_table(tab)
  # Update active proxylist
  proxytab_set(tab)
  proxytab_write(tab)
}

#' Blacklist a Proxy.
#' 
#' Blacklist an individual proxy.
#' 
blacklist_proxy <- function(ip, port, method = c("manual", "automatic")) {
  method <- match.arg(method)
  # Add proxy to blacklist
  proxybl_add(ip, port, method)
  # Filter proxy table
  tmp <- proxytab_get()
  tmp <- filter_proxy_table(tmp)
  proxytab_set(tmp)
  proxytab_write(tmp)
  # Set new proxy
  # This guarantees that the blacklisted proxy is de-activated
  proxy_set()
}

#' Whitelist a Proxy.
#' 
#' Whitelist an individual proxy.
#' 
whitelist_proxy <- function(ip, port) {
  # Remove proxy from blacklist
  proxybl_remove(ip, port)
  # Filter proxy table
  tmp <- proxytab_get()
  tmp <- filter_proxy_table(tmp)
  proxytab_set(tmp)
  proxytab_write(tmp)
}

# UTILS -------------------------------------------------------------------

# Fetch the proxy table
#' @importFrom httr content GET modify_url
fetch_proxy_table <- function(limit) {
  # Fetch proxy table
  url <- proxy_table_url(limit)
  res <- GET(url)
  # Wrangle into data frame
  tmp <- content(res)
  tmp <- lapply(tmp$data, unlist)
  tmp <- Reduce(rbind, tmp)
  # Apply classes
  tmp <- data.frame(tmp)
  tmp$latency <- as.numeric(tmp$latency)
  tmp$upTime <- as.numeric(tmp$upTime)
  return(tmp)
}

#' @importFrom httr modify_url
proxy_table_url <- function(limit) {
  modify_url(
    url = "https://proxylist.geonode.com/api/proxy-list",
    query  = list(
      limit = limit,
      page = 1,
      speed = "fast",
      sort_by = "latency",
      sort_type = "asc",
      google = "true"
    )
  )
}

# Filter blacklisted entries from proxy table
filter_proxy_table <- function(tab) {
  blacklist <- proxybl_get()
  i1 <- which(tab$ip %in% blacklist$ip)
  i2 <- which(tab$port %in% blacklist$port)
  omit <- intersect(i1, i2)
  if (length(omit) > 0) {
    LOG_MSG("Removing ", length(omit), " blacklisted proxies.")
    tab <- tab[-omit, ]
  }
  return(tab)
}

# Sample random proxy from proxy table
proxylist_sample <- function() {
  tmp <- proxytab_get()
  row <- sample(nrow(tmp), 1)
  list(
    ip = tmp$ip[row],
    port = tmp$port[row]
  )
}

# UI ----------------------------------------------------------------------

dt_proxytab <- function(tab) {
  dt_minimal(
    data = tab[,c("ip", "port", "city", "country", "latency", "upTime")],
    colnames = c("IP", "Port", "City", "Country", "Latency (ms)", "Uptime")
  )
}

dt_proxybl <- function(tab) {
  dt_minimal(
    data = tab[,c("ip", "port", "method")],
    colnames = c("IP", "Port", "Method")
  )
}