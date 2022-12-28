
# TEST FILE FOR IMPLEMENTING GEONODE API
# THIS DOESN'T WORK UNLESS YOU PURCHASE A PLAN :(

library(httr)

# These environment variables should be provided in `.Renviron`
user <- Sys.getenv("GEONODE_USER")
pass <- Sys.getenv("GEONODE_PASS")
dns <- Sys.getenv("GEONODE_DNS")
port <- as.numeric(Sys.getenv("GEONODE_PORT"))

proxy_url <- paste0("http://", user, ":", pass, "@", dns)

resp <- GET(
  url = "http://ip-api.com/json",
  config = use_proxy(proxy_url)
)

content(resp)
