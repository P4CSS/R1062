# ___READ JSON___ ---------------------------------------------------------

# Slide: https://docs.google.com/presentation/d/e/2PACX-1vTFRVkwdscR3QNdVD6Q8JEKshlORtgdP_DUq19HPjbO6_8nN3ADTEtxuOr_Z28t3HKGdf9_m3icULpO/pub?start=false&loop=false&delayms=3000&slide=id.g2074c710b4_0_302
# Youtube: https://www.youtube.com/playlist?list=PLK0n8HKZQ_VfJcqBGlcAc0IKoY00mdF1B
pkgs <- c("jsonlite", "httr")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs)

library(httr)
library(jsonlite)
options(stringsAsFactors = F)



# 1.0 Well-formated Hospital revisits ------------------------------------

# fromJSON() converts text to a data.frame

# the url is a character variable, not a vector
url <- "http://data.nhi.gov.tw/Datasets/DatasetResource.ashx?rId=A21030000I-E30008-002&ndctype=JSON&ndcnid=18585"

# jsonlite::fromJSON converts JSON to R objects, will be a list or a data.frame
df <- fromJSON(content(GET(url), "text"))
str(df)


# 1.1 GET() to request and obtain the response ----------------------------

response <- GET(url)
class(response)
??httr::GET


# 1.2 httr::content() Extract content from a request ----------------------
text <- content(response, "text")
class(text)
??httr::content


# 1.3 jsonlite::fromJSON() ------------------------------------------------

# convert between JSON data and R objects.
df.test <- fromJSON(text)
?fromJSON
# https://www.r-bloggers.com/dealing-with-a-byte-order-mark-bom/




# Practice01 --------------------------------------------------------------

# Read json by following urls

url_AQI <- "http://opendata.epa.gov.tw/ws/Data/REWIQA/?$orderby=SiteName&$skip=0&$top=1000&format=json"
url_rent591 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
url_dcard <- "https://www.dcard.tw/_api/forums/girl/posts?popular=true"
url_pchome <- "http://ecshweb.pchome.com.tw/search/v3.3/all/results?q=X100F&page=1&sort=rnk/dc"
url_udn <- "https://video.udn.com/realtime/general"
url_104 <- "https://www.104.com.tw/jobs/search/list?ro=0&keyword=%E8%B3%87%E6%96%99%E5%88%86%E6%9E%90&area=6001001000&order=1&asc=0&kwop=7&page=2&mode=s&jobsource=n104bank1"
url_foodRumor <- "http://data.fda.gov.tw/cacheData/159_3.json"
url_ubike <- "http://data.taipei/youbike"
url_cht <- "https://www.googleapis.com/customsearch/v1element?key=AIzaSyCVAXiUzRYsML1Pv6RwSG1gunmMikTzQqY&rsz=1&num=20&hl=zh_TW&prettyPrint=false&source=gcsc&gss=.com&sig=0c3990ce7a056ed50667fe0c3873c9b6&cx=013510920051559618976:klsxyhsnf7g&q=%E9%85%92%E9%A7%95&lr=&filter=1&sort=&googlehost=www.google.com&callback=google.search.Search.apiary7677&nocache=1481218832065"

res <- fromJSON(content(GET(url_rent591), "text"))



# 2. Well-formatted: AQI --------------------------------------------------
# Well-formatted json, a [] contains {} pairs

url <- "http://opendata.epa.gov.tw/ws/Data/REWIQA/?$orderby=SiteName&$skip=0&$top=1000&format=json"
res <- fromJSON(content(GET(url), "text"))



# 3. Well-formatted but hierarchical --------------------------------------

url_rent591 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res <- fromJSON(content(GET(url_rent591), "text"))

# Access the right level of nodes
View(res$data$data)


# (option) Get and write to disck
response <- GET(url_rent591, write_disk("data/rent591_original.json", overwrite=TRUE))





# 4. Ill-formatted JSON: food Rumor ---------------------------------------

# non-typical json, not a [] containing {} pairs


url <- 'http://data.fda.gov.tw/cacheData/159_3.json'
safefood <- fromJSON(content(GET(url),'text'))
class(safefood[[1]])
dim(safefood[[1]])
View(safefood[[1]])
str(safefood)
class(safefood)

# try to convert to data.frame directly
# safefood.df <- as.data.frame(safefood)

# Download the data to take a look on it
# Its data shows regular patterns but not a well-formatted [] and {}
# file <- GET(url, write_disk("../data/safefood.json", overwrite=TRUE))

# unlist() converts (de-stractify) a list to a vector
safefood.v <- unlist(safefood)
head(safefood.v, n=20)

# anyNA() to check if NAs still exist
anyNA(safefood.v)

# (option) check if NAs exist
is.na(safefood.v)
sum(is.na(safefood.v))

# remove NAs
safefood.v <- safefood.v[!is.na(safefood.v)]
# length(safefood.v)

# double-check NAs
anyNA(safefood.v)
safefood.v


# convert vector to matrix
safefood.m <- matrix(safefood.v, byrow = T, ncol = 5)
# ?matrix

# convert matrix to dataframe
safefood.df <- as.data.frame(safefood.m)

# delete the 4th column
safefood.df <- safefood.df[-4]

# naming the data.frame
names(safefood.df) <- c('category', 'question', 'answer', 'timestamp')



