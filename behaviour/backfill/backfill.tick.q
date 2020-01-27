
.backfill.msize:900f / mb
.backfill.con:flip`uid`time`status`subsys`tname`parted_column`partition_column`columns`tipe`ftime!"gpsssss**p"$\:()

.backfill.logFiles:flip`uid`time`nLogFile`file`hdl`size`ftime!"gpjsifp"$\:()
.backfill.hlogFiles:0#.backfill.logFiles

.backfill.rdb:``uid`hdl!({};`;0ni)

.bt.add[`.library.init;`.backfill.tick.init]{[allData]}


.bt.add[`;`.backfill.handshake.from.rdb]{[allData]
 data:.bt.md[`uid] allData`uid;
 data[`hdl]:.z.w;
 .backfill.rdb:data;
 }

.bt.add[`;`.backfill.receive.create.logFile]{[data]
 `.backfill.con insert data;
 }

.bt.add[`.backfill.receive.create.logFile;`.backfill.create.logFile]{[data]
 (`$.bt.print[":%gData%/logFile/%uid%/data"] .proc,data) set data;
 data[`nLogFile]:0;
 data[`ftime]:0np;
 data[`file]: `$.bt.print[":%gData%/logFile/%uid%/%nLogFile%.qlog"] .proc,data;
 .[data[`file];();:;()];
 data[`hdl]:hopen data`file;
 data[`size]:(hcount data`file) % 1024 * 1024;
 `.backfill.logFiles insert cols[.backfill.logFiles]#data;
 `topic`data!(`.backfill.receive.created.logFile;data)
 }


.bt.addOnlyBehaviour[`.backfill.create.logFile]`.bus.sendTweet

upd:{[uid;data] .bt.action[`.backfill.upd] `uid`data!(uid;data); }


.bt.add[`;`.backfill.upd]{[allData;uid;data]
 hdl:(exec uid!hdl from .backfill.logFiles) uid;
 tname:(exec uid!tname from .backfill.con) uid; 
 hdl enlist d:(`upd;tname;data);
 .backfill.logFiles:update size: (hcount each file) % 1024*1024 from .backfill.logFiles where uid = allData`uid;
 (neg .backfill.rdb.hdl) ("upd";uid;data);
 }

.bt.addIff[`.backfill.checkFile]{0 < count select from .backfill.logFiles where size > .backfill.msize }
.bt.add[`.backfill.upd;`.backfill.checkFile]{[allData]
 s:select from .backfill.logFiles where size > .backfill.msize;
 delete from `.backfill.logFiles where size > .backfill.msize; 
 s:update ftime:.z.P from s;
 `.backfill.hlogFiles insert s;
 s:update time:.z.P,nLogFile:nLogFile+1,hdl:{hclose x;0ni}each hdl,file:`,size:0nf from s;
 s:update file:{`$.bt.print[":%gData%/logFile/%uid%/%nLogFile%.qlog"] .proc,x}@'s from s;
 { .[x;();:;()];}@'file from s;  
 s:update hdl:hopen each file from s; 
 s:update size:(hcount each file) % 1024*1024 from s;
 `.backfill.logFiles insert s;  
 }

/ .bt.addIff[`.backfill.receive.schedule.accepted]{[allData] }

.bt.add[`.backfill.receive.schedule.ran;`.backfill.receive.schedule.accepted]{[data]
 if[0=count select from .backfill.logFiles where uid = data`uid;:()];	
 s:select from .backfill.logFiles where uid = data`uid;
 hclose @'s`hdl;
 delete from `.backfill.logFiles where uid = data`uid;
 update status:`scheduleAccepted,ftime:.z.P from `.backfill.con where uid = data`uid;
 sdata set update status:`scheduleAccepted from get sdata:`$.bt.print[":%gData%/logFile/%uid%/data"] .proc,data;
 `.backfill.hlogFiles insert update ftime:.z.P from s;
 data 
 }


.bt.addIff[`.backfill.twitter.replay.ran.schedule]{[allData] (`ranSchedule in key allData) and 1b~allData`ranSchedule }
.bt.add[`.backfill.receive.schedule.accepted;`.backfill.twitter.replay.ran.schedule]{[data]
 `topic`data!(`.backfill.replay.ran.schedule;``uid#data)
 }

.bt.addOnlyBehaviour[`.backfill.twitter.replay.ran.schedule]`.bus.sendTweet

.bt.add[`;`.backfill.receive.schedule.ran]{[allData]
 .bt.md[`ranSchedule]1b
 }

/ 