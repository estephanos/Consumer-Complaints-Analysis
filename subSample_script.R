library(randomForest)
library(dplyr)
library(tidyverse)
library(readxl)
library(lubridate)
library(caret)
library(CatEncoders)
library(explore)
library(rfUtilities)
library(ggplot2)

rm(list = ls())

#setting working directory
setwd("C:/Users/estif/OneDrive/Documents/Data-331/Consumer-Complaints-Analysis/Consumer-Complaints-Analysis-main/data")

df_complaints <- read_csv("Consumer_Complaints.csv")

sample_size = 10000
set.seed(1)
idxs = sample(1:nrow(df_complaints),sample_size,replace=F)
subsample = df_complaints[idxs,]

write.csv(subsample, "C:/Users/estif/OneDrive/Documents/Data-331/Consumer-Complaints-Analysis/Consumer-Complaints-Analysis-main/data/Consumer_Complaints_subsample.csv", row.names = FALSE)

pvalues = list()
for (col in names(df_complaints)) {
  if (class(df_complaints[,col]) %in% c("numeric","integer")) {
    # Numeric variable. Using Kolmogorov-Smirnov test
    
    pvalues[[col]] = ks.test(subsample[[col]],df_complaints[[col]])$p.value
    
  } else {
    # Categorical variable. Using Pearson's Chi-square test
    
    probs = table(df_complaints[[col]])/nrow(df_complaints)
    pvalues[[col]] = chisq.test(table(subsample[[col]]),p=probs)$p.value
    
  }
}
pvalues
pvalues
length(subsample[[col]])
length(probs)
