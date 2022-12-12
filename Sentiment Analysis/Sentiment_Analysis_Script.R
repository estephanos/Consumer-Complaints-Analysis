library(tidyverse)
library(lubridate)
library(dplyr)
library(readxl)
library(ggplot2)
library(tidytext)
library(SentimentAnalysis)

rm(list = ls())
setwd("~/Documents/Consumer-Complaints-Analysis/data")
complaints <- read.csv("Consumer_Complaints.csv")

#Clean Data - Making blank cells to N/A and making zip code numeric
complaints$ZIP.code <- as.numeric(complaints$ZIP.code)
complaints$Consumer.consent.provided. <- ifelse(complaints$Consumer.consent.provided. == "", "N/A",complaints$Consumer.consent.provided.)
complaints$Sub.product <- ifelse(complaints$Sub.product == "", "N/A",complaints$Sub.product)
complaints$Sub.issue<- ifelse(complaints$Sub.issue == "", "N/A",complaints$Sub.issue)
complaints$Consumer.complaint.narrative <- ifelse(complaints$Consumer.complaint.narrative == "", "N/A",complaints$Consumer.complaint.narrative)
complaints$Company.public.response <- ifelse(complaints$Company.public.response == "", "N/A",complaints$Company.public.response)
complaints$Tags<- ifelse(complaints$Tags == "", "N/A",complaints$Tags)
complaints$Consumer.disputed.<- ifelse(complaints$Consumer.disputed. == "", "N/A",complaints$Consumer.disputed.)

undesirable_words <- c("ooh", "uurh", " xxxx ", " uh ", "uh", "ah")

complaint_tidy <- complaints %>%
  unnest_tokens(word, Consumer.complaint.narrative) %>% #Break the narrative into individual words
  filter(!word %in% undesirable_words) %>% #Remove undesirables
  filter(!nchar(word) < 3) %>% #Words like "ah" or "oo" used in music
  anti_join(stop_words) #Data provided by the tidytext package

complaint_nrc <- complaint_tidy %>%
  inner_join(get_sentiments("nrc"))

nrc_plot <- complaint_nrc %>%
  group_by(sentiment) %>%
  summarise(word_count = n()) %>%
  ungroup() %>%
  mutate(sentiment = reorder(sentiment, word_count)) %>%
  #Use `fill = -word_count` to make the larger bars darker
  ggplot(aes(sentiment, word_count, fill = -word_count)) +
  geom_col() +
  guides(fill = "none") + #Turn off the legend
  labs(x = NULL, y = "Word Count") +
  #  scale_y_continuous(limits = c(0, 500000)) + #Hard code the axis limit
  ggtitle("Consumer Narrative NRC Sentiment") +
  coord_flip()
plot(nrc_plot)

complaint_bing <- complaint_tidy %>%
  inner_join(get_sentiments("bing"))

bing_plot <- complaint_bing %>%
  group_by(sentiment) %>%
  summarise(word_count = n()) %>%
  ungroup() %>%
  mutate(sentiment = reorder(sentiment, word_count)) %>%
  ggplot(aes(sentiment, word_count, fill = sentiment)) +
  geom_col() +
  guides(fill = "none") +
  labs(x = NULL, y = "Word Count") +
  #  scale_y_continuous(limits = c(0, 8000)) +
  ggtitle("Complaint Bing Sentiment") +
  coord_flip()
plot(bing_plot)



