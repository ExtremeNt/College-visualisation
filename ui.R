library(shiny)
library(ggvis)
library(ISLR)
library(magrittr)
library(leaflet)
library(muStat)
library(dplyr)

shinyUI(
  
  fluidPage(
    titlePanel('Interactive College Data'),
    fluidRow(
      column(4,
             wellPanel(
               selectInput('xdata','x-axis', c("Apps", "Accept", "Enroll", "Grad.Rate"), selected="Apps"),
               selectInput('ydata', 'y-axis', c("Apps", "Accept", "Enroll", "Grad.Rate"), selected="Accept"),
               sliderInput('top25', 'Percentage top 25', min=0, max=100, value=c(40,50)),
               sliderInput('expend', 'Instuctional expenditure per student', min=min(CollegeSmall$Expend), max=max(CollegeSmall$Expend),
                           value=c(10000,20000))
             )  
      ),
      column(8,
             ggvisOutput('Plot')
      )
    ),
    fluidRow(
      column(12,
             leafletOutput("map")
      )
    )
  )
)
