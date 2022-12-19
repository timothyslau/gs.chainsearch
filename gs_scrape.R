

# LOAD PACKAGES -----------------------------------------------------------
library(httr)
library(rvest)

# LOAD WEBPAGE ------------------------------------------------------------

# search blank - 2019 second page (920 results)
"https://scholar.google.com/scholar?start=20&hl=en&as_sdt=5,45&sciodt=0,45&as_yhi=2019&cites=10244671870114417611&scipsc="

# 2019 - blank second page (824 results)
"https://scholar.google.com/scholar?start=20&hl=en&as_sdt=5,45&sciodt=0,45&as_ylo=2019&cites=10244671870114417611&scipsc="


# generate list of webpages
url_list <- function(second_pg_url, from=0, to=900, by=20){
  try(if (!by %in% c(10, 20)) stop("`by` kwarg must be equal to either 10 or 20"))
  sapply(
    X = seq(from = from, to = to, by = by), 
    FUN = function(i){gsub(pattern = "start=\\d\\d", replacement = paste0("start=", i), x = second_pg_url)})
  }

url_list(second_pg_url = "https://scholar.google.com/scholar?start=20&hl=en&as_sdt=5,45&sciodt=0,45&as_yhi=2019&cites=10244671870114417611&scipsc=")


# generate list of IP addresses for a redirect
proxy_list <- function(limit=50) {
  url <- httr::modify_url(
    url = "https://proxylist.geonode.com/api/proxy-list", # url = "http://www.hidemyass.com/proxy-list",
    query  = list(
      limit = limit,
      page = 1,
      speed = "fast",
      sort_by = "responseTime",
      sort_type = "asc",
      google = "true"
    )
  )
  res <- httr::GET(url)
  tmp1 <- httr::content(res)
  tmp2 <- Reduce(rbind, tmp1$data)
  return(data.frame(tmp2, row.names = NULL))
}

proxy_list()[,c("ip", "port")]


# generate list of user agents
ua_list <- function(){
  url = "https://developers.whatismybrowser.com/useragents/explore/hardware_type_specific/computer/"
  html <- rvest::read_html(url)
  element <- rvest::html_element(x = html, xpath = '//*[@id="content-base"]/section[2]/div/div/table')
  table <- rvest::html_table(element)[,c(1,2,4,5)]
  colnames(table) <- c("ua", "browser", "os", "pop")
  return(table)
}

ua_list()[,"ua"]

my_ua <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.2 Safari/605.1.15"

# verified that UA is being changed
rvest::session(url = "https://httpbin.org/user-agent", httr::user_agent(my_ua))$response$request$options$useragent





httr::set_config(config = httr::use_proxy(url = "url", port = "port"))


# save webpages
save_html <- function(url, pause = 0.5, backoff = FALSE){
  t0 <- Sys.time()
  pause <- pause * stats::runif(n = 1, min = 0.5, max = 1.5)
  
  #initiate scrape and detect redirect
  html <- RCurl::getURL(url, followlocation=TRUE, .opts=list(useragent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.2 Safari/605.1.15", "Cache-Control"="no-cache"))
  names(html) <- url
  
  t1 <- Sys.time()
  response_delay <- round(as.numeric(t1-t0), 3)
  if(backoff == TRUE){
    #  message(paste('Saved in',
    #                round(response_delay, 3),
    #              'seconds. Waiting',
    #              round(pause*response_delay, 3),
    #              'seconds...'))
    Sys.sleep(pause*response_delay)
  } else {
    #  message(paste('Saved in',
    #                round(response_delay, 3),
    #              'second. Waiting',
    #              round(pause, 3),
    #             'seconds...'))
    Sys.sleep(pause)
  }
  
  return(html)
  
}

# SCRAPE WEBPAGE ----------------------------------------------------------


# NOTES -------------------------------------------------------------------
# other efforts
# https://github.com/nealhaddaway/GSscraper

# Google Scholar
# - truncates result sets to 1,000
# - IP bans your for web scraping (after how many; 500?)
# -- randomize IP address/ user agent?
#   - uses a different URL structure for "Cited by" results
# -- https://scholar.google.com/scholar?cites=10244671870114417611&as_sdt=5,45&sciodt=0,45&hl=en
# - limits page results to 20 per page
# - doesn't provide consistent results per page (e.g. 200-220, 220-238, 239-259)
