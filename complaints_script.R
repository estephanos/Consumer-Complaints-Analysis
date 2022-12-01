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

complaints = df_complaints$`Consumer complaint narrative`

sentiment = analyzeSentiment(complaints)
