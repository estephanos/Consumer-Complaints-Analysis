# Complaint Analysis

## Data Dictionary

- Consumer Complaint Narrative: text of complaint (Text)

- Issue: Issue about which complaint was registered - high level (Text)

- Sub-Issue: Issue about which complaint was registered - granular level (Text)

- Company: Name of Company (Text)

- Product: Product about which complaint was registered (Text)

- Sub-Product: Sub-Product about which complaint was registered (Text)

- Tags: Description of person who complained (Text)

## Cleaning the Data

After looking at the data we noticed that it was pretty clean. We only changed the blank cells to reflect "N/A" and changed the Zip Code column to be numeric. 

`complaints$ZIP.code <- as.numeric(complaints$ZIP.code)`

`complaints$Consumer.consent.provided. <- ifelse(complaints$Consumer.consent.provided. == "", "N/A",complaints$Consumer.consent.provided.)`

`complaints$Sub.product <- ifelse(complaints$Sub.product == "", "N/A",complaints$Sub.product)`

`complaints$Sub.issue<- ifelse(complaints$Sub.issue == "", "N/A",complaints$Sub.issue)`

`complaints$Consumer.complaint.narrative <- ifelse(complaints$Consumer.complaint.narrative == "", "N/A",complaints$Consumer.complaint.narrative)`

`complaints$Company.public.response <- ifelse(complaints$Company.public.response == "", "N/A",complaints$Company.public.response)`

`complaints$Tags<- ifelse(complaints$Tags == "", "N/A",complaints$Tags)`

`complaints$Consumer.disputed.<- ifelse(complaints$Consumer.disputed. == "", "N/A",complaints$Consumer.disputed.)`

## Sentiment Analysis

![Bing Sentiment](/Images/BingPlot.png)

Bing within R only categorizes by positive or negative words. The graph above shows that that are more negative words than positive words within the consumer complaint narrative. 
We assumed since the dataset was about complaints that there would more negative words used when consumers talked to the companies about issues they were having. 

![NRC Sentiment](/Images/NRCgraph.png)

NRC categorizes words more specificly than just positive or negative. As you can see there is more categories that R puts words in. The NRC sentiment analysis is also using the consumer complaint narrative column. 

## Explorartory Data Analysis

![Submitted Via and Company Response to Consumer](/Images/SubmittedVia.png)

The submitted via bar graph shows which platform complaints were sent from. As shown above web has the highest amount. Therefore, consumers submitted their complaints through most likely a website. Referral was the second highest. We assume that most companies have a tab on their websites for users to submit complaints and it is probably easier than being on the phone on hold. 

The second graph shows the company's response to consumer about their complaint. Closed with an explaination was the highest. Consumer want an explaination on why they are having issues with certain products that the company offers. 

![Product](/Images/ProductPlot.png)

The product that had the most complaints against it was mortgage. Since the data is centered around financial institutions, they deal a lot with consumers taking out loans to purchase a house. 

![Top 10 Companies](/Images/Top10Companies.png)

The graph above shows the top 10 companies that had the most complaints against them. Bank of America has over 60,000 complaints against. That could be because Bank of America has several branches all over the U.S. Each state's population varies, there can be a couple million in one state and 40 million in another state. 

![US Map](/Images/StateMap.png)

The map above shows the number of complaints per state. The darker orange states have the most complaints against them and lighter colored states have fewer complaints against them. California is a very dark orange and according to the key has over 75,000 complaints within the state. Florida is a dark orange as well. We assume the bigger states such as California, Florida, and Texas would have more complaints against them than any other state because they are highly populated.
