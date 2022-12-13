# load the required packages
library(shiny)
#require(shinydashboard)
library(ggplot2)
library(ggthemes)
library(hrbrthemes)
library(plotly)
library(dplyr)
library(tidyverse)
library(anytime)

setwd("C:/Users/estif/OneDrive/Documents/Data-331/Consumer-Complaints-Analysis/Consumer-Complaints-Analysis-main/data")
complaints <- read_csv("Consumer_Complaints_subsample.csv")
complaints$`Date received` = anydate(complaints$`Date received`)
complaints$year = format(complaints$`Date received`, "%Y")
complaints$Product = as.factor(complaints$Product)
complaints$Company = as.factor(complaints$Company)
complaints$Issue = as.factor(complaints$Issue)
complaints$`Submitted via` = as.factor(complaints$`Submitted via`)
products_list = c(complaints$Product)

complaints = complaints%>%
  mutate_if(is.character, utf8::utf8_encode)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      h2("Consumer Complaints Dashboard"),
      selectInput(inputId = "feature", label = "Select Feature",
                  choices = c("Product", "Company", "Issue"),
                  selected = "Product"),
      selectInput(inputId = "states", label = "State",
                  choices = complaints$State,
                  multiple = TRUE,
                  selected = "IL"),
      
      selectInput(inputId = "products", label = "Product",
                  choices = c("Select Product","Mortgage", "Debt collection", "Credit reporting", "Bank account or service", "Credit card", "Consumer Loan"),
                  multiple = TRUE,
                  selected = "Select Product"
                  ),
      
      selectizeInput(inputId = "company", label = "Company",
                  choices = c("Select Company", 
                              "Equifax",
                              "Bank of America",
                              "Wells Fargo & Company",
                              "TransUnion Intermediate Holdings, Inc.",
                              "Experian",
                              "JPMorgan Chase & Co.",
                              "Citibank",
                              "Ocwen",
                              "Capital One",
                              "Nationstar Mortgage",
                              "Synchrony Financial",
                              "Ditech Financial LLC",
                              "U.S. Bancorp",
                              "Navient Solutions, Inc.",
                              "Encore Capital Group",
                              "Portfolio Recovery Associates, Inc.",
                              "PNC Bank N.A.",
                              "Amex"),
                  multiple = TRUE,
                  options = list(maxItems = 10, closeAfterSelect = TRUE),
                  selected="Select Company"

                  ),
      
      selectInput(inputId = "issues", label = "Issues",
                  choices = c("Incorrect information on credit report", "Incorrect information on credit report",
                              "Loan servicing, payments, escrow account", "Cont'd attempts collect debt not owed",
                              "Account opening, closing, or management"),
                  multiple = TRUE,
                  selected = "Incorrect information on credit report"),
      
      dateRangeInput(inputId = "date", "Date range",
                     start = min(complaints$`Date received`),
                     end   = max(complaints$`Date received`)
                     ),
      
      downloadButton(outputId = "download_data", label = "Download Data"),
      style = "position: fixed; overflow: visible;"
    ),
    mainPanel(
      plotlyOutput(outputId = "distplot"), br(),
      br(),
      plotlyOutput(outputId = "plot2"), br(),
      plotlyOutput(outputId = "plot3"), br(),
      plotlyOutput(outputId = "plot4")
      )
    )
)


server <- function(input, output) {
  # filtered_data <- reactive({
  #   subset(complaints,
  #          Product %in% input$products &
  #            Company %in% input$company &
  #            `Date received` >= input$date[1] & `Date received` <= input$date[2])})
  
  #first plot
  output$distplot <- renderPlotly({
    
# if product selected as feature
    if(input$feature == "Product"){
      products = complaints%>%
        filter(`Date received` >= input$date[1] & `Date received` <= input$date[2])%>%
        group_by(Product) %>%
        summarize(Count = n()) %>%
        arrange(desc(Count)) %>%
        top_n(10)
      plot1 = ggplot(products, aes(y = Count, x = reorder(Product, Count))) +
        geom_bar(stat = "identity", fill = "springgreen3") +
        coord_flip() +
        labs(title = "Top 10 Products", x = "Product", y = "Count") +
        theme(plot.title = element_text(hjust = 0.5))+
        theme_economist()
      
# if company selected as feature     
    }else if(input$feature == "Company"){
      companies = complaints %>%
        filter(`Date received` >= input$date[1] & `Date received` <= input$date[2])%>%
        group_by(Company) %>%
        summarize(Count = n()) %>%
        arrange(desc(Count)) %>%
        top_n(10)
      plot1 = ggplot(companies, aes(x = reorder(Company, Count), y = Count)) +
        geom_bar(stat = "identity", fill = "springgreen3") +
        coord_flip() +
        labs(title = "Top 10 Companies", x = "Company", y = "Count") +
        theme(plot.title = element_text(hjust = 0.5))+
        theme_economist()
      
# if issue selected as feature
    }else if(input$feature == "Issue"){
      issues = complaints %>%
        filter(`Date received` >= input$date[1] & `Date received` <= input$date[2])%>%
        group_by(Issue) %>%
        summarize(Count = n()) %>%
        arrange(desc(Count)) %>%
        top_n(10)
      plot1 = ggplot(issues, aes(y = Count, x = reorder(Issue, Count))) +
        geom_bar(stat = "identity", fill = "springgreen3") +
        coord_flip() +
        labs(title = "Top 10 Issues", x = "Company", y = "Count") +
        theme(plot.title = element_text(hjust = 0.5))+
        theme_economist()
    }
    
    plot1
      
  })
  
  #second plot
  output$plot2 = renderPlotly({
    if(input$company == "Select Company"){
      df = complaints%>%
        #filter(Company == input$company)%>%
        # filter(Product == input$products)%>%
        filter(`Date received` >= input$date[1] & `Date received` <= input$date[2])
    }else if(input$company != "Select Company"){
      df = complaints%>%
        filter(Company == input$company)%>%
        # filter(Product == input$products)%>%
        filter(`Date received` >= input$date[1] & `Date received` <= input$date[2])
    }
    
    
    plot2 = ggplot(df, aes(x=`Timely response?`, fill=`Submitted via`)) + 
      geom_bar(position="dodge") + 
      ggtitle("Company Response to the Customer")+
      theme_solarized_2()
  })
  
  #third plot
  output$plot3 = renderPlotly({
    df_timely = complaints[complaints$`Timely response?` == "Yes",]
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
      theme_solarized()
  })
  
  #fourth plot
  output$plot4 = renderPlotly({
    if(input$company == "Select Company"){
      by_year = complaints%>%
        #filter(Company == input$company)%>%
        group_by(year)%>%
        summarise(`No. of complaints` = n())
      by_year$year = as.numeric(by_year$year)
    }else{
      by_year = complaints%>%
        filter(Company == input$company)%>%
        group_by(year)%>%
        summarise(`No. of complaints` = n())
      by_year$year = as.numeric(by_year$year)
    }
    
    ggplot(by_year, aes(x=year, y = `No. of complaints`)) +
      geom_line() + 
      geom_point(aes(y = `No. of complaints`, color = `No. of complaints`, size = 4)) +
      labs(title = "Number of complaints from 2011-2016", x = "Year")+
      theme_modern_rc() +
      theme(axis.text.x=element_text(angle=60, hjust=1))
  })
  
  
  output$download_data <- downloadHandler(
    filename = "download_data.csv",
    content = function(file) {
      data <- filtered_data()
      write.csv(data, file, row.names = FALSE)
    }
  )
  
}

shinyApp(ui = ui, server = server)
