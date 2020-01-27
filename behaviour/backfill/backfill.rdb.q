
.backfill.con:flip`uid`time`status`subsys`tname`parted_column`partition_column`columns`tipe!"gpsssss**"$\:()

.bt.add[`.library.init;`.backfill.init.schemas]{[allData]
 .tick.con:first select uid,subsys,host:`$host,port,hdl:0ni from .sys where `backfill.tick {max x in y}/:library;	
 .bt.action[`.hopen.add] @'enlist `uid`host`port#.tick.con; 
 }

.bt.addIff[`.backfill.success]{[result]0<count select from result where uid in .tick.con`uid}

.bt.add[`.hopen.success;`.backfill.success]{[result] 
 result:first select from result where uid in .tick.con`uid;
 .tick.con:.tick.con,`uid`hdl #result;
 (neg .tick.con.hdl) (`.bt.action;`.backfill.handshake.from.rdb;.proc);
 }

/ .backfill.createSchedule:{[data] .bt.action[`.backfill.createSchedule;data]`uid  }

.bt.add[`;`.backfill.createSchedule]{[allData]
 allData:@[allData;`subsys;{[x;y]$[10h = abs type x;`$x;x]};()];
 allData:@[allData;`tname;{[x;y]$[10h = abs type x;`$x;x]};()];
 allData:@[allData;`parted_column;{[x;y]$[10h = abs type x;`$x;x]};()];
 allData:@[allData;`partition_column;{[x;y]$[10h = abs type x;`$x;x]};()]; 
 allData:@[allData;`columns;{[x;y]$[0h = abs type x;`$x;x]};()];
 allData[`uid]:.bt.guid1[];
 allData[`time]:.z.P;
 allData[`status]:`init;
 `.backfill.con insert cols[.backfill.con]#allData;
 allData
 }


.bt.addIff[`.backfill.schema.exist]{[allData]1=count select from .schemas.con where tname=allData`tname}

.bt.add[`.backfill.createSchedule;`.backfill.schema.exist]{[allData]}

.bt.addIff[`.backfill.schema.nonexist]{[allData]0=count select from .schemas.con where tname=allData`tname}

.bt.add[`.backfill.createSchedule;`.backfill.schema.nonexist]{[tname;tipe;columns]
 tname set flip columns!tipe$\:();
 }

.bt.add[`.backfill.schema.nonexist;`.backfill.twitter.create.logFile]{[allData]
 `topic`data!(`.backfill.receive.create.logFile;allData)
 }


.bt.addOnlyBehaviour[`.backfill.twitter.create.logFile]`.bus.sendTweet


.bt.add[`;`.backfill.receive.created.logFile]{[data]
 update time:.z.P, status:`tick_ready from `.backfill.con where uid = data`uid ;
 }

upd:{[uid;data] .bt.action[`.backfill.upd] `uid`data!(uid;data); }


.bt.add[`;`.backfill.upd]{[uid;data]
  ((exec uid!tname from .backfill.con)uid) insert data
  }


.bt.add[`;`.backfill.acceptSchedule]{[allData]
 s:select from `.backfill.con where uid = allData`uid;	
 update status:`scheduleAccepted from `.backfill.con where uid = allData`uid;
 ![`.;();0b;s`tname ];
 `topic`data!(`.backfill.receive.schedule.accepted;``uid#allData)
 }

.bt.addOnlyBehaviour[`.backfill.acceptSchedule]`.bus.sendTweet

.bt.add[`;`.backfill.runSchedule]{[allData]
 update status:`runSchedule from `.backfill.con where uid = allData`uid;
 `topic`data!(`.backfill.receive.schedule.ran;``uid#allData)
 }

.bt.addOnlyBehaviour[`.backfill.runSchedule]`.bus.sendTweet


.bt.add[`;`.backfill.receive.newData]{[data]
 update status:`finished from `.backfill.con where uid = data`uid;
 ![`.;();0b;enlist data`tname];
 }



