library(httr)
library(ggplot2)
library(ggmap)
library(dplyr)
library(jsonlite)
options(stringsAsFactors = F)



# # Read site metadata with geolocation -------------------------------------
# 
# siteurl <- "https://taqm.epa.gov.tw/taqm/aqs.ashx?lang=tw&act=aqi"
# res <- fromJSON(content(GET(siteurl),"text"))
# loc.df <- res$Data



# Read Air Quality data ---------------------------------------------------

dataurl <- "https://taqm.epa.gov.tw/taqm/aqs.ashx?lang=tw&act=aqi-epa"
res <- fromJSON(content(GET(dataurl),"text"))
data.df2 <- res$Data




names(data.df)
names(loc.df)



# Join data and location data ---------------------------------------------

aqxdata <- inner_join(data.df, loc.df, by=c("SiteName"))




# Plot AQI on map by PM2.5 ------------------------------------------------
# Plot a map according to http://taqm.epa.gov.tw/taqm/tw/b0201.aspx

# Convert PM2.5 field from character to numeric
aqxdata$PM2.5 <- as.numeric(aqxdata$PM2.5)
aqxdata$TWD97Lon <- as.numeric(aqxdata$TWD97Lon)
aqxdata$TWD97Lat <- as.numeric(aqxdata$TWD97Lat)


# Write a function assigning color according to PM2.5
assignColor <- function(index){
  if(index <= 15.4){return("#00FF00")}
  else if(index >= 15.5 && index <= 35.4){return("#FFFF00")}
  else if(index >= 35.5 && index <= 54.4){return("#FF8000")}
  else if(index >= 54.5 && index <= 150.4){return("#FF0000")}
  else if(index >= 150.5 && index <= 250.4){return("#7401DF")}
  else {return("#8A0808")}
}

# na processing
aqxdata$PM2.5[is.na(aqxdata$PM2.5)] <- 0
aqxdata <- aqxdata[!is.na(aqxdata$PM2.5), ]

# sapply() to generate a color vector
aqxdata$color <- sapply(aqxdata$PM2.5, assignColor)


# Plot data on map with color
ggmap(get_googlemap(center=c(120.9248395,23.6151486),zoom=8,maptype='terrain')) +
  geom_point(data=aqxdata, aes(x=TWD97Lon, y=TWD97Lat), colour=aqxdata$color, size=5, alpha=0.8)




# Get AQX data repeatedly -------------------------------------------------





