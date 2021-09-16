
library('ggplot2')

source('C:/q/r/qserver/qserver.R')

kdb <- open_connection('localhost',19010)

d <- execute(kdb,'d')

source('C:/quantumkdb/demo/visorderbook/obk.R')

dyn(d)

g<-ggplot(data = d, aes(x=ind))
a<-g + geom_text(aes(y=price,label=qty,color=dir)) + theme_bw() + 
  xlab('') +theme(axis.text.x=element_blank())

b<-g + geom_text(aes(y=price,label=dqty,color=dir)) + 
  geom_point(aes(y=mid),color="green") +theme(axis.text.x=element_blank())
arrange(a,b,ncol=1)


kdb <- open_connection('localhost',8887)

del <- execute(kdb,'del')
head(del)


ggplot(del,aes(x=ind)) + geom_text(aes(y=dprx,label=dqty,color=clas)) +
  geom_point(aes(y=mid),color="green") + theme_bw()


