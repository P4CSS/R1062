# The case ----------------------------------------------------------------

# The case adaped Washington Post's paid maternity leave as an exmaple to introduce basic skill of data.frame, plotting, and data mamipulation.
# Link: https://www.washingtonpost.com/news/worldviews/wp/2016/08/13/the-world-is-getting-better-at-paid-maternity-leave-the-u-s-is-not/?tid=sm_tw&utm_term=.f8cd50280326#comments



# Install and import readxl for reading excel -----------------------------

# install.packages("readxl")
library(readxl)


# The clean version =======================================================

# Change word directory(wd) to specified directory
# setwd("/Users/yoshitakasha/Dropbox/Programming/R/dssi106")
ldata <- read_excel("data/WORLD-MACHE_Gender_6.8.15.xls", "Sheet1", col_names=T)

# select columns by index
matleave <- ldata[ , c(3, 6:24)]
str(matleave)

# select all NA cells and assign 0 to them
matleave[is.na(matleave)] <- 0

# filter rows by condition
m5 <- matleave[matleave$'matleave_13' == 5, ]


# filter rows by condition
m55<- m5[m5$'matleave_95' == 5,]



# plot
par(mfrow=c(4,6), mai= c(0.2, 0.2, 0.2, 0.2))
for (i in c(1:nrow(m55))){
	barplot(unlist(m55[i,-1]),
			border=NA, space=0,xaxt="n", yaxt="n", ylim = c(0,5))
	title(m55[i,1], line = -4, cex.main=3)
}




# Learner version =========================================================
?read_excel
# read_excel(path, sheet = NULL, range = NULL, col_names = TRUE,
# 		   col_types = NULL, na = "", trim_ws = TRUE, skip = 0, n_max = Inf,
# 		   guess_max = min(1000, n_max))

# read_excel() convert a sheet to a data.frame
ldata <- read_excel("data/WORLD-MACHE_Gender_6.8.15.xls", "Sheet1", col_names=T)


# Observing the data using class() or dim(). Is it a data.frame or not?
View(ldata)
class(ldata)		# [1] "tbl_df"     "tbl"        "data.frame"
dim(ldata)

# Show names of vectors (columns) by names()
names(ldata)



# Selecting multiple rows or columns --------------------------------------

# select 3 and 6 to 24 columns
matleave <- ldata[ , c(3, 6:24)]
class(matleave)
dim(matleave)
str(matleave)	# structure of



# Assign value 0 to all NA cells ------------------------------------------
# NA: Not Available

# v[is.na(v)] will select all NA cells
matleave[is.na(matleave)] <- 0

# checks if there are still NA cells.
anyNA(matleave)

# check if NAs still exist
# is.na() will return TRUE/FALSE whose size equals to a data.frame or vector
# TRUE converting to numeric is 1, while FALSE is 0
# Therefore, sum() of TRUE/FALSE vector will return the number of TRUE
sum(is.na(matleave))





# Plot one row ------------------------------------------------------------

# Plotting the second rows and all columns except 1st column
barplot(unlist(matleave[2, -1]))


# Why unlist()
# Read the error msg word by word
barplot(matleave[2, -1])
# Error in barplot.default(matleave[2, -1]) :
# 	'height' must be a vector or a matrix

# Take a look at the data type of matleave[2, ]
class(matleave[2, -1])

# Using unlist() to convert a single row dataframe to a vector
unlist(matleave[2, -1])
class(unlist(matleave[2, -1]))

# Add more arguments
barplot(unlist(matleave[2, -1]))
barplot(unlist(matleave[2, -1]), ylim=c(0, 5))
barplot(unlist(matleave[2, -1]), ylim=c(0, 5), space=0)
barplot(unlist(matleave[2, -1]), ylim=c(0, 5), space=0, border=NA)
barplot(unlist(matleave[2, -1]), ylim=c(0, 5), space=0, border=NA, xaxt="n", yaxt="n")



# Select data in tbl_df ---------------------------------------------------

View(matleave[1]) # select the 1st variable
View(matleave[ ,1]) # select the 1st column
View(matleave[1, ]) # select the 1st row

