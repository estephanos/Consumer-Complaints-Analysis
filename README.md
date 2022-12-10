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
