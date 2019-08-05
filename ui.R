library(shiny)
library(shinydashboard)
library(png)

shinyUI(
  dashboardPage(
    skin = 'green',
    dashboardHeader(
      title = "Global Literacy", titleWidth = 250
    ),
    dashboardSidebar(width = 250,
      sidebarUserPanel(name = 'Pinky M Chandan',
                       image ='pinky.png',
                       subtitle = h6('NYC Data Science Academy')),
      sidebarMenu(
        menuItem("Home", tabName = "home",icon = icon('fas fa-home')),
        menuItem("World Map", tabName = "map", icon = icon("fas fa-globe-americas")),
        menuItem("Global Aggregates", tabName = "avgworld", icon = icon('fas fa-chart-line')),
        menuItem("Countrywise Literacy", tabName = "countrywise", icon = icon('flag')),
        menuItem("Gender Parity in Education", tabName = "genderparity", icon = icon('female')),
        menuItem("%GDP spent on education", tabName = "GDP", icon = icon('money-bill-wave')),
        menuItem("PISA Science Score", tabName = "PISAscience", icon = icon('book-reader')),
        menuItem("Citations", tabName = "citations", icon = icon("database"))
      )
    ),
    dashboardBody(
      tabItems(
        # HOME ******************************************
        tabItem(
          tabName = 'home', h1('A Visualization of the Global Literacy, Gender Disparity, PISA Science Scores, and GDP spending'),
          fluidRow(
            box(
              outputId = 'home1',
              width = 12,
              h4(textOutput('home1')))
            ),
          fluidRow(
            img(src = 'educationclip.jpg', width = '45%')
          )
        ),
        
        #World Map******************************************
        tabItem(
          tabName = 'map', h1('Literacy Rates Around The World'),
          fluidRow(
            box(
              outputId = 'wmap',
              width=12,
              tabPanel('Literacy across countries',htmlOutput('wmap_gvis'))
            )
          )
        ),
          
        tabItem(
          tabName = "avgworld",h1("World Literacy Statistics"),
          fluidRow(
            box(
              outputId='aggregate',
              width=12,status = 'success',
              column(12,
                     plotlyOutput('worldplotly'))),
            box(
              outputId='aggregate',
              width=12,status = 'success',
              column(6,
                     plotlyOutput('literateplotly')),
              column(6,
                     plotlyOutput('illeterateplotly'))
              
            )
          )
        ),
        
        #Select drop down of countries to see individual literacy for the selected country over time 
        tabItem(
          tabName = "countrywise",h1("Countrywise Literacy over time"),
          fluidRow(
            box(outputId='Literacy for selected country',status = 'success',solidHeader = T, width=12,
                fluidRow(
                  column(4,offset = 0.5,
                         selectizeInput('selected2','Select Country to Display',uniquecountry,selected=T))
              
                )
            )
          ),
          #Displays the line chart in this box
          fluidRow(
            box(
              outputId='countrylit',
              width=12,status = 'success',
              column(12,
                     plotlyOutput('percountry'))
              
              
            )
          )
        ),
        #Dropdown for selecting the country to see the gender parity over time
        tabItem(
          tabName = "genderparity",h1("Gender Parity over time"),
          fluidRow(
            box(outputId='Gender Parity for selected country',status = 'success',solidHeader = T, width=12,
                fluidRow(
                  column(4,offset = 0.5,
                         selectizeInput('selectedgender','Select Country to Display',uniquecountry1,selected=T))
                  
                )
            )
          ),
          #Displays the line chart for the gender parity
          fluidRow(
            box(
              outputId='genderlitearacy',
              width=12,status = 'success',
              htmlOutput('pergender')
              
              )
          )
        ),
        
        tabItem(
          tabName = "GDP",h1("%GDP spend on education"),
          fluidRow(
            box(
              outputId='GDP',
              width=12,status = 'success',
              htmlOutput('gdpplot')
              )
            )
          ),
        
        
        tabItem(
          tabName = "PISAscience",h1("Science PISA Scores"),
          fluidRow(
            
            box(
              outputId='pisa',
              width=12,status = 'success',
              column(6,
                     plotlyOutput('toptenpisa')),
              column(6,
                     plotlyOutput('bottomtenpisa'))
              
            )
          )
        ),
        
        tabItem(tabName = "citations", h1("Citations"),
              fluidRow(
                  box(width=12,
                     "Our World in Data, https://ourworldindata.org/literacy"
                  ),
                  box(width=12,
                    "National Center for Education Statistics, https://nces.ed.gov/programs/coe/ataglance.asp"
                  ),
                  box(width=12,
                    "Unesco eAtlas of Literacy, https://tellmaps.com/uis/literacy/#!/tellmap/-601865091"
                  )
                
              )
          )
              
        )
    )
  )
)