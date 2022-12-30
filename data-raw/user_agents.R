
library(rvest)
library(xml2)

url <- "https://developers.whatismybrowser.com/useragents/explore/hardware_type_specific/computer/"
tmp <- read_html(url)
xpath <- "//*[@id='content-base']/section[2]/div/div/table"
tab_raw <- html_element(tmp, xpath = xpath)
tab <- html_table(tab_raw)
user_agents <- tab[[1]]

usethis::use_data(user_agents, overwrite = TRUE)
