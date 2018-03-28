# __READ CSV__ ------------------------------------------------------------
# Slide: https://docs.google.com/presentation/d/e/2PACX-1vTFRVkwdscR3QNdVD6Q8JEKshlORtgdP_DUq19HPjbO6_8nN3ADTEtxuOr_Z28t3HKGdf9_m3icULpO/pub?start=false&loop=false&delayms=3000&slide=id.g2074c710b4_0_302
# Youtube: https://www.youtube.com/playlist?list=PLK0n8HKZQ_VfJcqBGlcAc0IKoY00mdF1B
pkgs <- c("readr", "httr", "RColorBrewer", "dplyr", "tidyr")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs)





# 01. Open local file ------------------------------------------------------
# 02. File encoding problem ------------------------------------------------

### Taipei open data link http://data.taipei/opendata/datalist/datasetMeta?oid=68785231-d6c5-47a1-b001-77eec70bec02

### Download the data and pull into your project data folder
### Will raise error due to lack of fileEncoding argument
df <- read.csv(url("http://data.taipei/opendata/datalist/datasetMeta/download;jsessionid=A97052570C470793042D8B2D33A849ED?id=68785231-d6c5-47a1-b001-77eec70bec02&rid=34a4a431-f04d-474a-8e72-8d3f586db3df"))
df <- read.csv("data/tp_theft.csv")
?read.csv

### Character will be converted to factor
df <- read.csv("data/tp_theft.csv",
			   fileEncoding = "big5")
str(df)

df <- read.csv("data/tp_theft.csv",
			   fileEncoding = "big5",
			   stringsAsFactors = F)
str(df)




# 03. Read url directly ----------------------------------------------------

library(httr)
options(stringsAsFactors = F)

url <- "http://data.taipei/opendata/datalist/datasetMeta/download?id=68785231-d6c5-47a1-b001-77eec70bec02&rid=34a4a431-f04d-474a-8e72-8d3f586db3df"
df <- read.csv(url, fileEncoding = "big5")
str(df)



# __STRING OPERATIONS__ ---------------------------------------------------

# 04. substr() to get substring --------------------------------------------

# Using substr to get timestamp by jour
df$time <- substr(df$發生時段, 1, 2)

# Getting regions
df$region <- substr(df$發生.現.地點, 4, 5)





# __SUMMARIZING DATA__ ----------------------------------------------------

# 05. tapply() to summarize data -------------------------------------------
?tapply
# tapply(x, y, func)
# summarize x col by y col in func function

# count events occurring in different time periods
tapply(df$編號, df$time, length)
tapply(df$編號, df$region, length)

# tapply(df$編號, df$time, mean) # meaningless, why?
# tapply(df$編號, df$time, sum) # meaningless
# tapply(df$編號, df$time, median) # meaningless

# summarized by two variables
res <- tapply(df$編號, list(df$time, df$region), length)
class(res)
View(res)



# 06. summarized by table() ------------------------------------------------
?table
?with # avoiding to type df repeatedly

res <- table(df$time, df$region)
View(res)
class(res)
res


# res <- with(df, table(time, region))
# class(res)



# 07. Summarized by aggregate() --------------------------------------------

?aggregate # Splits the data into subsets, computes summary statistics for each, and returns the result in a convenient form

# summarizing whole data.frame
res2 <- aggregate(df, by=list(df$time, df$region), length)
View(res2)

# due to we only need to count the occurrences, we can summarize single col directly.
res3 <- aggregate(df$編號, by=list(df$time, df$region), length)
View(res3)
class(res3) # data.frame
# tidyr::spread() converts long-form to table form
??tidyr::spread # Spread a key-value pair across multiple columns.

# install.packages("tidyr")
library(tidyr)

res4 <- spread(res3, Group.2, x, fill = 0)
View(res4)
class(res4)


# 08. Summarized by count() ------------------------------------------------
??dplyr::count

res5 <- dplyr::count(df, time, region)
res6 <- spread(res5, region, n, fill = 0)
View(res6)


# __PLOT__ ----------------------------------------------------------------
# 09. Plotting category data -----------------------------------------------

# mosaicplot
dev.off()
mosaicplot(t)
mosaicplot(res, main="mosaic plot")

# check the number of columns and rows
ncol(res)

# associate plot
assocplot(res)



# 10. Ploting options --------------------------------------------------------

# Setting Chinese font for OSX
par(family=('Heiti TC Light'))
par(family=('STKaiti'))

# Setting the color by yourself.
colors <- c('#D0104C', '#DB4D6D', '#E83015',  '#F75C2F',
            '#E79460', '#E98B2A', '#9B6E23', '#F7C242',
            '#BEC23F', '#90B44B', '#66BAB7', '#1E88A8')
mosaicplot(res, color=colors, border=0, off = 3,
		   main="Theft rate of Taipei city (region by hour)")




# *Practice01. Summarizing -------------------------------------------------

# Check what happens if you swap the time and region in tapply()

# does it possible to extract month  by substr()?
# (you may need to search how to extract the last n characters in R)
x <- df$發生.現.日期
df$month <- substr(x, nchar(x)-3, nchar(x)-2)
res2 <- tapply(df$編號, list(df$month, df$region), length)
res2 <- tapply(df$編號, list(df$region, df$month), length)
mosaicplot(res2, color=colors, border=0, off = 3, main="Theft rate of Taipei city (region by hour)")










# __GET or WRITE to DISK__ ------------------------------------------------


# 11. wirte_disk() to local directory -------------------------------------

# Specify an url to get
url <- 'http://data.nhi.gov.tw/Datasets/DatasetResource.ashx?rId=A21030000I-E30008-001&ndctype=CSV&ndcnid=18585'

# Get url and wirte to disk
test <- GET(url, write_disk("data/retreat.csv", overwrite=TRUE))

# Read file
path <- test$request$output$path
df <- read.csv(path)
class(df)




# 12. GET() then parse it directly ----------------------------------------

text <- content(GET(url), "text", encoding="utf-8")
df <- read.csv(textConnection(text), sep=",")
class(df)
View(head(df))



# A1. ColorBrewer ---------------------------------------------------------

# See http://colorbrewer2.org/
# install.packages('RColorBrewer')
library(RColorBrewer)
pcolor <- brewer.pal(12, "Paired")
pcolor
mosaicplot(res, color=pcolor, border=0, off = 3, main="Theft rate of Taipei city (region by hour)")



# A2. readr::read_csv() ---------------------------------------------------

# As far as I'm concerned,
# readr package provides "better" function to read files.

library(httr)
url <- "http://data.nhi.gov.tw/Datasets/DatasetResource.ashx?rId=A21030000I-E30008-001"
res <- content(GET(url), "text")
df1 <- read.csv(res) # bad function
View(df1)

# better function to read UTF-8 large data
library(readr)
df2 <- read_csv(res)
??read_csv

