### Slide: https://docs.google.com/presentation/d/e/2PACX-1vRW84XoB5sFRT1Eg-GrK4smX23qoNkFffz_h8oRU4AIvJAgrrxBn8059_0UeHv_pFBks_Z37vNbLGai/pub?start=false&loop=false&delayms=3000&slide=id.g28a96d7d6c_0_280


library(httr)
library(jsonlite)
options(stringsAsFactors = FALSE)



# Test1. Get data several times -------------------------------------------


url <- "http://data.taipei/youbike"

for(i in 1:12){
	GET(url, write_disk("ubike"), overwrite=FALSE)
}



# Test2. Sleep 60 secs ----------------------------------------------------

# Get data per 300 secs (5 mins)
for(i in 1:12){
	GET(url, write_disk("ubike"), overwrite=TRUE)
	Sys.sleep(300)
}

# A testing
for(i in 1:12){
	print(i)
	Sys.sleep(3)
}




# Test3. Get current time and convert to character ------------------------

Sys.time()
timestr <- as.character(Sys.time())
timestr

# Use time format() function to re-format time
?strptime
format(Sys.time(), "%Y%m%d%H%M")

# Using paste0 to concatenate "ubike" and time as file name
ctime <- format(Sys.time(), "%Y%m%d%H%M")
paste0("ubike", ctime)




# Test4. Save data with timestamp -----------------------------------------

for (i in 1:30) {
	ctime <- format(Sys.time(), "%Y%m%d%H%M%S")
	GET(url, write_disk(paste0("data/ubike", ctime)))
	print(ctime)
	Sys.sleep(60)
}



# 1. FULL CODE ------------------------------------------------------------

for (i in 1:576) {
	ctime <- format(Sys.time(), "%Y%m%d%H%M%S")
	GET(url, write_disk(paste0("ubike", ctime)))
	print(ctime)
	Sys.sleep(300)
}




# (Option) Using a tryCatch block to avoid interruption -------------------

for (i in 1:576) {
	ctime <- format(Sys.time(), "%Y%m%d%H%M%S")
	tryCatch({
		GET(url, write_disk(paste0("ubike", ctime)))
	}, error = function(err) {
		print(paste0("Error at", ctime))
	})
	
	print(ctime)
	Sys.sleep(300)
}



# 2. Read files in a directory --------------------------------------------

?list.files
# list.files(path = ".", pattern = NULL, all.files = FALSE,
# full.names = FALSE, recursive = FALSE,
# ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
?list.dirs


# Test2.1 List all files in a directory -----------------------------------

list.files("data")

# list files in "data" directory with prefix ubike
list.files("data", pattern="ubike*")
list.files("data", pattern="ubike[0-9]+")
list.files("data", pattern="ubike[0-9]+", full.names = T)
fnames <- list.files("data", pattern="ubike[0-9]+", full.names = T)
length(fnames)



# 3. Loop to read and combine all files -----------------------------------

library(jsonlite)
all.df <- data.frame()
all.list <- list()
i <- 1
# test <- fromJSON(fnames[1])
# res <- fromJSON(fnames[1])
for(fname in fnames){
	ubike.list <- fromJSON(fname)
	ubike.v <- unlist(ubike.list$retVal)
	ubike.m <- matrix(ubike.v, byrow = T, ncol = 14)
	ubike.df <- as.data.frame(ubike.m)
	cname <- names(ubike.list$retVal$`0001`)
	names(ubike.df) <- cname
	ubike.df$lng <- as.numeric(ubike.df$lng)
	ubike.df$lat <- as.numeric(ubike.df$lat)
	ubike.df$tot <- as.numeric(ubike.df$tot)
	ubike.df$sbi <- as.numeric(ubike.df$sbi)
	ratio <- ubike.df$sbi / ubike.df$tot
	names(ratio) <- ubike.df$sna
	all.df <- bind_rows(all.df, ratio)
	all.list[[i]] <- ubike.df
	i <- i + 1
}
View(all.list[[1]])
?bind_cols



# 4. Calculation ----------------------------------------------------------

mean.v <- sapply(all.df, mean)
mean.l <- lapply(all.df, mean)
sd.v <- sapply(all.df, sd)
head(sort(sd.v, decreasing = T), n=20)

