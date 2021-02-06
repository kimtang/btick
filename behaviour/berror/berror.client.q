
.berror.sendTime:`second$2
.berror.seq:-1

.bt.add[`.library.init;`.berror.init]{} / nothing to init

.bt.addDelay[`.berror.bcheckError]{`tipe`time!(`in;.berror.sendTime)}

.bt.add[`.berror.init`.berror.bcheckError;`.berror.bcheckError]{[allData]
 oseq:.berror.seq;
 .berror.seq:max exec seq from .bt.history where seq > oseq;
 berror:select from .bt.history where seq > oseq,not null error;
 :.bt.md[`berror] berror
 }


.bt.addIff[`.berror.tweet]{[berror] 0 < count berror}
.bt.add[`.berror.bcheckError;`.berror.tweet]{[berror]
 `topic`data!enlist[`.berror.receiveError;] `uid xcols update uid:.proc.uid from berror	
 }


.bt.addOnlyBehaviour[`.berror.tweet]`.bus.sendTweet


/ 

