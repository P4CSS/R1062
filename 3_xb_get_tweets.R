# Goal: Crawling Trump's tweets and anlyzing his keywords


# library and global options ----------------------------------------------
install.packages('twitteR')
library(twitteR)
options(stringsAsFactors = F)



# Copy consumer keys and access_token -------------------------------------
# https://paper.dropbox.com/doc/R-twitterR-UYzYvP2cMSBGTbKMN34a2#:uid=547357062117335&h2=1.-Preparation

consumer_key <- ''
consumer_secret <- ''
access_token <- ''
access_secret <- ''



# Set up authentication ---------------------------------------------------

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


# Send query --------------------------------------------------------------

tweets <- userTimeline("realdonaldtrump", n = 3200)



# Combine results ---------------------------------------------------------

# Create df by the 1st tweet
df <- as.data.frame(tweets[[1]])


# Use rbind and for-loop to combine the 2nd and following tweets
for(i in 2:length(tweets)){
	df.next <- as.data.frame(tweets[[i]])
	df <- rbind(df, df.next)
	print(i)
}

# A better way to combine all results
# df <- do.call("rbind", lapply(tweets, as.data.frame))

class(tweets[[1]])
test <- as.data.frame(tweets[[1]])





# Load stopwords ----------------------------------------------------------
library(tm) # for stopWords()
stopWords <- stopwords("en")
stopWords

# if you can not load tm library, you can source() the stopWords.RData I provides
getwd() # get current working directory
#setwd() # set current working directory
system("ls") # send system command ls
list.files(".") # list all files in current directory
list.files("RData") # list all files in RData directory
load("RData/stopWords.RData") # loading RData files


# Text preprocessing ------------------------------------------------------

# Load stopwords
library(tm) # for stopWords()
stopWords <- stopwords("en")

# if you can not load tm library, you can load() the stopWords.RData
load("RData/stopWords.RData") # loading RData files

# Split sentence by non-alphabetical characters
df$words <- strsplit(df$text, "[^a-zA-Z']+")

# convert character to lower case
df$words <- sapply(df$words, tolower)



# Calculate term frequency ------------------------------------------------

freq <- table(unlist(df$words)) # try to use dplyr::count()?
length(freq)
names(freq)



# Extract key terms from term list ----------------------------------------

# delete words in stopWords
freq <- freq[!(names(freq) %in% stopWords)]
length(freq)

# sort the frequency table
freq <- sort(freq, decreasing=T)

# eliminate words with low frequency <=3
freq2 <- freq[freq > 3]

# eliminate garbage words
freq3 <- freq2[!(names(freq2) %in% c('https', 'co', 't'))]

# eliminate word with only one letter
freq4 <- freq3[nchar(names(freq3))>1]


# Visualization -----------------------------------------------------------

# Barplot the words
freq4 <- subset(freq4, freq4>=5)
barplot(freq4[1:50], las=2, cex.names =1)


library(ggplot2)
freq4.df <- as.data.frame(freq4[1:50])
ggplot(freq4.df, aes(x=Var1, y=Freq)) + 
	geom_bar(stat="identity") +
	xlab("Terms") + ylab("Count") + 
	coord_flip() +
	theme(axis.text=element_text(size=7))

# Plot sentimental terms only ---------------------------------------------
# http://tidytextmining.com/sentiment.html

# Loading sentimet corpus
library(tidytext)
corpus <- get_sentiments("bing")

sentiment.freq <- freq4[names(freq4) %in% unlist(corpus$word)]
sentiment.df <- as.data.frame(sentiment.freq)

ggplot(sentiment.df, aes(x=Var1, y=Freq)) + 
	geom_bar(stat="identity") +
	xlab("Terms") + ylab("Count") + 
	coord_flip() +
	theme(axis.text=element_text(size=7))

# Plot wordcloud ----------------------------------------------------------
library(wordcloud)
pal.p <- brewer.pal(9, "BuGn")[-(1:4)]
pal.n <- brewer.pal(9, "OrRd")[-(1:4)]
wordcloud(words = sentiment.df$Var1, freq = sentiment.df$Freq, random.order = F, colors = pal.p)

corpus.n <- corpus[corpus$sentiment == "negative", ]
corpus.p <- corpus[corpus$sentiment == "positive", ]

n.freq <- freq4[names(freq4) %in% unlist(corpus.n$word)]
p.freq <- freq4[names(freq4) %in% unlist(corpus.p$word)]
n.df <- as.data.frame(n.freq)
p.df <- as.data.frame(p.freq)

par(mfrow=c(1, 2), mai=rep(0.3, 4))
wordcloud(words = p.df$Var1, freq = p.df$Freq, random.order = F, colors = pal.p)

wordcloud(words = n.df$Var1, freq = n.df$Freq, random.order = F, colors = pal.n)

# Practice  ---------------------------------------------------------------
# finding hillary's id and crawling her tweets
# how do we specify the tweet before trump winning the election?




# Further analysis --------------------------------------------------------

# extract to whom message
library(stringr)
df$to <- sapply(df$text,function(tweet) str_extract(tweet,"(@[[:alnum:]]*)"))

# get follower IDs
user <- getUser("realdonaldtrump")
user$getLocation()
followerIDs <- user$getFollowerIDs()
head(followerIDs)
length(followerIDs)
length(unique(followerIDs))
user$toDataFrame()
friends <- user$getFriends()
followers <- user$getFollowers()
save(followerIDs, file="R105/RData/trumpFollower.RData")

class(followerIDs)
fuser <- getUser(followerIDs[3])
fuser$location
fuser$name
fuser$screenName
fuser$followersCount
