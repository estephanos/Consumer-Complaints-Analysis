library(dplyr)
library(tidyverse)
library(readxl)
library(lubridate)
library(explore)
library(ggplot2)
library(SentimentAnalysis)
rm(list = ls())

#setting working directory
setwd("C:/Users/estif/OneDrive/Documents/Data-331/Final Project/data")

df_complaints <- read_csv("Consumer_Complaints.csv")

complaints$ZIP.code <- as.numeric(complaints$ZIP.code)
complaints$Consumer.consent.provided. <- ifelse(complaints$Consumer.consent.provided. == "", "N/A",complaints$Consumer.consent.provided.)
complaints$Sub.product <- ifelse(complaints$Sub.product == "", "N/A",complaints$Sub.product)
complaints$Sub.issue<- ifelse(complaints$Sub.issue == "", "N/A",complaints$Sub.issue)
complaints$Consumer.complaint.narrative <- ifelse(complaints$Consumer.complaint.narrative == "", "N/A",complaints$Consumer.complaint.narrative)
complaints$Company.public.response <- ifelse(complaints$Company.public.response == "", "N/A",complaints$Company.public.response)
complaints$Tags<- ifelse(complaints$Tags == "", "N/A",complaints$Tags)
complaints$Consumer.disputed.<- ifelse(complaints$Consumer.disputed. == "", "N/A",complaints$Consumer.disputed.)

complaint_count <- complaints %>%
  count(Product)

ggplot(data = complaint_count, aes(x=Product, y=n))+
         geom_bar(stat = "identity")+
  coord_flip()

complaints = df_complaints$`Consumer complaint narrative`

sentiment = analyzeSentiment(complaints)
