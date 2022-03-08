# David Lennox-Hvenekilde
# 220308
# Made for the Developing Data Products course project
#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Load dependencies
library(shiny)
library(plotly)
library(ggplot2)
library(dplyr)

# Read the data from github
urlfile<-'https://raw.githubusercontent.com/DavidL-H/ProffR/main/CompanyMetricsClean.csv'
CompanyMetricsCleanGit <-read.csv(urlfile)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
      
      # Application title
      titlePanel("Biotech, Chemical, and Medtech companies in Denmark"),
      
      # Sidebar with a slider input for number of minimum employee number
      sidebarLayout(
            
            # Define the side panel
            sidebarPanel(
                  p("This Shiny widget allows plotting of some data on Danish biotechnology, chemical and medtech companies.
                The data has been scraped from Proff.dk, which contains information about companies registered in Denmark,
                such as employee number and simple financial data. For sourcing of the data, .csv and web scraping code is available
                at Github: https://github.com/DavidL-H/ProffR. The pitch presentation can be seem at RPUBS: https://rpubs.com/Davidlh/875134"),
                  
                  # Select which minimum employee numbers to include
                  sliderInput("EmployeesSliderInput",
                              "Minimum Number of Employees",
                              min = 1,
                              max = 100,
                              value = 1),
                  
                  # Select which industries to include
                  selectInput("IndustryChoice", 
                              "Choose Industries to Include", 
                              choices = unique(CompanyMetricsCleanGit$Industry), 
                              selected = "Biotechnology", 
                              multiple = TRUE),
                  
                  # Add regression?
                  checkboxInput("RegressionCheck", label = "Linear regression", value = FALSE),
                  
                  # Show regression coeffificents
                  textOutput("RegCoefRev"),
                  textOutput("RegCoefEBITA")
            ),
            
            
            # Show two plots of the generated scatterplots of revenue and
            # EBITA as a function of employee number
            mainPanel(
                  plotOutput("DKbiotechPlotly_REVENUE"),
                  plotOutput("DKbiotechPlotly_EBITA")
            )
      )
))
