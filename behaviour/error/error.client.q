
.error.sendTime:`second$1
.error.seq:-1

.bt.add[`.library.init;`.error.init]{} / nothing to init

.bt.addDelay[`.error.checkError]{`tipe`time!(`in;.error.sendTime)}

.bt.add[`.error.init`.error.checkError;`.error.checkError]{[allData]
 oseq:.error.seq;
 .error.seq:max exec seq from .bt.history where seq > oseq;
 error:select from .bt.history where seq > oseq,not null error;
 :.bt.md[`error] error
 }


.bt.addIff[`.error.tweet]{[error] 0 < count error}
.bt.add[`.error.checkError;`.error.tweet]{[error]
 `topic`data!enlist[`.error.receiveError;] `uid xcols update uid:.proc.uid from error	
 }


.bt.addOnlyBehaviour[`.error.tweet]`.bus.sendTweet


/ 

