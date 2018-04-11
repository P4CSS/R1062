
# Loading libraries -------------------------------------------------------

pkgs <- c("jsonlite", "httr")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs)

library(httr)
library(jsonlite)
options(stringsAsFactors = F)



# 1.0 Well-formated Hospital revisits ------------------------------------
# Using fromJSON() to convert text to an R object (data.frame or list)

# the url (a character variable, not a vector)
url <- "http://opendata.epa.gov.tw/ws/Data/REWIQA/?$orderby=SiteName&$skip=0&$top=1000&format=json"

# jsonlite::fromJSON converts JSON to R objects, will be a list or a data.frame
df <- fromJSON(content(GET(url), "text", encoding = "utf-8"))
str(df)


# 1.1 GET() to request and obtain the response ----------------------------
response <- GET(url)
class(response)
??httr::GET


# 1.2 httr::content() Extract content from a request ----------------------
text <- content(response, "text", encoding = "utf-8")
class(text)
??httr::content


# 1.3 jsonlite::fromJSON() ------------------------------------------------
# convert between JSON data and R objects.
df <- fromJSON(text)
?fromJSON




# Practice01 --------------------------------------------------------------
# Read json by following urls

url_rent591 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
url_reHospital <- "http://data.nhi.gov.tw/Datasets/DatasetResource.ashx?rId=A21030000I-E30008-002&ndctype=JSON&ndcnid=18585"
url_dcard <- "https://www.dcard.tw/_api/forums/girl/posts?popular=true"
url_pchome <- "http://ecshweb.pchome.com.tw/search/v3.3/all/results?q=X100F&page=1&sort=rnk/dc"
url_104 <- "https://www.104.com.tw/jobs/search/list?ro=0&keyword=%E8%B3%87%E6%96%99%E5%88%86%E6%9E%90&area=6001001000&order=1&asc=0&kwop=7&page=2&mode=s&jobsource=n104bank1"
url_ubike <- "http://data.taipei/youbike"

res <- fromJSON(content(GET(url_rent591), "text", encoding = "utf-8"))


# 2. Well-formatted but hierarchical --------------------------------------
url_rent591 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res <- fromJSON(content(GET(url_rent591), "text", encoding = "utf-8"))

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





# Appendix: Downloading JSON files ----------------------------------------
url <- 'http://data.nhi.gov.tw/Datasets/DatasetResource.ashx?rId=A21030000I-E30008-002&ndctype=JSON&ndcnid=18585'
res <- GET(url, write_disk("../data/hospital_retreat.json", overwrite=TRUE))
library(jsonlite)
test2 <- fromJSON(res$request$output$path)

url <- 'http://data.fda.gov.tw/cacheData/159_3.json'
GET(url, write_disk("../data/safefood.json", overwrite=TRUE))

url <- "http://data.taipei/youbike"
GET(url, write_disk("../data/ubikeSample.json", overwrite=TRUE))
