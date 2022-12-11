library(dplyr)
library(tidyverse)
library(readxl)
library(lubridate)
library(explore)
library(ggplot2)

rm(list = ls())

#setting working directory
setwd("C:/Users/estif/OneDrive/Documents/Data-331/Consumer-Complaints-Analysis/Consumer-Complaints-Analysis-main/data")

df_complaints <- read_csv("Consumer_Complaints.csv")
