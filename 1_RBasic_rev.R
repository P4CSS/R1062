# Slide: https://docs.google.com/presentation/d/e/2PACX-1vRjb_W1Vo9-zD9F4FmWOiB6K4ezkF6W64OKcX7bZD6ordKvOT-6LFoGi0le-HzT2ABKudDNhr_qKt2x/pub?start=false&loop=false&delayms=3000&slide=id.g2074c710b4_0_293
# 2017/09/24 Updated 


# 0. Installing essential packages ----------------------------------------
# install a pacakge from R-cran https://cran.r-project.org/web/packages/available_packages_by_name.html
# The package will be downloaded and installed to your computer, 
# BUT not yet loaded into your current environment.
install.packages("tidyverse")




# 0. The data -------------------------------------------------------------

# Text data: trump's tweets
msg <- load(url("http://varianceexplained.org/files/trump_tweets_df.rda"))
View(trump_tweets_df)
names(trump_tweets_df)


# Text data: dcard articles
library(jsonlite)	# loading installed jsonlite to read json
library(httr)		# loading httr to get data from the web

url <- "https://www.dcard.tw/_api/forums/relationship/posts?popular=true"
res <- fromJSON(content(GET(url), "text"))
View(res)
names(res)



# Text data: facebook page of DoctorKoWJ
fburl <- 
	"https://graph.facebook.com/v2.10/DoctorKoWJ?fields=posts&access_token=188730144854871|1lL4a4CTRymAHvoKxnJDQqvqVdc"

res <- fromJSON(content(GET(fburl), "text"))
posts <- res$posts$data
View(posts)
names(posts)


# Data: rent591 renting cases
url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res1 <- fromJSON(content(GET(url1), "text"))
all.df <- res1$data$data


library(tidyverse)
# Open data: Home theft cases of Taipei
url <- "http://data.taipei/opendata/datalist/datasetMeta/download?id=68785231-d6c5-47a1-b001-77eec70bec02&rid=34a4a431-f04d-474a-8e72-8d3f586db3df"
df <- read.csv(url, fileEncoding = "big5")


# df1. take a glance at data.frame ----------------------------------------


View(df)
head(df)	# get first part of the data.frame
class(df)

summary(df)
# look up help
help(summary)
?summary




# df2. Dimension of data.frame -------------------------------------------------

dim(df)
ncol(df)
nrow(df)
length(df)
names(df)



# df3. data.frame and vectors --------------------------------------------------

df$發生.現.地點
df$發生時段
length(df$發生時段)

str(df)

class(df$發生.現.日期)
class(df$發生時段)
class(df$發生.現.地點)

df <- read.csv(url, fileEncoding = "big5", stringsAsFactors = FALSE)
str(df)





# v0. data and variable ---------------------------------------------------
c("1, 2, 3")
c(1, 2, 3)
c("1", "2", "3")
2/3 + cos(1+5)
exp(3)

# Assignment: object_name <- value, or variable <- value
x <- 1 + 2 + 3 + 4 * 5
x
theft_tp <- read.csv(url, fileEncoding = "big5", stringsAsFactors = FALSE)
x1 <- c(1, 2, 3, 4, 5)
x2


# v1. Create vectors ----------------------------------------------------------
# also Initiating vectors

# http://cus93.trade.gov.tw/FSC3040F/FSC3040F?menuURL=FSC3040F
country <- c("CN", "US", "JP", "HK", "KR", "SG", "DE", "MY", "VN", "PH", "TH", "AU", "NL", "SA", "ID", "GB", "IN", "FR", "IT", "AE")

buyin <- c(26.142, 12.008, 7.032, 13.646, 4.589, 5.768, 2.131, 2.802, 3.428, 3.019, 1.976, 1.118, 1.624, 0.449, 0.983, 1.302, 1.027, 0.553, 0.670, 0.455)

buyout <- c(22.987, 12.204, 11.837, 7.739, 5.381, 4.610, 2.866, 2.784, 2.414, 2.092, 1.839, 1.788, 1.665, 1.409, 1.391, 1.075, 0.974, 0.899, 0.800, 0.728)

# View(country)

# create by sequence
a <- seq(11, 99, 11)
b <- 11:20

# create by distribution
nums <- runif(1000, 1, 10) # uniform dist, n=1000
nums <- rnorm(10000000, 1, 10) # normal dist, n=1000

