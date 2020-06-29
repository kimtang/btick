
upd:{[tname;data]
 tname:.tick.t tname;
 data:.tick.addCols[tname;data];
 tname insert `date xcols update date:.z.d from .tick.u[ tname ] data;
 }

.bt.add[`.library.init;`.tick.init.schemas]{
 .tick.schemas:select from .schemas.con where (.proc[`subsys] in/:rsubscriber) or ((subsys = .proc`subsys) and `default in/:rsubscriber);
 .tick.c:exec tname!column from .tick.schemas;
 .tick.t:exec tname!tname from .tick.schemas; 
 .tick.u: (enlist[`]!enlist {[x;y]}), exec tname!upd from .tick.schemas;
 .tick.oc: exec tname!ocolumn from .tick.schemas;   
 .tick.a:exec tname!rattr from .tick.schemas;
 .tick.con:select uid,subsys,host:`$host,port,hdl:0ni from .sys where subsys in (distinct .tick.schemas`subsys),`tick.batch`tick.hft {max x in y}/:library;
 .bt.execute[{[tname;column;tipe] tname set `date xcols update date:.z.D from flip column!tipe$\:()}]@'.tick.schemas;  
 .bt.action[`.hopen.add] @'`uid`host`port#.tick.con;
 }



.bt.addIff[`.tick.success]{[result] 0< count select from result where uid in .tick.con`uid  }
.bt.add[`.hopen.success;`.tick.success]{[result] 
 result:select from result where uid in .tick.con`uid;
 .tick.con:.tick.con lj 1!result:select uid,hdl from result;
 .bt.md[`result]result
 }

.bt.add[`.tick.success;`.tick.init.logFiles]{[result]
 logFiles:ungroup update file: {`dontcare,x ".tick.logFiles"}@' hdl,replayed:0b from result;
 logFiles:update replayed:1b from logFiles where file = `dontcare;
 hdls:select from logFiles where ({min x};replayed) fby hdl;
 logFiles:delete from logFiles where ({min x};replayed) fby hdl; 
 `logFiles`result`hdls!(logFiles;result;hdls)	
 }


.bt.addIff[`.tick.replay.logFiles]{[logFiles] 1 <= count select from logFiles where not replayed }
.bt.add[`.tick.init.logFiles`.tick.replay.logFiles;`.tick.replay.logFiles]{[logFiles;result] 
 {@[-11!;x;()]}@'exec file from logFiles where not replayed;
 logFiles:update replayed:1b from logFiles;
 nlogFiles:ungroup update file: {`dontcare,x ".tick.logFiles"}@' hdl,replayed:0b from result;
 nlogFiles:update replayed:1b from nlogFiles where file = `dontcare;
 logFiles:logFiles,select from nlogFiles where not file in logFiles`file; 
 hdls:select from logFiles where ({min x};replayed) fby hdl;
 logFiles:delete from logFiles where ({min x};replayed) fby hdl; 
 `logFiles`hdls!(logFiles;hdls)
 }

.bt.addIff[`.tick.sub]{[logFiles] (0=count logFiles) or not 1 <= count select from logFiles where not replayed }
.bt.add[`.tick.replay.logFiles`.tick.init.logFiles;`.tick.sub]{[hdls]
 hdls:exec distinct hdl from hdls;
 {-11!x`j`L;}@'{
 	subsys0:first exec subsys from .tick.con where hdl = x;
 	con:select subsys,tname,rsubscriber:.proc.uid from .tick.schemas where subsys = subsys0;
 	x (`.bt.action;`.tick.sub;`uid`con!(.proc`uid;con)) 
 	}@'hdls;	
 }


.bt.add[`.hopen.pc;`.tick.pc]{[zw] update hdl:0ni from `.tick.con where zw = hdl;  }

/ data0:.bt.md[`uid]`plant.deepData.webscraping.tick.0

.bt.addIff[`.tick.eod]{[data] data[`uid] in .tick.con`uid }
.bt.add[`;`.tick.eod]{[data]data0:data;
 subsys0:first exec subsys from .sys where uid = data0`uid;
 tnames:exec tname from .tick.schemas where subsys=subsys0;
 {delete from x}@'tnames;
 }


/

-10#heartbeat

select from .bt.history where action = `.tick.init.logFiles
select from .bt.history where action = `.tick.sub
select from .bt.history where not null error
