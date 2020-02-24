
.error.sendTime:`second$1
.error.con:flip`time`uid`nsp`error`msg!"psss*"$\:()


.bt.add[`;`.error.send]{[allData] `.error.con insert cols[.error.con]#allData; }


.bt.add[`.library.init;`.error.init]{} / nothing to init

.bt.addDelay[`.error.checkError]{`tipe`time!(`in;.error.sendTime)}

.bt.add[`.error.init`.error.checkError;`.error.checkError]{} / nothing to do


.bt.addIff[`.error.tweet]{0< count .error.con}

.bt.add[`.error.checkError;`.error.tweet]{
 con:.error.con;
 delete from `.error.con;
 `topic`data!enlist[`.error.receiveError;] con
 }

.bt.addOnlyBehaviour[`.error.tweet]`.bus.sendTweet


/ 

select from .bt.repository

reverse select from .bt.history where action like ".error.tweet"