hist(nums)
hist(nums, breaks = 100)


# v2. Take a glance at a vector -----------------------------------------------

country
buyin
head(country)
tail(country)
length(country)
View(country)



# v3. Get elements from vectors -----------------------------------------------

country[3:7]

# returning elements by index
country[c(1, 3, 5)]
country[c(5, 3, 1)]

# country[1, 3, 5]

a <- seq(11, 99, 11)
a[3:length(a)]
a[length(a):3]

length(a):3
9:3
c(9, 8, 7, 6, 5, 4, 3)

# v4. Delete elements from vectors --------------------------------------------

b <- 11:20
b[-(3:5)]
b[-c(1, 3, 5)]

# Without assignment, deletion won't change original vectors
b

# Assign to replace original vectors
b <- b[-(3:5)]
b

a <- seq(11, 99, 11)
a <- a[-c(1, 3, 5)]
a


i <- 0
i <- i + 1
i


# v5. Concatenate two or three vectors  ---------------------------------------

a <- c(a, 3)
a
a <- c(a, b)
a <- c(a, a, b)

a = c(1, 2, 3)
a <- c(1, 2, 3)

b <- c(4, 5)

d <- a + b

d
 # v6. Arithmetic operations ---------------------------------------------------

a <- a + 3
a <- a / 2
a <- a %% 2 	# modular arithmetic, get the reminder
a <- a %/% 2 	# Quotient



# v7. Logical comparison ------------------------------------------------------

a <- 11:20
a %% 2 == 0 	# deteting odd/even number
a %% 2 != 0
a[a%%2==0]

a%%2==0

class(a%%2==0)

a > b
buyin
mean(buyin)
buyin > mean(buyin)
buyin[buyin > mean(buyin)+2*sd(buyin)]
buyin > buyout

TRUE == T 		# == equal to, 
TRUE != F    	# != Not equal to

a <- 11:99
any(a>11) # is there any element larger than 1
all(a>11) # are all elements larger than 1

a <- c(11, 13, 51, 37, 29)
any(a%%2==0)
all(a%%2!=0)

# two methods to filter data from vectors, by index vector or a logical vector with equal length
a <- seq(11, 55, 11)
a[c(T, F, T, F, T)]
a[a%%2==1]
a%%2
a%%2==1

# which will return "index-of"
a[which(a%%2==1)]
which(a%%2==1)


# Practice ----------------------------------------------------------------
x.a <- rnorm(1000000, 1, 10)
hist(x.a, breaks = 100)
# 1.1 Filter out extreme values out of two standard deviations
x.a - mean(x.a) <  2*sd(x,a)
x.a  - mean(x.a) >  -2*sd(x,a)
x.a <- x.a[abs(x.a - mean(x.a)) < 2*sd(x.a)]

# 1.2 Plotting the distribution of the remaining vector x.a

hist(x.a, breaks = 100)

max(x.a)
min(x.a)
# 1.3 Calculate the 25% 50% and 75% quantile of vector x.a. You may google "quantile r"
upper <- quantile(x.a, probs = 0.75)
lower <- quantile(x.a, probs = 0.25)

# 1.4 Get the number between 25% to 75%
hist(x.a[x.a < upper & x.a > lower])
x.a[x.a > upper | x.a < lower]

x.b <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k")

# 2.1 Get only elements at odd positions
x.b[1:length(x.b)%% 2 == 1]
0.25:0.75
1:5 
# 2.2 Truncate the first 2 elements and the last 2 elements
x.b[3:(length(x.b)-2)]



# v8. Sorting -----------------------------------------------------------------

c <- c(33, 55, 22, 13, 4, 24)
rev(c)  # reverse

# Sort it directly
sort(c) # 4 13 22 24 33 55
# sort(c, decreasing = T)

# Get the order
order(c) # 5, 4, 3, 6, 1, 2 <- the min to max sequence of original index
c[order(c)] # will produce identical vector with sort(c)

# assign to replace c
c <- sort(c)




 # v9. Math functions ----------------------------------------------------------

min(a); max(a); mean(a); median(a); sd(a)
log2(a)
log1p(a)
?log1p



# v10. Mode of vector ----------------------------------------------------------

mode(country)				# character
mode(buyin)					# numeric
mode(buyin > mean(buyin))	# logical 

buyinc <- c("26.142", "12.008", "7.032", "13.646", "4.589")
mode(buyinc)				# character



