library(shiny)
library(ggvis)
library(ISLR)
library(magrittr)
library(leaflet)
library(muStat)
library(dplyr)


shinyServer(function(input,output,session){


     
  PrivCol<-colorFactor(c("Red", "Navy"), domain=c("Yes", "No"))
  
  #filter the data
  collegefiltered<-reactive({
    
    #we must use temp variables as in the movie explorer example
    mintop25f<-input$top25[1]
    maxtop25f<-input$top25[2]
    minexpendf<-input$expend[1]
    maxexpendf<-input$expend[2]
    
    n<- CollegeSmall %>%
      filter(
        Top25perc>=mintop25f,
        Top25perc<=maxtop25f,
        Expend>=minexpendf,
        Expend<=maxexpendf
      )
    n<-as.data.frame(n)
    n
  })
  
  #create the plot tooltips
  coltooltip<-function(x){
    if(is.null(x)) return(NULL)
    if(is.null(x$Name)) return(NULL)
    all_colleges <- isolate(collegefiltered())
    colle<-all_colleges[all_colleges$Name==x$Name,]
    
    paste0("<b>",colle$Name, "</b><br>",
           "<b>",input$xdata,"</b>"," ", colle[,input$xdata], "<br>",
           "<b>",input$ydata,"</b>"," ", colle[,input$ydata])
    
  }
  
  
  vis<-reactive({
    
    xvar <- prop("x", as.symbol(input$xdata))
    yvar <- prop("y", as.symbol(input$ydata))

    collegefiltered %>%
      ggvis(x=xvar, y=yvar, key:=~Name) %>%
      set_options(width="auto") %>%
      layer_points(stroke=~Private) %>%
      add_axis("x", title=input$xdata) %>%
      add_axis("y", title=input$ydata) %>%
      add_tooltip(coltooltip, on='hover')
  })
  
  
  
  output$map <- renderLeaflet({
    
    leaflet() %>%
      addTiles() %>%
      setView(-89.0382679, 39.3489054, zoom = 4)
    
  })
  
  observe({
    
    Expendnewmn<-input$expend[1]
    Expendnewmx<-input$expend[2]
    Top25newmn<-input$top25[1]
    Top25newmx<-input$top25[2]

    lngnewf<-lng[Expendnewmn<=Expend & Expendnewmx>=Expend & Top25newmn<=Top25perc & Top25newmx>=Top25perc]
    latnewf<-lat[Expendnewmn<=Expend & Expendnewmx>=Expend & Top25newmn<=Top25perc & Top25newmx>=Top25perc]
    popnewf<-mappop[Expendnewmn<=Expend & Expendnewmx>=Expend & Top25newmn<=Top25perc & Top25newmx>=Top25perc]
    privnewf<-Private[Expendnewmn<=Expend & Expendnewmx>=Expend & Top25newmn<=Top25perc & Top25newmx>=Top25perc]
    
    leafletProxy("map") %>%
      clearMarkers() %>%
      addCircleMarkers(lngnewf,latnewf,popup=popnewf,radius=3, color=PrivCol(privnewf))
  })
  
  bind_shiny(vis,"Plot")
})
