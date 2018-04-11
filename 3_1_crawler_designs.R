# slide: https://docs.google.com/presentation/d/e/2PACX-1vRW84XoB5sFRT1Eg-GrK4smX23qoNkFffz_h8oRU4AIvJAgrrxBn8059_0UeHv_pFBks_Z37vNbLGai/pub?start=false&loop=false&delayms=3000&slide=id.g28a96d7d6c_0_280
# Youtube: https://www.youtube.com/playlist?list=PLK0n8HKZQ_VfJcqBGlcAc0IKoY00mdF1B

pkgs <- c("jsonlite", "httr", "dplyr")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])] 
if(length(pkgs)) install.packages(pkgs)

library(httr)
library(jsonlite)
library(dplyr)



# 0. Clean code of crawling rent591 ---------------------------------------

### Getting the first chunk of data
url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res1 <- fromJSON(content(GET(url1), "text"))
all.df <- res1$data$data

### Detecting the page number of the last chunk
end <- as.numeric(gsub(",", "", res1$records))
endpage <- end %/% 30

### Modifying urls by page number to get all data
for(i in 1:endpage){
	url <- paste0(url1, "&firstRow=", i*30, "&totalRows=", end)
	res <- fromJSON(content(GET(url), "text"))
	all.df <- bind_rows(all.df, res$data$data) # dplyr::bind_rows()
}

length(unique(all.df$user_id))



# 1. Get the first page of rent591 ----------------------------------------

url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res1 <- fromJSON(content(GET(url1), "text"))
class(res1$data$data)
dim(res1$data$data); 

# store res1 data to all.df
all.df <- res1$data$data



# 2. Get the 2nd page -----------------------------------------------------

# Observing the different part of the following urls
# url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
# url2 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1&firstRow=30&totalRows=2563"

# composing url2 by url1 as prefix and surfix arguments (parameters)
url2 <- paste0(url1, "&firstRow=30&totalRows=2563")
res2 <- fromJSON(content(GET(url2), "text"))
class(res2$data$data)
dim(res2$data$data)

# concatenating res2 data after all.df by row
# ?dplyr::bind_rows
all.df <- bind_rows(all.df, res2$data$data)
nrow(all.df)



# 3. Get the 3rd page data ------------------------------------------------

# url3 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1&firstRow=60&totalRows=2563"
url3 <- paste0(url1, "&firstRow=60&totalRows=2563")
res3 <- fromJSON(content(GET(url3), "text"))

# concatenating res3
all.df <- bind_rows(all.df, res3$data$data)
dim(all.df)



# 4. Review essential code above ------------------------------------------

url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res1 <- fromJSON(content(GET(url1), "text"))
all.df <- res1$data$data

url2 <- paste0(url1, "&firstRow=30&totalRows=2563")
res2 <- fromJSON(content(GET(url2), "text"))
all.df <- bind_rows(all.df, res2$data$data)

url3 <- paste0(url1, "&firstRow=60&totalRows=2563")
res3 <- fromJSON(content(GET(url3), "text"))
all.df <- bind_rows(all.df, res3$data$data)

url4 <- paste0(url1, "&firstRow=90&totalRows=2563")
res4 <- fromJSON(content(GET(url4), "text"))
all.df <- bind_rows(all.df, res4$data$data)




# 5. Use for(){} to do s.t. repeatedly ------------------------------------

url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res1 <- fromJSON(content(GET(url1), "text"))
all.df <- res1$data$data

for(i in 1:3){
	url <- paste0(url1, "&firstRow=", i*30, "&totalRows=2563")
	res <- fromJSON(content(GET(url), "text"))
	all.df <- rbind(all.df, res$data$data)
}



# 6. Get the last page ----------------------------------------------------

# the total records
res1$records
# [1] "2,575"

# convert character to number
end <- as.numeric(gsub(",", "", res1$records))
# calculate the number of end page
endpage <- end %/% 30


for(i in 1:endpage){
	url <- paste0(url1, "&firstRow=", i*30, "&totalRows=", end)
	res <- fromJSON(content(GET(url), "text"))
	all.df <- rbind(all.df, res$data$data)
}




# 7. Clean code of rent591 ------------------------------------------------

url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res1 <- fromJSON(content(GET(url1), "text"))
all.df <- res1$data$data

end <- as.numeric(gsub(",", "", res1$records))
endpage <- end %/% 30

for(i in 1:endpage){
	url <- paste0(url1, "&firstRow=", i*30, "&totalRows=", end)
	res <- fromJSON(content(GET(url), "text"))
	all.df <- bind_rows(all.df, res$data$data) # dplyr::bind_rows()
}

