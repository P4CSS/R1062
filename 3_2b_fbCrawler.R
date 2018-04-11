# Slide: https://docs.google.com/presentation/d/e/2PACX-1vRW84XoB5sFRT1Eg-GrK4smX23qoNkFffz_h8oRU4AIvJAgrrxBn8059_0UeHv_pFBks_Z37vNbLGai/pub?start=false&loop=false&delayms=3000&slide=id.g28a96d7d6c_0_280
# DoctorKoWJ, https://www.facebook.com/DoctorKoWJ/
# https://www.facebook.com/groups/KoWJfans/




# 0. Importing packages --------------------------------------------

library(httr)
library(jsonlite)
library(dplyr)

options(stringsAsFactors = F)
token <- "EAACEdEose0cBAAQjGPTnzDypiCBGfPPBxWNMeyQB8IXlqA7Fy1N2NxtgmAZBhkJoOZBl80bYlBR4udgXy6gZB4yrWMm8vD3nQEWZA5FiCeHXp1F9E66Ks8tdWSZCnvfKgVYKnDhZCH11NH5HoFA2kKV6ZCxoKuv7YnubbcTbza1a0KU695AhTxoJj4ZCJegj9J0ZD"

# 1. Getting post ---------------------------------------------------

# Copy the crul path under the query result
fburl <- 
	"https://graph.facebook.com/v2.10/DoctorKoWJ?fields=posts&access_token=EAACEdEose0cBADIG0BrY539ZCfq5ZC3wVlPvs2DQXS9w0M8P85wlIudxGZAp8Uv0WVFRrGNth6C8MpoPcqH73ecLbFaRMWHlBpyJoC9NaIidzEtTbCSaYM2h1ZBG2HZCOkqR6aOAdoHbRWvI2ZBctZAf4iYFQFBJoOyRxqhwLg5U8MXXBDkai3DgKCRHyPtjc8ZD"

# Getting back by the url and convert to R objects by fromJSON
res <- fromJSON(content(GET(fburl), "text"))
all.df <- res$posts$data
View(res$posts$data)
str(res$posts$data)




# 2. Getting next data chunk ----------------------------------------------

### Traversing to find the url of the next data chunk
res$posts$paging$next # Rising error due to the control vocabulary next
next_url <- res$posts$paging$"next" # correct version

next_res <- fromJSON(content(GET(next_url), "text"))
View(next_res$data)

### Binding the first and the second chunks
all.df <- bind_rows(all.df, next_res$data)



## 2.1 Getting the 3rd chunk ----------------------------------------------

next_url <- next_res$paging$"next"
next_res <- fromJSON(content(GET(next_url), "text"))
all.df <- bind_rows(all.df, next_res$data)




# 3. for() to get blocks repeatedly ---------------------------------------

res <- fromJSON(content(GET(fburl), "text"))
all.df <- res$posts$data
next_url <- res$posts$paging$"next"

### Getting back 100 more data chunks
### Mayor Ko's page only has 1K+ posts.
### In order to detecting the end of the data, 
### we used 100 (25*100==2500) to catch the ending condition.
for(i in 1:100){
	message(i)
	next_res <- fromJSON(content(GET(next_url), "text"))
	all.df <- bind_rows(all.df, next_res$data)	
	next_url <- next_res$paging$"next"
}
# 53
# 54
# Error in handle_url(handle, url, ...) : 
# 	Must specify at least one of url or handle

### Look at the next_url to find out why.
next_url
dim(next_res$data)
is.null(next_url)

### checking duplication of data.frame
anyDuplicated(all.df)
# [1] 0



# 4. while() to get data until ending condition ---------------------------

id <- "DoctorKoWJ"
query <- sprintf("?fields=posts.limit(100)")
fburl <- sprintf("https://graph.facebook.com/v2.10/%s%s&access_token=%s", 
				 id, query, token)

res <- fromJSON(content(GET(fburl), "text"))
all.df <- res$posts$data
next_url <- res$posts$paging$"next"

