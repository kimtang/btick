

.bt.add[`.library.init;`.usage.init]{} / nothing to init

.z.pg:{ r:.bt.action[`.usage.pg] `guid`user`hdl`host`arg!(.bt.guid1[];.z.u;.z.w;"i"$0x0 vs .z.a;x); if[not null r`error;'r`error]; :r`result }


.bt.add[`.usage.pg;`.usage.tweetFlush]{[allData]
 .bt.action[`.bus.sendTweetFlush] `topic`data!enlist[`.usage.receivePg.beforeExecution;] r:(`etime`uid!(.z.P;.proc.uid)),`guid`user`hdl`host`arg#allData;
 r
 }

.bt.add[`.usage.tweetFlush;`.usage.value]{[arg;allData]
 @[{r:value x;:`ftime`result`error!(.z.P;r;`)};arg;{:`ftime`result`error!(.z.P;();`$x)}]
 }

.bt.add[`.usage.value;`.usage.return]{[allData]
 `topic`data!enlist[`.usage.receivePg.afterExecution;] `ftime`guid`uid`error# allData
 }


.bt.addOnlyBehaviour[`.usage.return]`.bus.sendTweet


/ 