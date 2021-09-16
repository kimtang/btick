
source('C:/q/r/qserver/qserver.R')

kdb = open_connection('localhost',8888)

aapl = execute(kdb,'select Date:date,Open:open,High:high,Low:low,Close:close,Volume:size,Adjusted:close from daily where sym=`AAPL')

library(quantmod)
library(xts)

head(aapl)

raapl = read.zoo(aapl)

chartSeries(raapl)

rownames(aapl) <- aapl$date

xaapl = as.xts(aapl)
head(xaapl)

chartSeries(xaapl, type = "bars", theme = chartTheme("white"))

qaapl = as.quantmod.OHLC(xaapl)