# # 5. json embedded in javascript ------------------------------------------
#
# url <- "https://www.googleapis.com/customsearch/v1element?key=AIzaSyCVAXiUzRYsML1Pv6RwSG1gunmMikTzQqY&rsz=1&num=20&hl=zh_TW&prettyPrint=false&source=gcsc&gss=.com&sig=0c3990ce7a056ed50667fe0c3873c9b6&cx=013510920051559618976:klsxyhsnf7g&q=%E9%85%92%E9%A7%95&lr=&filter=1&sort=&googlehost=www.google.com&callback=google.search.Search.apiary7677&nocache=1481218832065"
# text <- content(GET(url), 'text')
# head(text)
# text
# text <- substr(text, 49, nchar(text)-2)
# res <- fromJSON(text)
# View(res$results)





# 6. String substitution: food Rumor --------------------------------------

# safefood example
url <- 'http://data.fda.gov.tw/cacheData/159_3.json'
safefood <- fromJSON(content(GET(url),'text'))
safefood.v <- unlist(safefood)
safefood.v <- safefood.v[!is.na(safefood.v)]
safefood.m <- matrix(safefood.v, byrow = T, ncol = 5)
safefood.df <- as.data.frame(safefood.m)
safefood.df <- safefood.df[-4]
names(safefood.df) <- c('category', 'question', 'answer', 'timestamp')

# replace specified words
safefood.df$answer <- gsub("解答：", "", safefood.df$answer)

# replace all characters between <> in non-greedy search

safefood.df$answer <- gsub("<.*?>", "", safefood.df$answer)

# replace all space characters including \n \t
str <- c("<111>12 	312 313</html>1", "<111>     123   123123<111>2")
gsub("<.*>", "", str)

safefood.df$answer <- gsub("\\s", "", safefood.df$answer)



# replace questions befor (1)
# safefood.df$answer <- gsub("^.*\\(1\\)", "(1)", safefood.df$answer)
# answer.lens <- sapply(safefood.df$answer, nchar)
# summary(answer.lens)

# build a function to clean html tag
# cleanFun <- function(htmlString) {
#   htmlString <- gsub("<.*?>", "", htmlString)
#   htmlString <- gsub("&nbsp;", "", htmlString)
#   htmlString <- gsub("解答：", "", htmlString)
#   return(htmlString)
# }
#
# safefood.df$answer <- cleanFun(safefood.df$answer)







# 7. Convert a time string to an R object ------------------------------

# ?strptime
# ?format
# ?POSIXct
# ?POSIXlt


# 7.1 strptime() converts string to POSIXlt -------------------------------

# convert strings to time objects by specified format
safefood.df$ltime <- strptime(safefood.df$timestamp, "%m %e %Y")
class(safefood.df$ltime)



# 7.2 Accessing features of timestamps ------------------------------------

# safefood.df$ltime$hour
safefood.df$ltime$mday
safefood.df$ltime$month
safefood.df$ltime$year # year since 1900
safefood.df$ltime$wday # 0~6 day of the week
safefood.df$ltime$yday # 0~365 day of the year
safefood.df$ltime$zone # ChungYuan Standard Time
class(as.Date("2017-01-01"))
class(as.POSIXct("2017-01-08"))




# 7.3 Convert number to POSIXct and time zone -----------------------------

# time zone converter
# http://www.timezoneconverter.com/cgi-bin/zoneinfo?tz=America/New_York

z <- 7.343736909722223e5
as.POSIXct((z - 719529)*86400, origin = "1970-01-01", tz = "UTC")
as.POSIXlt((z - 719529)*86400, origin = "1970-01-01", tz = "Asia/Taipei")

z <- 1509343484914
as.POSIXct(z/1000, origin="1970-01-01", tz="Asia/Taipei")

as.POSIXct(Sys.time(), tz="CST")
as.POSIXct(Sys.time(), tz="Asia/Taipei")
as.POSIXlt(Sys.time(), tz="CST")
as.POSIXlt(Sys.time(), tz="America/New_York")
as.POSIXlt(Sys.time(), tz="Asia/Taipei")
as.POSIXlt(Sys.time(), tz="Asia/Tokyo")
# GMT: Greenwich Mean Time (is not verified scientifically)
# UTC: Coordinated Universal Time (closed to GMT in most of circumstance)
class(safefood.df$ltime)	# POSIXlt
safefood.df$ctime <- as.POSIXct(safefood.df$ltime) # POSIXct

months(safefood.df$ctime)
weekdays(safefood.df$ltime)
sort(safefood.df$ctime)
sort(safefood.df$ltime)



# 7.4 Set locale of time --------------------------------------------------

Sys.setlocale(category = "LC_ALL", locale = "C")



# 7.5 Convert a POSIXct to a string ---------------------------------------

format(safefood.df$ctime, "%m-%d-%Y")



# 7.6 Access system time --------------------------------------------------

# Access system time and date
Sys.time()
Sys.Date()

# measure code running time
start <- proc.time()
# your code here
proc.time() - start





# Appendix: Downloading JSON files ----------------------------------------
url <- 'http://data.nhi.gov.tw/Datasets/DatasetResource.ashx?rId=A21030000I-E30008-002&ndctype=JSON&ndcnid=18585'
res <- GET(url, write_disk("../data/hospital_retreat.json", overwrite=TRUE))
library(jsonlite)
test2 <- fromJSON(res$request$output$path)

url <- 'http://data.fda.gov.tw/cacheData/159_3.json'
GET(url, write_disk("../data/safefood.json", overwrite=TRUE))

url <- "http://data.taipei/youbike"
GET(url, write_disk("../data/ubikeSample.json", overwrite=TRUE))
