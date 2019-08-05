
#loading the libraries for pinky
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(tidyr)
library(data.table)
library(dygraphs)
library(googleVis)
library(plotly)
#*****************************reading the literacy rate around the world file*****************************
literacyrate=read.csv("literateandilleterate-15yearsolder.csv",header=TRUE,stringsAsFactors =FALSE)
#getwd()
# View(literacyrate)
# colnames(literacyrate)


#******************renaming the column in this dataframe************************************************
setnames(literacyrate,
         old=c("Literate.world.population..people.","Illiterate.world.population..people."),
         new=c("literate.worldinpercent","illeterate.worldinpercent"))
str(literacyrate)
#colnames(literacyrate)

#reading the literacy rates for each country file********************************************
bycountryliteracy=read.csv("cross-country-literacy-rates.csv",header=TRUE,stringsAsFactors = FALSE)
#colnames(bycountryliteracy)


#renaming the columns
bycountryliteracy = bycountryliteracy %>% 
  select(country = Entity,
         Code,
         Year,
         literacybycountry=Literacy.rates..World.Bank..CIA.World.Factbook..and.other.sources.....)
#colnames(bycountryliteracy)

#reading the literacy rate for young men and women age 15-24 years
menwomenliteracy=read.csv("literacy-rate-of-young-men-and-women-15to24years.csv",header = TRUE,stringsAsFactors = FALSE)

#renaming the columns
menwomenliteracy=menwomenliteracy %>% 
  select(country=Entity,
         Code,
         Year,
         maleliteracy=Youth.literacy.rate..population.15.24.years..male........,
         femaleliteracy=Youth.literacy.rate..population.15.24.years..female........,
         totalpopulation=Total.population..Gapminder.)


#reading the total government expenditure on education by country
govexpenditure=read.csv("total-government-expenditure-on-education-gdp.csv",header = TRUE,stringsAsFactors = FALSE)


#renaming the columns
govexpenditure=govexpenditure %>% 
  select(country=Entity,
         Code,
         Year,
         percentofgdp=X...of.GDP.)


#Splitting the literacy world dataframe to two dfs, literate df and illiterate df
dfl=literacyrate %>% 
  select(Year,Percentage=literate.worldinpercent)

dfl$literacy = 'literate'

dfi=literacyrate %>% 
  select(Year,Percentage=illeterate.worldinpercent)

dfi$literacy = 'illiterate'

#stacking the two dataframes for visualization
finaldf=rbind(dfl,dfi)


###Taking the most recent year data for each country to display on the world map*********
#View(bycountryliteracy)
forworldmap= bycountryliteracy %>% 
  group_by(country) %>% 
  filter(Year == max(Year))



##Literacy rate for selected country and gender parity
uniquecountry = unique(bycountryliteracy$country)

str(bycountryliteracy)

menwomen=menwomenliteracy %>% filter(!is.na(maleliteracy))
uniquecountry1 = unique(menwomen$country)

##%GDP spent on education data
gdpspend=read.csv("gdp_spend.csv",header = TRUE,stringsAsFactors = FALSE)
gdpspend$spendchange = with(gdpspend, (X2015_Spend/X2005_Spend-1)*100)

##Pisa Scores
pisadf=read.csv("sciencePISA.csv",header = TRUE,stringsAsFactors = FALSE)







