
# CONFIG ------------------------------------------------------------------

#' @importFrom httr config
httr_config <- function() {
  config()
}

# FILESYSTEM --------------------------------------------------------------

# Proxy table
proxytab_file <- function() {
  project_path("proxytab")
}
proxytab_read <- function() {
  file <- proxytab_file()
  if (file.exists(file)) readRDS(file)
}
proxytab_write <- function(x) {
  file <- proxytab_file()
  saveRDS(x, file)
}

# Proxy blacklist
proxybl_file <- function() {
  project_path("proxybl")
}

proxybl_read <- function() {
  file <- proxybl_file()
  if (file.exists(file)) readRDS(file)
}

proxybl_write <- function(x) {
  file <- proxybl_file()
  saveRDS(x, file)
}

# API ---------------------------------------------------------------------

# Wrapper function to handle reading proxy table
#' @importFrom httr content GET modify_url
proxytab_make <- function() {
  res <- proxytab_get()
  tmp <- content(res)
  tmp <- lapply(tmp$data, unlist)
  tmp <- Reduce(rbind, tmp)
  tmp <- data.frame(tmp)
  tmp <- data.frame(
    ip = as.character(tmp$ip),
    port = as.numeric(tmp$port),
    city = as.character(tmp$city),
    country = as.character(tmp$country),
    latency = round(as.numeric(tmp$latency), 2),
    upTime = round(as.numeric(tmp$upTime), 2)
  )
  tmp_sort <- order(tmp$latency)
  tmp[tmp_sort, ]
}

# Fetch proxy table
# Reference: https://geonode.com/free-proxy-list/
#' @importFrom httr GET modify_url
proxytab_get <- function() {
  url <- modify_url(
    url = "https://proxylist.geonode.com/api/proxy-list",
    query  = list(
      limit = 50,
      page = 1,
      speed = "fast",
      sort_by = "latency",
      sort_type = "asc",
      google = "true"
    )
  )
  GET(url)
}

# UI ----------------------------------------------------------------------

dt_proxytab <- function(tab) {
  dt_minimal(
    data = tab[,c("ip", "port", "city", "country", "latency", "upTime")],
    colnames = c("IP", "Port", "City", "Country", "Latency (ms)", "Uptime")
  )
}
