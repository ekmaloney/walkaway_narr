library(tidyverse)
library(tidytext)
library(ggplot2)
library(here)
library(janitor)


full_sample <- readRDS(here("Data/ct_data.RDS"))

full_sample <- full_sample %>% 
              select(id, date, message) %>% 
              mutate(walkwith = if_else(str_detect(message, "walkwith"), 1, 0),
                     length = nchar(message)) %>% 
              filter(walkwith == 0 & length > 500)

sample_ids <- sample(full_sample$id, 100, replace = FALSE)           

new_sample <- full_sample %>% 
              filter(id %in% sample_ids) %>% 
              select(id, message)

write_excel_csv(new_sample, file = here("Data/new_sample.csv"))
