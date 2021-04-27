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

yt_transcripts <- read_csv(here("Data/yt_transcripts.csv"))

collapsed_text <- aggregate(text ~ videoid, data = yt_transcripts, FUN = paste, collapse = "")

write_csv(collapsed_text, file = here("Data/yt_transcript_collapsed.csv"))
  
  
first_100 <- collapsed_text %>% slice(1:100)
write_csv(first_100, file = here("Data/yt_first_100.csv"))
