library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input,output){
  #Pinky's Home***********************************************
  output$home1 = renderText(
    'Hello! Welcome to this data visualization Shiny app for Global Education Statistics. 
     Here you can find analysis of literacy and illiteracy rates across the globe, 
     gender disparity in education, and the percent of GDP spend on education by country.'
  )
  
 
  
  # Pinky's WORLD MAP ###################################################################  
  output$wmap_gvis = renderGvis({
    gvisGeoChart(
      forworldmap,
      locationvar = 'country',
      colorvar = 'literacybycountry',
      hovervar = 'country',
      options  = list(region = 'world', 
                      displayMode = 'regions',
                      colorAxis = "{colors:['#e31b23', 'black', '#00853f']}",
                      backgroundColor = '#dceef7',
                      datalessRegionColor = 'grey',
                      width = 1800,
                      height=650,
                      forceFrame = TRUE
                      )
    )
  })
  
  
  #Aggregate world literacy in one box and top 20 literate countries in the right box
  #Plotting an area chart on left side of page for literacy and illeteracy world rates with plotly
  

  output$worldplotly = renderPlotly({
    world1=ggplot(finaldf,aes(x=Year,y=Percentage))+
      geom_area(aes(fill=literacy, color=literacy), position='stack') +
      labs(title = "Literate and Illiterate World Population",
           subtitle="15 years and older",
           x="Year",
           y="Percentage")+
      # xlim(NA,2016)+
      theme(axis.text=element_text(size=8),
            axis.title=element_text(size=15))+
      ylim(0,100)+
      scale_x_continuous(breaks=seq(1800,2016,36))
    world2=ggplotly(world1)
  })
  
  
  #Plotting top 10 literate rates for the recent year available for each country in the right box**
                          
  
  
  output$literateplotly = renderPlotly({
    toplit= ggplot(bycountryliteracy %>% filter(Year == max(Year)) %>% 
                     arrange(desc(literacybycountry)) %>% top_n(10),
                   aes(x=country,y=literacybycountry))+
      theme(axis.text=element_text(size=8),
            axis.title=element_text(size=15))+
      ylab("Percentage")+
      ggtitle("Top 10 Literate Countries")+
      geom_col(fill="steelblue")+
      coord_cartesian(ylim=c(90, 100))
    topten=ggplotly(toplit)
  })
  
  #Plotting top 10 illiterate rates for the recent year available for each country in the right box************************
  
    output$illeterateplotly = renderPlotly({
    botlit= ggplot(bycountryliteracy %>% filter(Year == max(Year)) %>% 
                     arrange(desc(literacybycountry)) %>% top_n(-10),
                   aes(x=country,y=literacybycountry))+
      theme(axis.text=element_text(size=8),
            axis.title=element_text(size=15))+
      ylab("Percentage")+
      ggtitle("Top 10 illiterate Countries")+
      geom_col(fill="steelblue")+
      coord_cartesian(ylim=c(0, 100))
    botten=ggplotly(botlit)
  })
  
  #Plotting for user selected country literacy line chart
  output$percountry = renderPlotly({
    eachcountry = ggplot(bycountryliteracy %>% filter(country==input$selected2), 
                         aes(x=Year, y=literacybycountry))+
      geom_line(color='indianred3',size=1)+geom_point(color='coral3',size=3)+
      labs(title="Literacy Rate",x="Year",y="Percentage")
  
    thecountry =ggplotly(eachcountry)
  })
  
  #Plotting for user selected country gender parity literacy chart
  output$pergender = renderGvis({gvisLineChart(menwomen %>% filter(country==input$selectedgender), 
                          xvar =  "Year", yvar = c("femaleliteracy","maleliteracy"),
                          options=list(
                          height= 800,
                          hAxes="[{title:'Year'}]",
                          vAxes="[{title:'Percentage(%)'}]"
                ))
  })          
  
  #Plotting GDP percent spend on education by country over time
  
  output$gdpplot = renderGvis({gvisBarChart(gdpspend, xvar="country", 
                              yvar=c("spendchange"),
                              options=list(title="% Change in Education Spending", height=1000,
                                           hAxis="{title:'%change in spending'}"))
                  })
  
  output$toptenpisa = renderPlotly({
    toppisa= ggplot(pisadf  %>% 
                     arrange(desc(PISAscore)) %>% top_n(10),
                   aes(x=country,y=PISAscore))+
      theme(axis.text=element_text(size=8),
            axis.title=element_text(size=15))+
      ylab("PISA Science Score")+
      ggtitle("Top 10 PISA Countries")+
      geom_col(fill="steelblue")+
      coord_cartesian(ylim=c(200, 600))
    topten=ggplotly(toppisa)
  })
  
  #Plotting bottom 10 pisa science for the recent year  in the right box************************
  
  output$bottomtenpisa = renderPlotly({
    botpisa= ggplot(pisadf  %>% 
                     arrange(desc(PISAscore)) %>% top_n(-10),
                   aes(x=country,y=PISAscore))+
      theme(axis.text=element_text(size=8),
            axis.title=element_text(size=15))+
      ylab("PISA Science Score")+
      ggtitle("Bottom 10 PISA Countries")+
      geom_col(fill="steelblue")+
      coord_cartesian(ylim=c(200, 600))
    botten=ggplotly(botpisa)
  })
  
  
})



