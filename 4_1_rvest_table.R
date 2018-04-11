### Slide: https://docs.google.com/presentation/d/e/2PACX-1vSGeNG6BcEUNjhZjqo1obJ9bijuMjKJ0WhEva29-AuishNv779rSC0nDShfkR5HcWp4EdlRUBaaiG0M/pub?start=false&loop=false&delayms=3000

pkgs <- c("xml2", "rvest", "installr")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])] 
if(length(pkgs)) install.packages(pkgs)

library(rvest)
# xml2::read_html(url, encoding=)
### rvest::html_nodes(node, css, xpath);
### rvest::html_table(x, header = NA, trim = TRUE, fill = FALSE, dec = ".")
### rvest::html_text()
# library(xml2)
### xml2::read_html(url, encoding=)
### xml2::xml_find_first(node, xpath)
### xml2::xml_find_all(node, xpath)
### xml2::xml_text(node)
### xml2::xml_attr(node,attr)


# Before running the code -------------------------------------------------

# 1. What is HTML?
# 2. What is xpath?
# 3. What is regular expression?



# 1. Get table data by rvest::html_table() ---------------------------------

### Setting locale for Windows users
# Sys.setlocale("LC_ALL", 'C') # 'C' stands for C language

# if (installr::is.windows()) {
# 	original_locale <- Sys.getlocale("LC_COLLATE")
# 	Sys.setlocale("LC_ALL", 'C') # 'C' stands for C language
# }




# 1.1 Getting and parsing xml doc -----------------------------------------

url   <- "https://tw.money.yahoo.com/currency-converter"
doc   <- read_html(url, encoding="utf-8")
class(doc) #[1] "xml_document" "xml_node" 


# 1.2.2 Getting tables by css selector -----------------------------

tables <- html_nodes(doc, "table") # rvest::html_nodes()
class(tables) # [1] "xml_nodeset"


# 1.3 Converting tables to data.frames ------------------------------------

### Method 1: Converting a selected table to data.frame
table.df <- html_table(tables[[2]], fill = TRUE)
dim(table.df)

### Method 2: Converting all tables at once
tables.list <- html_table(tables, fill = TRUE)
str(tables.list)
length(tables.list)
View(tables.list)





# Practice1: Yahoo currency exchange rate table ---------------------------

url <- "https://tw.finance.yahoo.com/h/kimosel.php?tse=1&cat=%A5b%BE%C9%C5%E9&form=menu&form_id=stock_id&form_name=stock_name&domain=0"
url <- "https://tw.finance.yahoo.com/h/kimosel.php?tse=1&cat=%E6%B0%B4%E6%B3%A5&form=menu&form_id=stock_id&form_name=stock_name&domain=0"
doc   <- read_html(url)

tables <- html_nodes(doc, "table")

tables.list <- html_table(tables, fill = TRUE)
length(tables.list)
for(i in 1:length(tables.list)){
	print(dim(tables.list[[i]]))
}

table.df <- html_table(tables[[5]], fill = TRUE)





# Practice2: Traffic accidents --------------------------------------------

url <- "http://www.hpb.gov.tw/files/11-1000-136-1.php" # traffic accidents
doc   <- read_html(url)

tables <- html_nodes(doc, "table")
tables.list <- html_table(tables, fill = TRUE)
length(tables.list)

# print out all dim() to check the index of target table
for(i in 1:length(tables.list)){
	print(dim(tables.list[[i]]))
}

table.df <- html_table(tables[[6]], fill = TRUE)





# Pracitce3: Calories table -----------------------------------------------

# click ctrl on mac(or shift on wins) and mouse left to open the link
url <- "http://211.21.168.52/FOOD/%B6%BC%AE%C6%C3%FE.htm"

doc <- read_html(url)
tables <- html_nodes(doc, "table table table")
Sys.setlocale(category="LC_ALL", locale="C") # for html_table()
ctable <- html_table(tables[[1]], fill = T)
Sys.setlocale(category="LC_ALL", locale="utf-8") # for View(df)
View(ctable)