# v11. Mode conversion ---------------------------------------------------------
# character > numeric > logical

buyinc <- as.character(buyin)
buyinn <- as.numeric(buyinc)

a <- seq(11, 99, 11)
a <- c(a, "100")

a <- seq(11, 99, 11)
sum(a%%2==1)




# v12. Operations and function of character vectors ----------------------------

a <- seq(11, 55, 11)
paste("A", a)		# concatenate
paste0("A", a)		# concatenate




# data.frame ==============================================================

# df4. Combine 3 vectors to a dataframe ----------------------------------------

country <- c("CN", "US", "JP", "HK", "KR", "SG", "DE", "MY", "VN", "PH", "TH", "AU", "NL", "SA", "ID", "GB", "IN", "FR", "IT", "AE")

buyin <- c(26.142, 12.008, 7.032, 13.646, 4.589, 5.768, 2.131, 2.802, 3.428, 3.019, 1.976, 1.118, 1.624, 0.449, 0.983, 1.302, 1.027, 0.553, 0.670, 0.455)

buyout <- c(22.987, 12.204, 11.837, 7.739, 5.381, 4.610, 2.866, 2.784, 2.414, 2.092, 1.839, 1.788, 1.665, 1.409, 1.391, 1.075, 0.974, 0.899, 0.800, 0.7)


df <- data.frame(country, buyin, buyout)

df <- data.frame(country, buyin, buyout, stringsAsFactors = FALSE)
str(df)




# df5. Arithmetic operatoins between variables ----------------------------

df$sub <- df$buyin - df$buyout

df[2,1]


# df6. Filtering and selection ------------------------------------------------------

df
names(df)

# filter row data by column value
df$buyin > df$buyout
df[df$buyin > df$buyout,]
df[df$buyin > df$buyout,]$country

# 1 row == a data.frame with only one data entry
class(df[df$buyin > df$buyout,1])
class(df[,1]) # character vector
class(df[1,]) # data.frame
class(unlist(df[1, -1])) # filter the 1st row and select all columns except 1




# df7. Sort data.frame ---------------------------------------------------------

# sort rows by df$buyin column
order(df$buyin)
df.sorted <- df[order(df$buyin),]
View(df.sorted)

# sort rows in decreasing order
df.sorted <- df[order(df$buyin, decreasing = T),]

# add - to column in order() can sort in decreasing order
df.sorted <- df[order(-df$buyin),]
View(df.sorted)

a <- c(5, 5, 5, 5, 4, 4, 4, 3, 3, 1, 1, 1, 2, 2, 2)
b <- c(3, 3, 3, 4, 4, 4, 2, 2, 2, 4, 4, 1, 4, 1, 1)
df2 <- data.frame(a, b)

# sort df2 in orders of decreasing b then increasing a
df2 <- df2[order(df2$a, -df2$b),]



# plot --------------------------------------------------------------------

plot(df) # raise error, 1st column is a character vector
plot(df[, 2:3])
plot(df[1:10, 2:3])
text(buyin, buyout, labels=country, cex= 0.5, pos=3)
lines(1:25, 1:25, col='red')
# 




# Practice ----------------------------------------------------------------

load("data/rent591TP.rda")
dim(rent591)

# get only the Da'na district's case and store to a data.frame

daan <- rent591[rent591$section_name=="大安區",]
daan$avg <- daan$price / daan$area
mean(daan$avg)

daan <- daan[order(daan$avg, decreasing = T),]
daan <- daan[order(daan$avg, decreasing = T),]

plot(daan$area, daan$avg)
?summary
??filter

library(tidyverse)
library(dplyr)

daan <- filter(rent591, section_name=="大安區")
daan <- mutate(daan, avg=price/area)
daan <- select(daan, avg, price, area, kind_name, browsenum)

rent591 %>%
  filter(section_name=="大安區") %>%
  mutate(avg=price/area) %>%
  select(avg, price, area, kind_name, browsenum, posttime) %>%
  ggplot(aes(posttime, log10(browsenum), color=price)) + 
  geom_point()


# calculate the average price per "ping"

summary(rent591)



rent591 %>%
	filter(section_name == "大安區") %>%
	mutate(avg = price/area) %>%
	ggplot(aes(price, avg, color=kind_name)) +
	geom_jitter() + 
	theme(text=element_text(family="STKaiti"))
