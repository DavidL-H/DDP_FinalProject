# David Lennox-Hvenekilde
# 220308
# Made for the Developing Data Products course project
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(dplyr)
library(ggplot2)

# Read data from github
urlfile<-'https://raw.githubusercontent.com/DavidL-H/ProffR/main/CompanyMetricsClean.csv'
CompanyMetricsCleanGit <-read.csv(urlfile)

# Define server logic required to draw two plotly scatter plots:
shinyServer(function(input, output) {
      
      # Scatter plot 1: Revenue vs. Employee
      output$DKbiotechPlotly_REVENUE <- renderPlot({ 
            # First subset the data based on user input: "input$IndustryChoice" and "EmployeesSliderInput"
            CompanySubset <- CompanyMetricsCleanGit[CompanyMetricsCleanGit$Industry %in% input$IndustryChoice,]
            CompanySubset <- CompanySubset[CompanySubset$Employees >= input$EmployeesSliderInput,]
            
            # Plot it
            plot(CompanySubset$Employees, 
                 CompanySubset$Revenue_DKK, 
                 col=1:length(unique(CompanySubset$Industry)),
                 main = "Scatter plot 1: Revenue vs. Employee",
                 xlab = "Employees (2020)",
                 ylab = "Revenue in DKK (2020)"
                 )
            
            legend(min(CompanySubset$Employees), max(CompanySubset$Revenue_DKK), legend=unique(CompanySubset$Industry),
                   col=1:length(CompanySubset$Industry),
                   pch = 1)
      
      # If option is ticked for linear regression ticked ("input$RegressionCheck"), then add the regression as a a line to the plot
      if ((nrow(CompanySubset)>1) & (input$RegressionCheck == 1)){
            
            CompanySubsetRegression <- CompanySubset[!is.na(CompanySubset$Revenue_DKK),]
            abline(lm(Revenue_DKK ~ Employees, data = CompanySubsetRegression))
            
            
      }
      
      })
# Scatter plot 2: EBITA vs. Employee
output$DKbiotechPlotly_EBITA <- renderPlot({ 
      # First subset the data based on user input: "input$IndustryChoice" and "EmployeesSliderInput"
      CompanySubset <- CompanyMetricsCleanGit[CompanyMetricsCleanGit$Industry %in% input$IndustryChoice,]
      CompanySubset <- CompanySubset[CompanySubset$Employees >= input$EmployeesSliderInput,]
      
      
      plot(CompanySubset$Employees, 
           CompanySubset$EBITA_DKK, 
           col=1:length(unique(CompanySubset$Industry)),
           main = "Scatter plot 1: EBITA vs. Employee",
           xlab = "Employees (2020)",
           ylab = "EBITA in DKK (2020)")
      
      if ((nrow(CompanySubset)>1) & (input$RegressionCheck == 1)){
            
            CompanySubsetRegression <- CompanySubset[!is.na(CompanySubset$EBITA_DKK),]
            abline(lm(EBITA_DKK ~ Employees, data = CompanySubsetRegression))
      }
      
      
})

# Server logic to print coefficients for the linear regression of revenue
output$RegCoefRev <- renderText({
      CompanySubset <- CompanyMetricsCleanGit[CompanyMetricsCleanGit$Industry %in% input$IndustryChoice,]
      CompanySubset <- CompanySubset[CompanySubset$Employees >= input$EmployeesSliderInput,]
      
      # If option is ticked: calculate
      if ((nrow(CompanySubset)>1) & (input$RegressionCheck == 1)){
            CompanySubsetRegressionREV <- CompanySubset[!is.na(CompanySubset$Revenue_DKK),]
            fitRev <- lm(Revenue_DKK ~ Employees, data = CompanySubsetRegressionREV)
            
            paste("Revenue (DKK) = ", 
                  as.character(round(fitRev$coefficients[2],digits = 2)), 
                  "* Employees + ",
                  as.character(round(fitRev$coefficients[1],digits = 2)), sep = " "
            )
      }
})

# Server logic to print coefficients for the linear regression of revenue
output$RegCoefEBITA <- renderText({
      CompanySubset <- CompanyMetricsCleanGit[CompanyMetricsCleanGit$Industry %in% input$IndustryChoice,]
      CompanySubset <- CompanySubset[CompanySubset$Employees >= input$EmployeesSliderInput,]
      
      # If option is ticked: calculate
      if ((nrow(CompanySubset)>1) & (input$RegressionCheck == 1)){
            CompanySubsetRegressionEBITA <- CompanySubset[!is.na(CompanySubset$EBITA_DKK),]
            fitEBITA <- lm(EBITA_DKK ~ Employees, data = CompanySubsetRegressionEBITA)
            
            paste("EBITA (DKK) = ", 
                  as.character(round(fitEBITA$coefficients[2],digits = 2)), 
                  "* Employees + ",
                  as.character(round(fitEBITA$coefficients[1],digits = 2)), sep = " "
            )
      }
})
})
