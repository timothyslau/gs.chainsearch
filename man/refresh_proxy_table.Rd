% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/proxy.R
\name{refresh_proxy_table}
\alias{refresh_proxy_table}
\title{Refresh the Active Proxy Table.}
\usage{
refresh_proxy_table(limit = 100)
}
\arguments{
\item{limit}{(Default 100) The maximum number of proxy entries to fetch. The
larger this number, the longer evaluation will take. The number of entries
actually returned may be less, depending on current availability.}
}
\description{
Fetch a new proxy table via the API provided by Geonode (see
  https://geonode.com/free-proxy-list/) and update the proxy list used for
  scraping.
}
