# title: Paid Maternity Leave
# author: Ji-Lung Hsieh

# The case ----------------------------------------------------------------

# The case adaped Washington Post's paid maternity leave as an exmaple to introduce basic skill of data.frame, plotting, and data mamipulation.
# Link: https://www.washingtonpost.com/news/worldviews/wp/2016/08/13/the-world-is-getting-better-at-paid-maternity-leave-the-u-s-is-not/?tid=sm_tw&utm_term=.f8cd50280326#comments



# 1. Install essential libraries ---------------------------------------------

# Install and import readxl to read excel files
install.packages("readxl")
library(readxl)




# 2. Read the file -----------------------------------------------------------

# the read_excel() function convert a sheet to a data.frame
ldata <- read_excel("data/WORLD-MACHE_Gender_6.8.15.xls", "Sheet1", col_names=T)

# Observing the data using class() or dim(). Is it a data.frame or not?
class(ldata)  # object Classes
mode(ldata) # The (Storage) Mode of an Object
str(ldata) # Display the Structure of an Arbitrary R Object
dim(ldata) # dimension of data.frame

# Show names of vectors (columns) by names()
names(ldata)


# 3. Selecting data in data.frame --------------------------------------------

# Here are three assignments, assigning 3 selections to 3 variables.
col1 <- ldata[1] # select the 1st column
col1_1 <- ldata[ ,1] # select the 1st column
row1 <- ldata[1, ] # select the 1st row

# check the class of the above 3 commands
class(col1)
class(ldata[ ,1])
class(row1)



# Naming rows -------------------------------------------------------------

# Assigning the 3rd column as the dataframe's rownames.
rownames(ldata) <- ldata[, 3]

# Using View(), head(), tail() to preview the data
View(ldata)
head(ldata)
tail(ldata)



# Selecting multiple rows or columns --------------------------------------

# Selecting 6 to 24 cols (matleave 95 to 2013) then assigning to a new variable matleave
matleave <- ldata[ , 6:24]

# See the "Environment" panel to view the data or View() the data
View(matleave)

# Using some functions to observe the data
head(matleave)
tail(matleave)
dim(matleave)
class(matleave)

# Pratice: Selecting the first 5 columns or rows
matleave[, 1:5]
matleave[1:5, ]

# Does it possible to select discontinuous columns?
# e.g., 3rd, 6th to 24th columns
matleave[, c(3, 6:24)]



# Assign value 0 to all NA cells ------------------------------------------

# v[is.na(v)] will select all NA cells
matleave[is.na(matleave)] <- 0

# print out is.na(matleave) to see its content
# is.na() checks cells to see if they are NA cells. If so, return T, or F.
is.na(matleave)

# Practice: selecting with condition
# setting those outliers larger than mean() + sd() to 0
a <- 1:100
a[a > mean(a) + sd(a)] <- 0

# setting those outlier out of mean() +/- sd() to 0
# hint: you may need abs()
a[abs(a - mean(a)) > sd(a)] <- 0

# Deleting outlier and reset a
a <- 1:100
a <- a[abs(a - mean(a)) < sd(a)]
a



# Ploting -----------------------------------------------------------------

# Plotting the second rows
# WILL raise error, Read the error msg word by word
barplot(matleave[2, ])

# Take a look at the data type of matleave[2, ]
class(matleave[2, ])

# Using unlist() to convert a single row dataframe to a vector
barplot(unlist(matleave[2, ]))

# Take a look at the data type of it
unlist(matleave[2, ])
class(unlist(matleave[2, ]))

# plot the row
plot(unlist(matleave[2, ]))

# plot the row by line
plot(unlist(matleave[2, ]), type='l')

# plot the row with y-axis limiation from 0 to 5
plot(unlist(matleave[2, ]), type='l', ylim=range(0, 5))


# Practices I--------------------------------------------------------------
# 1. Add some code to distinguish difference between matleave[2, ] and unlist() version
class(matleave[2, ])
class(unlist(matleave[2, ]))


# 2. barplot() with ylim, add more argument (using `?barplot`)
plot(unlist(matleave[2, ]))



# Plotting multiple charts -------------------------------------------------

# using for loop (for each) to iterate the data you want to plot one by one
for(i in 1:6){
    barplot(unlist(matleave[i, ]), ylim=range(0, 5), space=0, border=NA)
}

# Ploting multiple data in single figure
# Try to search online to see how to plot multiple charts in a figure
par(mfrow=c(3,2))
for(i in 1:6){
    barplot(unlist(matleave[i, ]), ylim=range(0, 5), space=0, border=NA)
}

