
.info.sendTime:`second$1
.info.con:flip`time`uid`nsp`error`msg!"psss*"$\:()


.bt.add[`;`.info.send]{[allData] `.info.con insert cols[.info.con]#allData; }


.bt.add[`.library.init;`.info.init]{} / nothing to init

.bt.addDelay[`.info.checkError]{`tipe`time!(`in;.info.sendTime)}

.bt.add[`.info.init`.info.checkError;`.info.checkError]{} / nothing to do


.bt.addIff[`.info.tweet]{0< count .info.con}

.bt.add[`.info.checkError;`.info.tweet]{
 con:.info.con;
 delete from `.info.con;
 `topic`data!enlist[`.info.receiveError;] con
 }

.bt.addOnlyBehaviour[`.info.tweet]`.bus.sendTweetFlush


/ 