class(matleave[1])		# "tbl_df"     "tbl"        "data.frame"
class(matleave[ ,1])	# "tbl_df"     "tbl"        "data.frame"
class(matleave[1, ])	# "tbl_df"     "tbl"        "data.frame"
class(matleave$iso3)	# character (vector)




# for loop to plot multiple charts ----------------------------------------


# plot the 1st to 6th rows
barplot(unlist(matleave[1, -1]), ylim=c(0, 5), space=0, border=NA, xaxt="n", yaxt="n")
barplot(unlist(matleave[2, -1]), ylim=c(0, 5), space=0, border=NA, xaxt="n", yaxt="n")
barplot(unlist(matleave[3, -1]), ylim=c(0, 5), space=0, border=NA, xaxt="n", yaxt="n")
barplot(unlist(matleave[4, -1]), ylim=c(0, 5), space=0, border=NA, xaxt="n", yaxt="n")
barplot(unlist(matleave[5, -1]), ylim=c(0, 5), space=0, border=NA, xaxt="n", yaxt="n")
barplot(unlist(matleave[6, -1]), ylim=c(0, 5), space=0, border=NA, xaxt="n", yaxt="n")

# using for loop (for each) to iterate the data you want to plot one by one
for(i in 1:6){
  barplot(unlist(matleave[i, -1]), ylim=c(0, 5), space=0, border=NA, xaxt="n", yaxt="n")
}


# Plot subplots -----------------------------------------------------------
?par

# mai:
# A numerical vector of the form c(bottom, left, top, right) which gives the margin size specified in inches.

# mfcol, mfrow:
# A vector of the form c(nr, nc). Subsequent figures will be drawn in an nr-by-nc array on the device by columns (mfcol), or rows (mfrow), respectively.

par(mfrow=c(3,2), mai= c(0.2, 0.2, 0.2, 0.2))
for(i in 1:6){
  barplot(unlist(matleave[i, -1]), ylim=c(0, 5), space=0, border=NA, xaxt="n", yaxt="n")
}



# Practice ----------------------------------------------------------------

# plot more rows to see what happens
par(mfrow=c(3,2), mai= c(0.2, 0.2, 0.2, 0.2))
for(i in 1:10){
    barplot(unlist(matleave[i, -1]), ylim=c(0, 5), space=0, border=NA, xaxt="n", yaxt="n")
}

# plot all subplots in a figure




# Filter data by the last year value --------------------------------------

m5 <- matleave[matleave$'matleave_13'==5, ]
nrow(m5)

# matleave$'matleave_13'
# matleave$'matleave_13'==5
# length(matleave$'matleave_13'==5)



# Filter data by the first year value -------------------------------------

# filter rows whose 'matleave_95' is 5
m55<- m5[m5$'matleave_95'==5,]

# filter rows whose 'matleave_95' is not 5
m05<- m5[m5$'matleave_95'!=5,]



# Plot m55 ----------------------------------------------------------------
nrow(m55)

par(mfrow=c(4, 6), mai= c(0.2, 0.2, 0.2, 0.2))
for (i in 1:nrow(m55)){
  barplot(unlist(m55[i, -1]), border=NA, space=0, xaxt="n", yaxt="n", ylim = c(0,5))
}


# How do you add title for each subplot?
par(mfrow=c(4,6), mai= c(0.2, 0.2, 0.2, 0.2))
for (i in 1:nrow(m55)){
    barplot(unlist(m55[i, -1]), border=NA, space=0,xaxt="n", yaxt="n", ylim = c(0,5))
	title(m55[i,1], line = -4, cex.main=3)
}




# Practice ----------------------------------------------------------------

# plotting matleave_95 != 5 but matleve_13 == 5

# plotting for matleave_13 == 4

# Select, and filter data in dplyr form

# by dplyr
library(dplyr)
m55 <- ldata %>%
    select(iso3, contains("matleave"), -contains("wrr")) %>%
    mutate_if(is.numeric, function(x){ifelse(is.na(x), 0, x)}) %>%
    filter(matleave_13==5, matleave_95==5)



# More: gather() to long-form ---------------------------------------------
library(tidyr)

