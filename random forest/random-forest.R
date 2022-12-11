library(randomForest)
library(dplyr)
library(tidyverse)
library(readxl)
library(lubridate)
library(caret)
library(CatEncoders)
library(explore)
library(ggplot2)

rm(list = ls())

#setting working directory
setwd("C:/Users/estif/OneDrive/Documents/Data-331/Consumer-Complaints-Analysis/Consumer-Complaints-Analysis-main/data")

df_complaints <- read_csv("Consumer_Complaints.csv")

#removing nas
df_complaints %>% 
  mutate(`Consumer disputed?` = ifelse(is.na(`Consumer disputed?`), mode(`Consumer disputed?`), `Consumer disputed?`))%>%
  drop_na(Product)

round(colMeans(is.na(df_complaints)),4)*100

df_complaints = df_complaints[sample(nrow(df_complaints), 10000), ]

#encoding variables
df_complaints$`Consumer encode` = as.numeric(factor(df_complaints$`Consumer disputed?`))

#define original categorical labels
labs = LabelEncoder.fit(df_complaints$Product)

#convert labels to numeric values
df_complaints$Product = transform(labs, df_complaints$Product)


#Splitting Independent features from Dependent ones
x = data.frame(ID = df_complaints$`Complaint ID`, Product = df_complaints$Product, Company = df_complaints$Company, Issue = df_complaints$Issue)
y = data.frame(`Consumer disputed?` = df_complaints$`Consumer encode`, ID = df_complaints$`Complaint ID`)

x_train <- x %>% dplyr::sample_frac(0.75)
y_train <- y %>% dplyr::sample_frac(0.75)

x_test  <- anti_join(x, x_train, by = 'ID')
y_test = anti_join(y, y_train, by = "ID")

train = x_train%>%
  left_join(y_train, by = 'ID')

#remove nas
train = train[complete.cases(train), ] 

train = train%>%select(-'ID')


#feature scaling
# pre.x_train <- preProcess(x_train, method=c("center", "scale"))
# x_train <- predict(pre.x_train, x_train)
# 
# pre.x_test = preProcess(x_test, method=c("center", "scale"))
# x_test <- predict(pre.x_test, x_test)

#building random forest classifier
classifier_RF = randomForest(x = train[-4],
                             y = train$Consumer.disputed.,
                             ntree=1000,
                             keep.forest=FALSE, importance=TRUE)

classifier_RF

test = x_test%>%
  left_join(y_test, by = 'ID')
test = test%>%select(-'ID')

y_pred = predict(classifier_RF, newdata = test[-4])
y_pred = as.data.frame(y_pred)

confusion_mtx = table(test[, 4], y_pred)
confusion_mtx = as.data.frame(confusion_mtx)

# Plotting model
plot(classifier_RF)

# Importance plot
classifier_RF$mse

# Variable importance plot
varImpPlot(classifier_RF)


### more plots
# Get variable importance from the model fit
ImpData <- as.data.frame(importance(classifier_RF))
ImpData$Var.Names <- row.names(ImpData)

ggplot(ImpData, aes(x=Var.Names, y=`%IncMSE`)) +
  geom_segment( aes(x=Var.Names, xend=Var.Names, y=0, yend=`%IncMSE`), color="skyblue") +
  geom_point(aes(size = IncNodePurity), color="blue", alpha=0.6) +
  theme_light() +
  coord_flip() +
  theme(
    legend.position="bottom",
    panel.grid.major.y = element_blank(),
    panel.border = element_blank(),
    axis.ticks.y = element_blank()
  )

