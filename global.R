#global vars

#chart plot subset options
PERIOD <- data.frame(show=c('all','last month','last 3 months','last 6 months','last year'),
                     opt=c(1e5,30,90,180,365),
                     stringsAsFactors=F)

#chart plot TA optioins
TAS <- data.frame(show=c("5 day SMA","10 day SMA","20 day SMA","60 day SMA","MACD","Volumn","Bollinger Bands"),
                  opt=c("addSMA(n=5,col='#BBBBBB')","addSMA(n=10,col='#FFD700')","addSMA(n=20,col='purple')",
                        "addSMA(n=60,col='green')","addMACD()","addVo()","addBBands()"),
                  stringsAsFactors=F)

#watch <- NULL
#watch <- as.list(sort(watch))

food <- c("HRL","MKC","CVGW","SEB","RMCF","TSN","IBA","MJN","GMK","TR","KRFT")
food <- as.list(sort(food))


etf <- c("QQQ","IWM","IBB")
etf <- as.list(sort(etf))