# Gather 2:20 column to a new variable "year"
# Name level data as "degree"
long_form <- gather(matleave, "year", "degree", 2:20)



# Drawing worldmap --------------------------------------------------------

# install.packages("rworldmap")
library(rworldmap)# drawing worldmap

# select cols
mdata <- ldata[,c(3, 6:24)]

# join your data with the world map data
myMap <- joinCountryData2Map(mdata, joinCode = "ISO3", nameJoinColumn = "iso3")
# 196 codes from your data successfully matched countries in the map
# 1 codes from your data failed to match with a country code in the map
# 47 codes from the map weren't represented in your data

myMap$matleave_13


# Draw world maps
dev.off()
mapCountryData(myMap
               , nameColumnToPlot="matleave_13"
               , catMethod = "categorical"
)


# self-defined colors
colors <- c("#FF8000", "#A9D0F5", "#58ACFA", "#0080FF", "#084B8A")
mapCountryData(myMap
			   , nameColumnToPlot="matleave_13"
			   , catMethod = "categorical"
			   , colourPalette = colors
			   , addLegend="FALSE"
)




# Practice ----------------------------------------------------------------

# Drawing map for the first year

# Remember to setting par() for plotting as subplots
par(mfrow=c(4,5), mai= c(0.2, 0.2, 0.2, 0.2))
for(i in 51:69){
    mapCountryData(myMap
                   , nameColumnToPlot=names(myMap)[i]
                   , catMethod = "categorical"
                   , colourPalette = colors
                   , addLegend="FALSE"
                   )
}




# Summarize data ----------------------------------------------------------

# select 1 to 24 vectors
tdata <- ldata[ ,1:24]
names(tdata)

# deal with NAs
tdata[is.na(tdata)] <- 0

# create contigency table by region for matleave_13: data count by length()
num <- tapply(ldata$matleave_13, ldata$region, length)

# tapply() using mean(), sum(), and sd
total <- tapply(ldata$matleave_13, ldata$region, mean)
average <- tapply(ldata$matleave_13, ldata$region, sum)
sd <- tapply(ldata$matleave_13, ldata$region, sd)

# create data frame for about variables
res <- data.frame(num, average, total, sd)
View(res)



# Grouping data: merge rows by category -----------------------------------

byregion <- aggregate(tdata[,6:24], by=list(tdata$region), mean)
View(byregion)
byregion.sd <- aggregate(tdata[,6:24], by=list(tdata$region), sd)
?aggregate

head(byregion)




# Plotting results --------------------------------------------------------

# Line ploting the 1st row
dev.off()
plot(unlist(byregion[1,]), type="o")

# Line ploting the 2nd~6th rows
plot(unlist(byregion[2,]), type="o")
plot(unlist(byregion[3,]), type="o")
plot(unlist(byregion[4,]), type="o")
plot(unlist(byregion[5,]), type="o")
plot(unlist(byregion[6,]), type="o")



# Using for-loop and par() to plot all graph
par(mfrow=c(3,2), mai= rep(0.3, 4))
for (i in 1:6){
    plot(unlist(byregion[i,-1]), type="o", ylim=c(0, 5))
	title(byregion[i,1])
}




# staySame version
# staySame <- apply(m5[,2:20], 1, function(x) length(unique(x[!is.na(x)]))) == 1
# m55 <- m5[staySame, ]
# m50 <- m5[!staySame, ]




# by dplyr ----------------------------------------------------------------

library(dplyr)
library(tidyr)
library(ggplot2)

long_form <- gather(matleave, "year", "degree", 2:20)

matleave <- ldata %>%
	select(iso3, contains("matleave"), -contains("wrr")) %>%
	filter(matleave_13==5, matleave_95==5) %>%
	gather("year", "degree", 2:20) %>%
	replace_na(list(degree=0)) %>%
	mutate(year2=as.POSIXct(strptime(year, "matleave_%y"))) %>%
	mutate(year3 = strftime(year2, "%Y"))

matleave %>%
	ggplot() +
	aes(year3, degree) +
	facet_grid(iso3~.) +
	geom_bar(stat = "identity", fill = "blue")
