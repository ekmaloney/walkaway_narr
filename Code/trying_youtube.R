library(tidyverse)
library(youtubecaption)
library(rvest)
library(here)
library(xml2)

# Let's get the video caption out of Hadley Wickham's "You can't do data science in a GUI":
url <- "https://www.youtube.com/watch?v=MhPbO7CoBF8&list=PLjbi7adhMoizwZTWPCAb2ELVNaFLzx79b&index=1"
caption <- get_caption(url)
caption

yt_links <- read_csv(here("Data/yt_links.csv"))

test <- map_df(yt_links$Url, get_caption)

sos <- test %>% 
       select(text, vid) %>% 
       nest(data = c(text)) %>% 
       mutate(text = map(data, unlist), 
       text = map_chr(text, paste, collapse = " "))

yt_data <- yt_links%>% 
           mutate(vid = str_split(Url, "watch", simplify = TRUE)[,2],
                  vid = str_remove_all(vid, "\\?v=")) %>% 
           left_join(sos, by = "vid")
  
  
  