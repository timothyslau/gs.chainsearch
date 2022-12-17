

# LOAD PACKAGES -----------------------------------------------------------


# LOAD WEBPAGE ------------------------------------------------------------

# generate list of webpages
# blank - 2019 (920 results)
url_list <- function(second_pg_url, from=0, to=900, by=20){
  return(lapply(X = seq(from = from, to = to, by = by), FUN = function(i){gsub(pattern = "start=\\d\\d", replacement = paste0("start=", i), x = second_pg_url)}))
}

url_list(
  second_pg_url = "https://scholar.google.com/scholar?start=20&hl=en&as_sdt=5,45&sciodt=0,45&as_yhi=2019&cites=10244671870114417611&scipsc="
  )




# save webpages
save_html <- function(url, pause = 0.5, backoff = FALSE){
  t0 <- Sys.time()
  pause <- pause * stats::runif(n = 1, min = 0.5, max = 1.5)
  
  #initiate scrape and detect redirect
  html <- RCurl::getURL(url, followlocation=TRUE, .opts=list(useragent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.2 Safari/605.1.15"))
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
https://github.com/nealhaddaway/GSscraper

# Google Scholar
# - truncates result sets to 1,000
# - IP bans your for web scraping (after how many; 500?)
# -- randomize IP address/ user agent?
#   - uses a different URL structure for "Cited by" results
# -- https://scholar.google.com/scholar?cites=10244671870114417611&as_sdt=5,45&sciodt=0,45&hl=en
# - limits page results to 20 per page
# - doesn't provide consistent results per page (e.g. 200-220, 220-238, 239-259)