length(unique(all.df$user_id))





# 8. Save data to local dirctory ------------------------------------------

# save single var as rds
saveRDS(all.df, "data/rent5911018.rds")

# read rds to a new var
rent591 <- readRDS("data/rent5911018.rds")

# save multiple vars as rdata
save(all.df, end, endpage, file = "data/rent5911018.rdata")

# remove all vars in global environment
rm(list=ls())

# loading .rdata will recover original vars
load("data/rent5911018.rdata")




# 9. rbind() vs. bind_rows() ----------------------------------------------
# Practice: why bind_rows() rather than rbind() ---------------------------
??bind_rows


# Creating 3 data.frames with the same 3 columns, each with 3 data rows.
# using rbind to combine them


# Creating 3 data.frames, each with 3 data rows. 
# However, the second data.frame only has 2 columns, 
# while the third data.frame has 3 columns with different names
# using rbind to combine them to see what happens
# using dplyr::bind_rows() to combine them 





# 10. do.call(rbind(), …) -------------------------------------------------

url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res1 <- fromJSON(content(GET(url1), "text"))

# create a list to store all data.frame temporarily
all.list <- list()
all.list[[1]] <- res1$data$data

end <- as.numeric(gsub(",", "", res1$records))
endpage <- end %/% 30

for(i in 1:endpage){
	url <- paste0(url1, "&firstRow=", i*30, "&totalRows=", end)
	res <- fromJSON(content(GET(url), "text"))
	all.list[[i+1]] <- res$data$data
}

all.df2 <- do.call(bind_rows, all.list)



# Practice01: Find the next and end ---------------------------------------

# Finding the next page and the end page of the following urls
url_pchome <- "http://ecshweb.pchome.com.tw/search/v3.3/?q=switch&scope=all"
url_dcard <- "https://www.dcard.tw/f/relationship"
url_104 <- "https://www.104.com.tw/jobs/search/?ro=0&keyword=%E8%B3%87%E6%96%99%E5%88%86%E6%9E%90&area=6001001000&order=1&asc=0&kwop=7&page=9&mode=s&jobsource=n104bank1"




# 11.1 Get the next data: Dcard -------------------------------------------

# The url is the page rendered by JS and json
# url_dcard <- "https://www.dcard.tw/f/relationship"

# The targeted url
url <- "https://www.dcard.tw/_api/forums/relationship/posts?popular=true"
res <- fromJSON(content(GET(url), "text"))
res$id[30]

url2 <- paste0(url, "&before=", res$id[30])
res2 <- fromJSON(content(GET(url2), "text", encoding = "utf-8"))
res2$id[30]
# 11.2 Get 2nd block of data ----------------------------------------------

# Sample of next url
next_url <- "https://www.dcard.tw/_api/forums/relationship/posts?popular=true&before=227504873"

# Composing next_url from the latest data res
next_url <- paste0(url, "&before=", res$id[30])
next_res <- fromJSON(content(GET(next_url), "text"))

# Binding two consequent data by rows
res <- rbind(res, next_res)



# Practice ----------------------------------------------------------------

# How do you get 3 or 4 blocks of data by next_url?

url <- "https://www.dcard.tw/_api/forums/relationship/posts?popular=true"
res <- fromJSON(content(GET(url), "text"))
next_url <- paste0(url, "&before=", res$id[30])
next_res <- fromJSON(content(GET(next_url), "text"))
res <- rbind(res, next_res)




# Getting 3 blocks

url <- "https://www.dcard.tw/_api/forums/relationship/posts?popular=true"
res <- fromJSON(content(GET(url), "text"))
next_url <- paste0(url, "&before=", res$id[30])

next_res <- fromJSON(content(GET(next_url), "text"))
res <- rbind(res, next_res)
next_url <- paste0(url, "&before=", next_res$id[30])

next_res <- fromJSON(content(GET(next_url), "text"))
res <- rbind(res, next_res)
next_url <- paste0(url, "&before=", next_res$id[30])

next_res <- fromJSON(content(GET(next_url), "text"))
res <- rbind(res, next_res)
next_url <- paste0(url, "&before=", next_res$id[30])





# 11.3 for(){} to get more blocks of data ---------------------------------

url <- "https://www.dcard.tw/_api/forums/relationship/posts?popular=true"
res <- fromJSON(content(GET(url), "text"))
next_url <- paste0(url, "&before=", res$id[30])

for(i in 1:100){
	next_res <- fromJSON(content(GET(next_url), "text"))
	res <- bind_rows(res, next_res)
	next_url <- paste0(url, "&before=", next_res$id[30])
	# sleep(sample(1:5, 1)) 
}
