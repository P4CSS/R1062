### Slide: https://docs.google.com/presentation/d/e/2PACX-1vSGeNG6BcEUNjhZjqo1obJ9bijuMjKJ0WhEva29-AuishNv779rSC0nDShfkR5HcWp4EdlRUBaaiG0M/pub?start=false&loop=false&delayms=3000

pkgs <- c("xml2", "rvest", "installr")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])] 
if(length(pkgs)) install.packages(pkgs)

library(xml2)
# xml2::read_html(url, encoding=)
# xml2::xml_find_first(node, xpath)
# xml2::xml_find_all(node, xpath)
# xml2::xml_text(node)
# xml2::xml_attr(node,attr)
library(rvest)
# xml2::read_html(url, encoding=)
# rvest::html_nodes(node, css, xpath);
# rvest::html_table(x, header = NA, trim = TRUE, fill = FALSE, dec = ".")
# rvest::html_text()


# Before running the code -------------------------------------------------

# 1. What is HTML?
# 2. What is xpath?
# 3. What is regular expression?



# 1. Get table data by rvest::html_table() ---------------------------------

### Setting locale for Windows users
if (installr::is.windows()) {
	original_locale <- Sys.getlocale("LC_COLLATE")
	Sys.setlocale("LC_ALL", 'C') # 'C' stands for C language
}




# 1.1 Getting and parsing xml doc -----------------------------------------

url   <- "https://tw.money.yahoo.com/currency-converter"
doc   <- read_html(url, encoding="UTF-8")
class(doc) #[1] "xml_document" "xml_node" 


# 1.2.1 Getting all <table> nodes by xpath ----------------------------------

tables <- xml_find_all(doc, "//table") #xml2::xml_find_all()
class(tables) # [1] "xml_nodeset"


# 1.2.2 Getting tables by css selector -----------------------------

tables <- html_nodes(doc, "table") # rvest::html_nodes()



# 1.3 Converting tables to data.frames ------------------------------------

### Method 1: Converting a selected table to data.frame
table.df <- html_table(tables[[2]], fill = TRUE)

### Method 2.1: Converting multiple tables into a list
tables.list <- html_table(tables, fill = TRUE)
class(tables.list)
length(tables.list)

### Method 2.2: Converting tables in the list to data.frames
table1.df <- as.data.frame(tables.list[[1]])
table2.df <- as.data.frame(tables.list[[2]])






# Practice1: Yahoo currency exchange rate table ---------------------------

url <- "https://tw.finance.yahoo.com/h/kimosel.php?tse=1&cat=%A5b%BE%C9%C5%E9&form=menu&form_id=stock_id&form_name=stock_name&domain=0"
url <- "https://tw.finance.yahoo.com/h/kimosel.php?tse=1&cat=%E6%B0%B4%E6%B3%A5&form=menu&form_id=stock_id&form_name=stock_name&domain=0"
doc   <- read_html(url)

tables <- xml_find_all(doc, "//table")

tables.list <- html_table(tables, fill = TRUE)
length(tables.list)
for(i in 1:length(tables.list)){
	print(dim(tables.list[[i]]))
}

table.df <- html_table(tables[[5]], fill = TRUE)





# Practice2: Traffic accidents --------------------------------------------

url <- "http://www.hpb.gov.tw/files/11-1000-136-1.php" # traffic accidents






# Pracitce3: Calories table -----------------------------------------------

# click ctrl on mac(or shift on wins) and mouse left to open the link
url <- "http://211.21.168.52/FOOD/%B6%BC%AE%C6%C3%FE.htm"




# 2. Get table manually ---------------------------------------------------

url   <- "https://tw.money.yahoo.com/currency-converter"
doc   <- read_html(url, encoding="UTF-8")
table <- xml_find_first(doc, '//*[@id="Main"]//table')

heads <- xml_text(xml_find_all(table, "thead//td"))
bodys <- xml_text(xml_find_all(table, "tbody//td"))
m <- matrix(bodys, ncol=length(heads), byrow=T)
df <- as.data.frame(m)
names(df) <- heads

# 2. (options) All by rvest and magittir
tables <- read_html(url, encoding="UTF-8") %>%
	html_nodes("#Main table") %>%
	html_table(header = TRUE)



# 3. (More) Cleaning exchange rate ----------------------------------------

# Labeling column and rows
names(table.df) <- c('cname', 'bank', 'ibuyin', 'ibuyout', 'cbuyin', 'cbuyout')
rownames(table.df) <- table.df[,1]

# Delete the first row and the first column
table.df <- table.df[-1,-1]

# Assign NA to '-' field
table.df[table.df=='-'] <- NA

# Recover numeric vector from character
table.df$cbuyin <- as.numeric(table.df$cbuyin)
table.df$cbuyout <- as.numeric(table.df$cbuyout)

summary(table.df)

# Get the complete row
tdf <- table.df[complete.cases(table.df),]

# na.omit() to delete incomplete data record: row with NA
tdf1 <- na.omit(table.df[c(1, 4, 5)]) 

# Practice: Select data whose cbuyin smaller than cbuyout
tdf_test <- tdf1[tdf1$cbuyin<tdf1$cbuyout, ]

# Practice: Use subset to select data you want
subset(tdf1, subset = cbuyin < cbuyout)





# Practice: Clean traffic accident rate data ------------------------------

url <- 'http://www.hpb.gov.tw/files/11-1000-136-1.php'
doc <- read_html(url)
tables <- html_nodes(doc, "table.p_t1 table")
table1 <- html_table(tables[1], fill = T)
fw_df <- data.frame(table1)
View(fw_df)
colnames(fw_df)
unlist(fw_df[1,])
colnames(fw_df) <- c('year', 'MVK', 'occurs', 'perc', 'fatal', 'fatal_rate', 'hurt', 'hurt_rate')
fw_df <- fw_df[-1,]
fw_df <- fw_df[-nrow(fw_df),]
fw_df$year <- as.numeric(sub("([0-9]+)年", "\\1", fw_df$year))
fw_df$year
rownames(fw_df) <- fw_df$year
bp <- barplot(as.numeric(fw_df$fatal_rate))
axis(1,at=bp,labels=rownames(fw_df))