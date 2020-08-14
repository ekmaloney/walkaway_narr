library(jsonlite)
library(httr)
library(tidyverse)

#crowdtangle information
token <- "08IJNPuOnAZoTZ7l8CxIBip7XbHc9VNNL09K5BXC"
baseurl <- "https://api.crowdtangle.com/posts/"
listid <- "1427297"

#making the api url
new_url <- paste(baseurl, "?token=", token, sep = "")
final_url <- paste(new_url, "sortBy=Date", "includeHistory=True", "count=100",
                   sep = "&")

#function to update the url with the new end dates
new_url <- function(last_date){
  last_date <- str_replace(last_date, " ", "T")
  url_new_date <- paste(final_url, last_date, sep = "&endDate=")
  return(url_new_date)
}

#function to actually get the data and wrangle it into a better format
pull_data <- function(search_url) {
  request <- GET(url = search_url)
  response <- content(request, as = "text", encoding = "UTF-8")
  df <- fromJSON(response, flatten = TRUE) %>% bind_rows()
  df_out <- df[[2]][[1]]
  return(df_out)
}

initial_search <- pull_data(final_url)
ct_data <- initial_search

for(i in 1:300) {
  earliest_date <- ct_data %>% filter(date == min(date)) %>% select(date)
  n_url <- new_url(earliest_date$date)
  new_data <- pull_data(n_url)
  ct_data <- bind_rows(ct_data, new_data)
  Sys.sleep(30)
}

 