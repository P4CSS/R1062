library(xml2)
library(httr)
options(stringsAsFactors = F)



# PTT1: get article list --------------------------------------------------

url <- "https://www.ptt.cc/bbs/Boy-Girl/index.html"
doc   <- read_html(url) # Get and parse the url
class(doc) # [1] "xml_document" "xml_node"

### By css selector: select value of hrefs
css <- "#main-container > div.r-list-container.action-bar-margin.bbs-screen div > div.title > a"
node.a <- html_nodes(doc, css)
class(node.a) # "xml_nodeset"
links <- html_attr(node.a, "href")

### By xpath
path <- '//*[@id="main-container"]/div[2]//div/div[3]/a'
links <- html_attr(html_nodes(doc, xpath = path), "href")

pre <- "https://www.ptt.cc"
links <- paste0(pre, links) # Recover links
links
system(sprintf("open %s", links[1])) # Open links




# PTT2: Get all links -----------------------------------------------------
pre <- "https://www.ptt.cc"

url <- "https://www.ptt.cc/bbs/Boy-Girl/index.html"
doc   <- read_html(url) # Get and parse the url


# PTT3 Get posts by links -------------------------------------------------









# PTT4 Cookie -------------------------------------------------------------
url <- "https://www.ptt.cc/bbs/Gossiping/index.html"

### Get back html file and convert to string
res <- GET(url, config = set_cookies("over18" = "1"))
res.string <- content(res, "text", encoding = "utf8")

### Testing, storing html string and show it.
write(res.string, "test.html")
file.show("test.html")

### parse string by html parser to R objects
doc <- read_html(res_string, encoding = "utf-8")
pre <- "https://www.ptt.cc"
path <- '//*[@id="main-container"]/div[2]//div/div[3]/a'
links <- html_attr(html_nodes(doc, xpath = path), "href")
links <- paste0(pre, links)
links




# Post: appleDaily --------------------------------------------------------

library(httr)
library(rvest)


# POST1: Get link page 1 --------------------------------------------------
### https://tw.appledaily.com/appledaily/search

url <- "https://tw.news.appledaily.com/search/"
form <- list(searchType = "text",
			 keyword = "柯文哲",
			 totalpage = "22273",
			 page="1",
			 sorttype="1",
			 rangedate = "[20030502 TO 20171112999:99]")

res <- POST(url, body = form)
doc.str <- content(res, "text") # convert result to string
write(doc.str, "test.html") # for testing
file.show("test.html") # for testing
system("open test.html")

### Convert string to xml_nodes
doc <- read_html(doc.str) 



# POST2: Get xpath or css selector of links -------------------------------

original_css <- "#result > li:nth-child(1) > div > h2 > a"
original_xpth <- '//*[@id="result"]/li[1]/div/h2/a'

css <- '#result li > div > h2 > a'
path <- '//*[@id="result"]//li/div/h2/a'

links <- html_attr(html_nodes(doc, css), "href")
links
system(sprintf("open %s", links[1]))

all_links <- c()
for(p in 1:2228){
	form <- list(searchType = "text",
				 keyword = "柯文哲",
				 totalpage = "22273",
				 page=sprintf("%d",p),
				 sorttype="1",
				 rangedate = "[20030502 TO 20171112999:99]")
	res <- POST(url, body = form)
	doc.str <- content(res, "text") # convert result to string
	doc <- read_html(doc.str) 
	css <- '#result li > div > h2 > a'
	links <- html_attr(html_nodes(doc, css), "href")
	all_links <- c(all_links, links)
	message(p)
}

all_links2 <- all_links[!duplicated(all_links)]
all_links <- all_links2
length(all_links)
save(all_links, file="data/appleDaily_KoWJ.rda")






# AppleDaily01. Test: Get one news ----------------------------------------

# Get and parse the 1st url to xml_docment
doc <- read_html(links[3])
write_html(doc, "test.html")
system("open test.html")

# Get the title
css <- "#article > div.wrapper > div > main > article > hgroup > h1"
# path <- '//*[@id="article"]/div[2]/div/main/article/hgroup/h1'
title <- html_text(html_node(doc, css))
title

# Get the content
csspath <- "#article > div.wrapper > div > main > article > div > div.ndArticle_contentBox > article > div > p"
# path <- '//*[@id="article"]/div[2]/div/main/article/div/div[2]/article/div/p'
content <- html_text(html_node(doc, csspath))
content

# Trim white space before and after sentence
content <- trimws(content)
?trimws


# Get the date
css <- "#article > div.wrapper > div > main > article > hgroup > div.ndArticle_creat"
ndate <- html_text(html_node(doc, css))
ndate
ndate <- gsub("建立時間：", "", ndate)

# Convert to timestamp

temp.df <- data.frame(
	title = title,
	content = content,
	ndate = ndate)




# AppleDaily02 Get all News -----------------------------------------------
all.df <- data.frame()
for(i in 1:length(all_links)){
	url <- all_links[i]
	doc <- read_html(url)
	
	title <- html_text(html_node(doc, "#article > div.wrapper > div > main > article > hgroup > h1"))	
	content <- html_text(html_node(doc, "#article > div.wrapper > div > main > article > div > div.ndArticle_contentBox > article > div > p"))
	ndate <- html_text(html_node(doc, "#article > div.wrapper > div > main > article > hgroup > div.ndArticle_creat"))
	all.df <- bind_rows(all.df, data.frame(title=title, content=content, ndate=ndate))
	message(i)
	if(i > 100){break}
}



# Practice ----------------------------------------------------------------

# AppleDaily donation
url1 <- "http://www.appledaily.com.tw/charity/projlist/" 
# Taichung Gov
url2 <- "http://www.society.taichung.gov.tw/section/index-1.asp?Parser=99,16,257,,,,3807,589,,,,42,,3"
# Weather history
url3 <- "http://e-service.cwb.gov.tw/HistoryDataQuery/index.jsp"
# Taiwan Buying
url4 <- "https://www.taiwanbuying.com.tw/QueryCC_Dateaction.ASP?yy=106&mm=10&dd=11"



# Get all links of cases listed on the page
url_591 <- "https://rent.591.com.tw/new/?kind=2&region=1"
doc   <- read_html(url_591)
href <- xml_attr(xml_find_all(doc, '//*[@id="content"]//li/h3/a'), 'href')
href <- paste0("http:", trimws(href))
href


# Practice: https://web.pcc.gov.tw/tps/pss/tender.do?method=goSearch&searchMode=common&searchType=advance&searchTarget=ATM

# Practice: How to get back all news of http://news.ebc.net.tw/

# Practice: How to get more search result of http://news.ebc.net.tw/








