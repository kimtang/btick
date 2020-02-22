
.berror.sendTime:`second$1
.berror.seq:-1

.bt.add[`.library.init;`.berror.init]{}

.bt.addDelay[`.berror.checkError]{`tipe`time!(`in;.berror.sendTime)}

.bt.add[`.berror.init`.berror.checkError;`.berror.checkError]{[allData]
 oseq:.berror.seq;
 .berror.seq:max exec seq from .bt.history where seq > oseq;
 berror:select from .bt.history where seq > oseq,not null error;
 :.bt.md[`berror] berror
 }

.bt.addIff[`.berror.upd]{[berror] 0 < count berror}
.bt.add[`.berror.checkError;`.berror.upd]{[berror]
 `topic`data!enlist[`.berror.receiveError;] `uid xcols update uid:.proc.uid from berror	
 }

.bt.add[`.berror.upd;`.berror.receiveError]{[data] upd[`berror] data }