while(!(is.null(next_url))){
	next_res <- fromJSON(content(GET(next_url), "text"))
	all.df <- bind_rows(all.df, next_res$data)	
	next_url <- next_res$paging$"next"
	message(paste0(dim(all.df), sep="\t"))
}

anyDuplicated(all.df) # [1] 0

### Converting time strings to R POSIXct time objects
all.df$timestamp <- as.POSIXct(strptime(all.df$created_time, 
										"%Y-%m-%dT%H:%M:%S%z", 
										tz="Asia/Taipei"))
all.df$hour <- as.numeric(format(all.df$timestamp, "%H"))
all.df$hm <- all.df$hour + as.numeric(format(all.df$timestamp, "%M"))/60
all.df$wday <- weekdays(all.df$timestamp)
??weekdays




# 5. Getting comments by post id ------------------------------------------

all.df$id
pid <- all.df$id[2] # the 1st post id
query <- "?fields=comments.limit(500)" # comment query
fburl <- sprintf("https://graph.facebook.com/v2.10/%s%s&access_token=%s", 
				 pid, query, token)



# 5.1 Getting the 1st and 2nd chunks --------------------------------------

res <- fromJSON(content(GET(fburl), "text"))
next_url <- res$comments$paging$"next"
comment.df <- res$comments$data

next_res <- fromJSON(content(GET(next_url), "text"))
### bind_rows() here will raise fatal error
comment.df <- bind_rows(comment.df, next_res$data)
next_url <- next_res$paging$"next"

### take a look at the str(comment.df)
str(comment.df) # A data.frame, but having one hierarchical variable



# 5.2 Flatten both hierarchical data.frame for rbind ----------------------



### binding them
comment.df <- bind_rows(comment.df, next_res$data)




# 5.3 Reorganizing the code -----------------------------------------------

### Get the first chunk

### Get the second chunk

###bind_rows() them
comment.df <- bind_rows(comment.df, next_res$data)




# 5.4 while() to get all comments of a post id ----------------------------

pid <- all.df$id[2] # the 1st post id
query <- "?fields=comments.limit(500)" # comment query
fburl <- sprintf("https://graph.facebook.com/v2.10/%s%s&access_token=%s", 
				 pid, query, token)

### Get the first chunk
res <- fromJSON(content(GET(fburl), "text"))
comment.df <- res$comments$data
comment.df$from.name <- comment.df$from$name 
comment.df$from.id <- comment.df$from$id 
comment.df$from <- NULL
next_url <- res$comments$paging$"next"


### Get remaining chunks
while(!(is.null(next_url))){
	next_res <- fromJSON(content(GET(next_url), "text"))
	next_res$data$from.name <- next_res$data$from$name 
	next_res$data$from.id <- next_res$data$from$id 
	next_res$data$from <- NULL
	comment.df <- bind_rows(comment.df, next_res$data)
	next_url <- next_res$paging$"next"
	message(paste0(dim(comment.df), sep="\t"))
}


# 6. for() to get comments for all posts ----------------------------------

### Creating a blank data.frame to store data
allc.df <- 

### Setting pi for counting the number of posts 
pi <- 1

for(pid in all.df$id){
	query <- "?fields=comments.limit(500)" # comment query
	fburl <- sprintf("https://graph.facebook.com/v2.10/%s%s&access_token=%s", 
					 pid, query, token)
	
	res <- fromJSON(content(GET(fburl), "text"))
	comment.df <- res$comments$data
	comment.df$from.name <- comment.df$from$name 
	comment.df$from.id <- comment.df$from$id 
	comment.df$from <- NULL
	next_url <- res$comments$paging$"next"
	
	
	while(!(is.null(next_url))){
		next_res <- fromJSON(content(GET(next_url), "text"))
		next_res$data$from.name <- next_res$data$from$name 
		next_res$data$from.id <- next_res$data$from$id 
		next_res$data$from <- NULL
		comment.df <- bind_rows(comment.df, next_res$data)
		next_url <- next_res$paging$"next"
		message(paste0(dim(comment.df), sep="\t"))
	}	
	
	### Assigning pid to each comment
	comment.df$pid <- pid
	
	### Binding comment.df to allc.df one by one.
	allc.df <- bind_rows(allc.df, comment.df)
	message(sprintf("[%d]%s", pi, pid))
	pi <- pi + 1
}

