library(tidyverse)
library(lubridate)
library(dplyr)
library(readxl)
library(ggplot2)
library(ggthemes)
library(tidytext)
library(anytime)
library(plotly)
library(gridExtra)
library(hrbrthemes)
library(usmap)

#Set Directory and read in file
rm(list = ls())

setwd("~/Documents/Consumer-Complaints-Analysis/data")
complaints <- read.csv("Consumer_Complaints.csv")

setwd("C:/Users/estif/OneDrive/Documents/Data-331/Consumer-Complaints-Analysis/Consumer-Complaints-Analysis-main/data")
complaints <- read.csv("Consumer_Complaints_subsample.csv")


#Clean Data - Making blank cells to N/A and making zip code numeric
complaints$ZIP.code <- as.numeric(complaints$ZIP.code)
complaints$Consumer.consent.provided. <- ifelse(complaints$Consumer.consent.provided. == "", "N/A",complaints$Consumer.consent.provided.)
complaints$Sub.product <- ifelse(complaints$Sub.product == "", "N/A",complaints$Sub.product)
complaints$Sub.issue<- ifelse(complaints$Sub.issue == "", "N/A",complaints$Sub.issue)
complaints$Consumer.complaint.narrative <- ifelse(complaints$Consumer.complaint.narrative == "", "N/A",complaints$Consumer.complaint.narrative)
complaints$Company.public.response <- ifelse(complaints$Company.public.response == "", "N/A",complaints$Company.public.response)
complaints$Tags<- ifelse(complaints$Tags == "", "N/A",complaints$Tags)
complaints$Consumer.disputed.<- ifelse(complaints$Consumer.disputed. == "", "N/A",complaints$Consumer.disputed.)

#Create a Table with Count of each Product
complaint_count <- complaints %>%
  count(Product)

#Bar Graph of the count of Products
ggplot(data = complaint_count, aes(x=Product, y=n))+
  geom_bar(stat = "identity", fill = "purple")+
  ylab("Count")+
  coord_flip()

#Bar Graphs: Count of Submitted Via and Consumer Response to Consumer 
p2 <- ggplot(complaints, aes(x = Submitted.via)) + geom_bar(aes(fill = Submitted.via)) + 
  theme(axis.text.x = element_blank()) + scale_fill_brewer(palette="Accent")

p3 <- ggplot(complaints, aes(x = Company.response.to.consumer)) + geom_bar(aes(fill = Company.response.to.consumer)) + 
  theme(axis.text.x = element_blank()) + scale_fill_brewer(palette="Dark2")

#Click Zoom button to see graphs more clearly 
grid.arrange(p2, p3)

#Top 10 Companies with Most Complaints
company_count <- complaints %>%
  group_by(Company) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count)) %>%
  top_n(10)

#Bar Graph of Top 10 Companies
ggplot(company_count, aes(x = Company, y = Count)) +
  geom_bar(stat = "identity", fill = "seagreen3") +
  coord_flip() +
  labs(title = "Top 10 Companies", x = "Company", y = "Count") +
  theme(plot.title = element_text(hjust = 0.5))

# Top Weekday with Most complaints
complaints$Date.received <- as.Date(complaints$Date.received, "%m/%d/%Y")
complaints$Weekday <- weekdays(complaints$Date.received)

weekday_pivot<- complaints %>%
  group_by(Weekday) %>%
  summarize(Count = n())

#Bar Graph of Top Weekdays
ggplot(weekday_pivot, aes(x = Weekday, y = Count)) +
  geom_bar(stat = "identity", fill = "orange") +
  labs(title = "Weekday with Most Complaints", x = "Weekday", y = "Count") +
  theme(plot.title = element_text(hjust = 0.5))

#Create a State Pivot Table
state_pivot <- complaints %>%
  group_by(State) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count))

#renaming State column to state for map plot
state_pivot <- state_pivot %>%
  rename("state" = "State")

#Map of US: Darker orange is states with lots of complaints
plot_usmap(data = state_pivot, values = "Count",
           regions = "state", include = state_pivot$state) +
  scale_fill_continuous(low = "white", high = "orange", 
                        name = "State Complaints", label = scales::comma) + 
  labs(title = "States with Most Complaints") +
  theme(legend.position = "right")


df_timely <- complaints[complaints$Timely.response. == "Yes",]
df_timely = df_timely%>%
  group_by(Company) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count)) %>%
  top_n(10)

ggplot(df_timely,aes(x= reorder(Company, -Count),y = Count, fill = Company))+
  geom_bar(stat ="identity")+
  theme(legend.position = "none")+
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Companies with Timely Response", x = "Companies")+
  theme_wsj()

complaints$Date.received = anydate(complaints$Date.received)

complaints$year = format(complaints$Date.received, "%Y")

by_year = complaints%>%
  group_by(year)%>%
  summarise(`No. of complaints` = n())
by_year$year = as.numeric(by_year$year)
  

ggplot(by_year, aes(x=year, y = `No. of complaints`)) +
  geom_line() + 
  geom_point(aes(y = `No. of complaints`, color = `No. of complaints`, size = 4)) +
  labs(title = "Number of complaints from 2011-2016", x = "Year")+
  theme_modern_rc() +
  theme(axis.text.x=element_text(angle=60, hjust=1))