# Try help() to get more arguments of par()
?par

# Try to eliminate the space between subplot
# Try to search online
par(mfrow=c(3,2), mai= c(0.2, 0.1, 0.1, 0.1))
for(i in 1:6){
    barplot(unlist(matleave[i, ]), ylim=range(0, 5), space=0, border=NA)
}

# Practice: plot more rows to see what happens
par(mfrow=c(3,2), mai= c(0.2, 0.1, 0.1, 0.1))
for(i in 1:10){
    barplot(unlist(matleave[i, ]), ylim=range(0, 5), space=0, border=NA)
}



# Selecting data by condition 2 -------------------------------------------
# Selecting data whose last year is level 5
m5 <- matleave[matleave$'matleave_13'==5, ]

# Selecting one vector by name then checking its data type
matleave$'matleave_13'
class(matleave$'matleave_13')

# Checking the data length the expression
matleave$'matleave_13'==5
length(matleave$'matleave_13'==5)

# How much row do you have?
nrow(m5)




# Selecting then ploting --------------------------------------------------

# Among m5, selecting data whose first year is level 5
m55<- m5[m5$'matleave_95'==5,]

# Plotting
par(mfrow=c(4, 6), mai= c(0.2, 0.1, 0.1, 0.1))
for (i in c(1:nrow(m55))){
    barplot(unlist(m55[i, ]), border=NA, space=0,xaxt='n', yaxt='n', ylim = range(0:5))
}


# How do you add title for each subplot?
par(mfrow=c(4,6), mai= c(0.2, 0.1, 0.1, 0.1))
for (x in c(1:nrow(m55))){
    barplot(unlist(m55[x, ]), border=NA, space=0,xaxt='n', yaxt='n', ylim = range(0:5))
    title(rownames(m55)[x], line = -4, cex.main=3)
}



# Practice II--------------------------------------------------------------

# Printing out those whose matleave_95 is not 5 but matleve_13 is 5
m05<- m5[m5$'matleave_95'!=5,]
par(mfrow=c(4,6), mai= c(0.2, 0.1, 0.1, 0.1))
for (x in c(1:nrow(m05))){
    barplot(unlist(m05[x, ]), border=NA, space=0,xaxt='n', yaxt='n', ylim = range(0:5))
    title(rownames(m05)[x], line = -4, cex.main=3)
}

# Making barchart for those matleave_13 equal to 4 and lower than 4.




# Drawing worldmap --------------------------------------------------------

# Install rworldmap
install.packages("rworldmap")
library(rworldmap)# drawing worldmap


# Selecting iso3 vector and matleave data
mdata <-

# join your data with the world map data
myMap <- joinCountryData2Map(mdata, joinCode = "ISO3", nameJoinColumn = "iso3")

# Draw world maps
colors <- c("#FF8000", "#A9D0F5", "#58ACFA", "#0080FF", "#084B8A")

mapCountryData(myMap
               , nameColumnToPlot="matleave_13"
               , catMethod = "categorical"
               , colourPalette = colors
               , addLegend='FALSE'
)

# Drawing other year's map
mapCountryData(

)

# Drawing multiple wordmap ------------------------------------------------

# Remember to setting par() for plotting as subplots
par(mfrow=c(4,5), mai= c(0.2, 0.1, 0.1, 0.1))

# Notice: myMap is a combined data, where are your data columns?
for(i in _________){
    mapCountryData(myMap
                   , nameColumnToPlot = ________________
                   , catMethod = "categorical"
                   , colourPalette = colors
                   , addLegend='FALSE'
    )
}




# Summarize data ----------------------------------------------------------

# Selecting 1 to 24 vectors to tdata
tdata <-

# Dealing with NA
tdata[is.na(tdata)] <- 0

# Creating contigency table by region for matleave_13: data count by length()
num <- tapply(ldata$matleave_13, ldata$region, length)

# tapply() using mean(), sum(), and sd
average <-
total <-
std <-

# Creating data frame for about variables
res <-
res


# Grouping data: merge rows by categoriy ----------------------------------
byregion <- aggregate(tdata[,6:24],by=list(tdata$region), mean)

# take a look at byregion data
aggregate(tdata[ ,6:24],by=list(tdata$region), mean)
head(byregion)




# Plotting results --------------------------------------------------------

# Line ploting the 1st row
plot(________________, type="o")

# Line ploting the 2nd~6th rows



# Using for-loop and par() to plot all graph
par(mfrow=c(3,2), mai= c(0.4, 0.4, 0.1, 0.1))