###Saving data
saveRDS(allc.df, sprintf("data/comment_KoWJ_%s.rds", format(Sys.time(), "%Y%m%d-%H%M%S")))





# 7. (More) Creating function to make clear your code ---------------------

flatten_df_from <- function(df){
	df$from.name <- df$from$name 
	df$from.id <- df$from$id 
	df$from <- NULL
	df
}

get_comments_by_pid <- function(pid, query, token){
	fburl <- sprintf("https://graph.facebook.com/v2.10/%s%s&access_token=%s", 
					 pid, query, token)
	
	res <- fromJSON(content(GET(fburl), "text"))
	comment.df <- flatten_df_from(res$comments$data)
	next_url <- res$comments$paging$"next"
	
	
	while(!(is.null(next_url))){
		next_res <- fromJSON(content(GET(next_url), "text"))
		comment.df <- bind_rows(comment.df, 
								flatten_df_from(next_res$data))
		next_url <- next_res$paging$"next"
		message(paste0(dim(comment.df), sep="\t"))
	}	
	
	comment.df$pid <- pid
	comment.df # return the comment.df	
}

get_comments_by_allpid <- function(pids, token){
	allc.df <- data.frame()
	pi <- 1
	query <- "?fields=comments.limit(500)" # comment query
	for(pid in pids){
		get_comments_by_pid(pid, query, token)
		allc.df <- bind_rows(allc.df, comment.df)
		message(sprintf("[%d]%s-----------------", pi, pid))
		pi <- pi + 1
	}
	allc.df
}

get_comments_by_allpid(all.df$id, token)





# 8. Visualizaiton by base::plot() ----------------------------------------

barplot(tapply(all.df$timestamp, all.df$hour, length))
bywDays <- with(all.df, tapply(created_time, list(wday, hour), length))
plot(bywDays[1,], type="l")
lines(bywDays[2,])
lines(bywDays[3,], col="red")
lines(bywDays[4,], col="green")
lines(bywDays[5,], col="blue")
lines(bywDays[6,], col="pink")
lines(bywDays[7,], col="gray")






# 8.1 Plot by the ggplot2 package -----------------------------------------


library(ggplot2)
str(all.df)
names(all.df)
test <- all.df %>%
	group_by(wday, hour) %>%
	summarize(n=n())

ggplot(test, aes(hour, n, color=wday)) + 
	geom_line()






# Appendix: Better post query ---------------------------------------------

### You should be better to learn how to get comments firstly.
query <- sprintf('?fields=posts.limit(100){id,link,type,created_time,updated_time,description,message,caption,shares,name,source,parent_id,likes.limit(0).summary(true),comments.limit(0).summary(true)}')


# you many need to modify the result data.frame by this way

df$likeCount <- df$likes$summary$total_count
df$likes <- NULL
df$commentCount <- df$comments$summary$total_count
df$comments <- NULL
df$shareCount <- df$shares$count
df$shares <- NULL







# Appendix: lapply() and self-defined function ----------------------------
### the code is used for do.call() version of code shown in 4. (option)


### Creating a function containing the modification part
modifydf <- function(df){
	df$likeCount <- df$likes$summary$total_count
	df$likes <- NULL
	df$commentCount <- df$comments$summary$total_count
	df$comments <- NULL
	df$shareCount <- df$shares$count
	df$shares <- NULL
	df
}

### lapply the function to each element of all.list
all.list <- lapply(all.list, modifydf)

all.df <- do.call(bind_rows, all.list)
dim(all.df) # [1] 1352    4

anyDuplicated(all.df)