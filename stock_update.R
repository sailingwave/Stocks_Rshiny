# A script to scrape trending stocks from xueqiu.com
# Nan Wang

.libPaths("/Users/Nan/bin/R_LIB")
library(RSelenium)
library(XML)

url_china='http://xueqiu.com/s/?exchange=US&industry=%E4%B8%AD%E5%9B%BD%E6%A6%82%E5%BF%B5%E8%82%A1'
url_star='http://xueqiu.com/s/?exchange=US&industry=%E6%98%8E%E6%98%9F%E8%82%A1'

startServer()
Sys.sleep(5)    #wait for 5 sec

addCap <- list(phantomjs.page.settings.userAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:29.0)Gecko/20120101 Firefox/29.0",phantomjs.binary.path = "/Users/Nan/bin/installs/phantomjs-2.0.0/bin/phantomjs")
remDr <- remoteDriver(browserName = 'phantomjs',extraCapabilities = addCap)

remDr$open()
#remDr$setTimeout(type = "page load", milliseconds = 10000)

remDr$navigate(url_china)
content <- remDr$getPageSource()
tree <- htmlParse(content,asText = T)
tables <- readHTMLTable(tree)
stocks_china = sort(as.character(tables[[1]][[1]]))

remDr$navigate(url_star)
content <- remDr$getPageSource()
tree <- htmlParse(content,asText = T)
tables <- readHTMLTable(tree)
stocks_star = sort(as.character(tables[[1]][[1]]))

remDr$close()
remDr$closeServer()

write.table(stocks_china,"/Users/Nan/Desktop/china.txt",quote = F,row.names = F,col.names = F)
write.table(stocks_star,"/Users/Nan/Desktop/star.txt",quote = F,row.names = F,col.names = F)
