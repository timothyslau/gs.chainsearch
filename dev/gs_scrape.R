

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


# generate list of IP addresses for a proxy
proxy_list <- function(https=TRUE, google=TRUE) {
  https_flg <- ifelse(test = https == TRUE, yes = "yes", no = "no")
  google_flg <- ifelse(test = google == TRUE, yes = "yes", no = "no")
  url <- "https://free-proxy-list.net"
  html <- rvest::read_html(x = url)
  element <- rvest::html_element(x = html, xpath = '//*[@id="list"]/div/div[2]/div/table')
  table <- rvest::html_table(element)[,c(1,2,4,6,7,8)]
  colnames(table) <- c("ip", "port", "country", "google", "https", "last_checked")
  out <- subset(x = table, subset = (google == google_flg) & (https == https_flg))
  return(out)
}

proxy_list()


# generate list of user agents
ua_list <- function(){
  url = "https://developers.whatismybrowser.com/useragents/explore/hardware_type_specific/computer/"
  html <- rvest::read_html(url)
  element <- rvest::html_element(x = html, xpath = '//*[@id="content-base"]/section[2]/div/div/table')
  table <- rvest::html_table(element)[,c(1,2,4,5)]
  colnames(table) <- c("ua", "browser", "os", "pop")
  return(table)
}

ua_list()



# TEST - ((PASSING))
unit_test <- function(test="ua", proxy_ip, proxy_port, my_ua){
  if (test == "ua") {
    url <- "http://httpbin.org/user-agent"
  }
  else if (test == "ip") {
    url <- "https://httpbin.org/ip"
  }
  
  out <- httr::GET(
    url = url, 
    httr::user_agent(agent = my_ua),
    httr::use_proxy(url = proxy_ip, port = proxy_port),
    verbose()
  )
  
  return(cat(content(x = out, as = "text", encoding = "UTF-8")))
}

my_ua <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.2 Safari/605.1.15"

unit_test(
  test = "ua",
  my_ua = my_ua,
  proxy_ip = "190.61.88.147",
  proxy_port = 8080)

unit_test(
  test = "ip",
  my_ua = my_ua,
  proxy_ip = "190.61.88.147",
  proxy_port = 8080)




# SCRAPE WEBPAGES ---------------------------------------------------------

test_url <- url_list(second_pg_url = "https://scholar.google.com/scholar?start=20&hl=en&as_sdt=5,45&sciodt=0,45&as_yhi=2019&cites=10244671870114417611&scipsc=")[2]
test_proxy_ip <- proxy_list(https = T, google = T)$ip[2]
test_proxy_port <- proxy_list(https = T, google = T)$port[2]
test_ua <- ua_list()$ua[1]

save_wp <- function(dir=NA, encoding = "UTF-8", url, ip, port, ua){
  if (is.na(dir)) {dir <- getwd()}
  
  wp <- httr::GET(
    url = url,
    httr::user_agent(agent = ua),
    httr::use_proxy(url = ip, port = port),
    httr::verbose()
  )
  
  if (wp$status_code == 200) {
    file_nm <- paste0(unlist(strsplit(x = unlist(strsplit(x = url, split = "cites="))[2], split = "&scipsc=")), "-", as.numeric(unlist(regmatches(x = url, m = regexpr(pattern = "[[:digit:]]+", text = url)))), ".html")
    cat(httr::content(x = wp, as = "text", encoding = encoding), file = paste0(dir, "/", file_nm))  
  }
  else {
    message("Page Load Failure: Build a better function for handling this!")
  }
  
}

save_wp(dir = "/Users/laut/Downloads", url = test_url, ip = test_proxy_ip, port = test_proxy_port, ua = test_ua)

################################################################################
################################################################################
################################################################################
# cycle through the url_list until there's a non-200 status-code
# then cycle to the next proxy ip, port, and new ua keep this switching until the page is obtained
# then go the next page and repeat the above steps
################################################################################
################################################################################
################################################################################



# PROCESS WEBPAGES --------------------------------------------------------

unlist(mapply(FUN = function(x, times){rep(x = x, times = times)}, x = 1:4, times = 4:1, SIMPLIFY = TRUE))
rep(x = 1:4, times = 4:1)





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