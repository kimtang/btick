
.websocket.con:enlist`time`ftime`ipa`userId`hdl!(.z.P;.z.P;.Q.host .z.a;.z.u;0ni)

.z.wo:{ .bt.action[`.websoclet.wo] enlist[`zw]!enlist x }
.z.wc:{ .bt.action[`.websoclet.wc] enlist[`zw]!enlist x }

.bt.add[`;`.websocket.po]{[zw] `.websocket.con insert `time`ftime`ipa`userId`hdl!(.z.P;0np; .Q.host .z.a;.z.u;zw);}
.bt.add[`;`.websocket.pc]{[zw] update ftime:.z.P from `.websocket.con where hdl=zw,null ftime; }


.bt.add[`.library.init;`.websocket.init]{} / nothing to init

.z.ws:{ r:.bt.action[`.websocket.ws] `guid`user`hdl`host`arg!(.bt.guid1[];.z.u;.z.w;"i"$0x0 vs .z.a;x); neg[.z.w] .j.j $[null r`error;r`result ;r`error] }


.bt.add[`.websocket.pg;`.websocket.tweetFlush]{[allData]
 .bt.action[`.bus.sendTweetFlush] `topic`data!enlist[`.usage.receivePg.beforeExecution;] r:(`etime`uid!(.z.P;.proc.uid)),`guid`user`hdl`host`arg#allData;
 r
 }

.bt.add[`.websocket.tweetFlush;`.websocket.value]{[arg;allData]
 @[{r:value x;:`ftime`result`error!(.z.P;r;`)};arg;{:`ftime`result`error!(.z.P;();`$x)}]
 }

.bt.add[`.websocket.value;`.websocket.return]{[allData]
 `topic`data!enlist[`.usage.receivePg.afterExecution;] `ftime`guid`uid`error# allData
 }


.bt.addOnlyBehaviour[`.websocket.return]`.bus.sendTweet


/ 