# Plotting ubike map ------------------------------------------------------

# Slide: https://docs.google.com/presentation/d/e/2PACX-1vTFRVkwdscR3QNdVD6Q8JEKshlORtgdP_DUq19HPjbO6_8nN3ADTEtxuOr_Z28t3HKGdf9_m3icULpO/pub?start=false&loop=false&delayms=3000&slide=id.g2074c710b4_0_302
# Youtube: https://www.youtube.com/playlist?list=PLK0n8HKZQ_VfJcqBGlcAc0IKoY00mdF1B

# read ubike data than plot it on map by ggmap
# https://blog.gtwang.org/r/r-ggmap-package-spatial-data-visualization/3/

pkgs <- c("jsonlite", "httr", "ggmap", "ggplot2")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])] 
if(length(pkgs)) install.packages(pkgs)

library(httr)
library(jsonlite)
options(stringsAsFactors = FALSE)

Sys.setlocale(category = "LC_ALL", locale = "C")

# testing
a <- "string, 123. hah。aha"
gsub("[,.。]", NA, a)


# 1. Get and convert to an R object ---------------------------------------

url <- "http://data.taipei/youbike"
ubike.list <- fromJSON()
class(ubike.list) # list




# 2. list -> vector -> matrix -> data.frame -------------------------------

# Select the right node and unlist it --> vector
ubike.v <- unlist()

# Fold it by a specified width --> matrix
ubike.m <- matrix()


# Convert the matrix to dataframe
ubike.df <- as.data.frame()



# 3. Clean and reformat data ----------------------------------------------

# Get field names from the first data entry and assign to ubike.df
cname <- names(ubike.list$retVal$`0001`)
names(ubike.df) <- cname

# Convert character vectors to numeric
ubike.df$lng <- 
ubike.df$lat <- 
ubike.df$tot <- 
ubike.df$sbi <- 



# 4. Calculation ----------------------------------------------------------

# ratio <- sbi/tot
ubike.df$ratio <- 
summary(ubike.df)




# 5. Plot map by ggplot and ggmap -----------------------------------------

# install.packages("ggplot2")
# install.packages("ggmap") # may raise error
# install.packages("ggmap", type = "source")
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

ggmap(
	get_googlemap(center=c(121.516898,25.055536),
				  zoom=12,
				  maptype='terrain')) +
	geom_point(data=ubike.df, 
			   aes(x=lng, y=lat), 
			   colour=ubike.df$color, 
			   size=ubike.df$tot/10, 
			   alpha=0.4)










# Appendix: ggmap ---------------------------------------------------------

# maptype can be terrain, roadmap, satellite, hybrid, or toner-lite
map <- get_map(location = c(lon = 120.233937, lat = 22.993013),
			   zoom = 10, language = "zh-TW")
ggmap(map, darken = c(0.5, "white"))




# Appendix: An easier way to access ubike data ----------------------------

source <- "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=ddb80380-f1b3-4f8e-8016-7ed9cba571d5"

dataUBike <- fromJSON(readLines(source)[1])

dataUBike <- as.data.frame(dataUBike$result$results)

dataUBike$lng <- as.numeric(dataUBike$lng)
dataUBike$lat <- as.numeric(dataUBike$lat)
dataUBike$tot <- as.numeric(dataUBike$tot)

ggmap(get_googlemap(center=c(121.516898,25.055536),zoom=12,maptype='roadmap'))+ geom_point(data=dataUBike, aes(x=lng, y=lat), colour='red', size=(dataUBike$tot/8), alpha=0.4)
