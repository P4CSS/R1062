pkgs <- c("jsonlite", "httr", "ggmap", "ggplot2")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])] 
if(length(pkgs)) install.packages(pkgs)

library(httr)
library(jsonlite)
options(stringsAsFactors = FALSE)




# 1. Get and convert to an R object ---------------------------------------

url <- "http://data.taipei/youbike"
ubike.list <- fromJSON(content(GET(url),"text", encoding = "utf-8"))
class(ubike.list) # list




# 2. list -> vector -> matrix -> data.frame -------------------------------

# Select the right node and unlist it --> vector
ubike.v <- unlist(ubike.list$retVal)

# Fold it by a specified width --> matrix
ubike.m <- matrix(ubike.v, byrow = T, ncol = 14)

# Convert the matrix to dataframe
ubike.df <- as.data.frame(ubike.m)



# 3. Clean and reformat data ----------------------------------------------

# Get field names from the first data entry and assign to ubike.df
names(ubike.df) <- names(ubike.list$retVal$`0001`)

# Convert character vectors to numeric
ubike.df$lng <- as.numeric(ubike.df$lng)
ubike.df$lat <- as.numeric(ubike.df$lat)
ubike.df$tot <- as.numeric(ubike.df$tot)
ubike.df$sbi <- as.numeric(ubike.df$sbi)



# 4. Calculation ----------------------------------------------------------

# ratio <- sbi/tot
ubike.df$ratio <- ubike.df$sbi / ubike.df$tot
summary(ubike.df)



# 5. Plot map by ggplot and ggmap -----------------------------------------

library(ggplot2)
library(ggmap)

ggmap(
	get_googlemap(
		center=c(121.516898,25.055536),
		zoom=12,
		maptype='terrain')) +
  geom_point(data=ubike.df, 
  		   aes(x=lng, y=lat), 
  		   colour='red', 
  		   size=ubike.df$tot/10, 
  		   alpha=0.4)




# 6. Assign color by ratio level ------------------------------------------

# Create a function to convert color
assignColor <- function(ratio){
  if(ratio > 0.8){
    return("#FF0000") # red
  }
  else if(ratio < 0.2){
    return("#0000FF") # blue
  }
  else{
    return("#00FF00") # green
  }
}

# using sapply() to convert color
# sapply() can apply a Function to elements of a vector
# Question: How do it differ from tapply() ?
ubike.df$color <- sapply(ubike.df$ratio, assignColor)

ggmap(get_googlemap(center = c(121.516898,25.055536),
					zoom = 12,
					maptype = 'terrain')
	  ) +
geom_point(data = ubike.df, 
		   aes(lng, lat), 
		   colour = ubike.df$color, 
		   size = ubike.df$tot/10, 
		   alpha = 0.4)



# Appendix: ggmap ---------------------------------------------------------

# maptype can be terrain, roadmap, satellite, hybrid, or toner-lite
map <- get_map(location = c(lon = 120.233937, lat = 22.993013),
               zoom = 10, language = "zh-TW")
ggmap(map, darken = c(0.5, "white"))


