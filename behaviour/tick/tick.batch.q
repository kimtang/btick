
.bt.add[`.tick.init.schemas;`.tick.batch.schemas]{
 .bt.execute[{[tname;column;ocolumn;tipe]t:(column!tipe) ocolumn ;tname set flip ocolumn!()}]@'.tick.schemas;
 }

.bt.add[`;`.tick.upd]{[allData;tname;data]
 data:$[.tick.a tname;.tick.addTime;(::)]data;
 .tick.l enlist d:(`upd;tname;data);
 .tick.i:.tick.i + 1;
 data:.tick.addCols[tname;data];
 tname insert data;
 }

.bt.addDelay[`.tick.publish.data]{`tipe`time!(`in;00:00:00.500)}
.bt.add[`.tick.init.schemas`.tick.publish.data;`.tick.publish.data]{
 {[tname0]
  hdls:exec hdl from .tick.con where tname = tname0,not null hdl;
  d:(`upd;tname0;get tname0);
  -25!(hdls;d);
  delete from tname0;
  }@'.tick.t where 0<(count get @)@'.tick.t;
  .tick.j:.tick.i;
 } 

/

property

.bt.repository

select from .bt.behaviours where sym like ".tick.upd"

.tick.eodTime:23:59:59.999

.bt.add[`.library.init;`.tick.init.schemas]{
 .tick.schemas:select from .schemas.con where (.proc[`subsys] in/:rsubscriber) or ((subsys = .proc`subsys) and `default in/:rsubscriber);
 .tick.c:exec tname!column from .tick.schemas;
 .tick.t:exec tname!tname from .tick.schemas; 
 .tick.u: (enlist[`]!enlist {[x;y]}), exec tname!upd from .tick.schemas;
 .tick.oc: exec tname!ocolumn from .tick.schemas;   
 .tick.a:exec tname!addTime from .tick.schemas;
 rsubscribers:exec uid by subsys  from .sys where env = .proc`env,`tick.sub in/:library;
 rsubscribers:rsubscribers,(enlist[`default]!exec uid from .sys where subsys = .proc.subsys,`tick.sub in/:library);
 t:ungroup select subsys,tname,rsubscriber:{distinct raze x} each rsubscribers rsubscriber from .tick.schemas;
 t:update hdl:0ni from t;
 .bt.execute[{[tname;column;ocolumn;tipe]t:(column!tipe) ocolumn ;tname set flip ocolumn!()}]@'.tick.schemas;
 .tick.con:t;
 }

.bt.add[`.tick.init.schemas;`.tick.batch.iLogFile]{
 .tick.nLogFile:0;	
 .tick.logFiles:`$();
 .tick.d:.z.D;
 .tick.L: `$.bt.print[":%data%/tick/%d%.%nLogFile%"] .tick,.proc;
 .[.tick.L;();:;()];
 .tick.l:hopen .tick.L;
 .tick.i:0;
 .tick.j:0;
 }

.bt.addDelay[`.tick.batch.cLogFile]{`tipe`time!(`in;00:30)}
.bt.add[`.tick.batch.iLogFile`.tick.batch.cLogFile;`.tick.batch.cLogFile]{
 tmp:.tick;	
 hclose .tick.l;
 .tick.nLogFile:.tick.nLogFile + 1;	
 .tick.logFiles:.tick.logFiles,.tick.L;
 .tick.L: `$.bt.print[":%data%/tick/%d%.%nLogFile%"] .tick,.proc;
 .[.tick.L;();:;()];
 .tick.l:hopen .tick.L;
 .tick.i:0;
 .tick.j:0;
 :`topic`data!(`.tick.logFiles;`uid`logFiles`d # .tick,.proc)
 }

.bt.addOnlyBehaviour[`.tick.batch.cLogFile]`.bus.sendTweet

.bt.addDelay[`.tick.batch.eod]{`tipe`time!(`at;.tick.d + .tick.eodTime )}
.bt.add[`.tick.batch.iLogFile`.tick.batch.eod;`.tick.batch.eod]{
 tmp:.tick;
 hclose .tick.l;
 .tick.nLogFile:0;	
 .tick.logFiles:`$();
 .tick.L: `$.bt.print[":%data%/tick/%d%.%nLogFile%"] .tick,.proc;
 .[.tick.L;();:;()];
 .tick.l:hopen .tick.L;
 .tick.i:0;
 .tick.j:0;
 .tick.d:.tick.d+1;
 :`topic`data!(`.tick.eod; .proc,`d`logFiles#tmp )
 }

.bt.addOnlyBehaviour[`.tick.batch.eod]`.bus.sendTweet

.bt.add[`;`.tick.sub]{[uid] update hdl:.z.w from `.tick.con where rsubscriber = uid; `L`i`j#.tick}

.bt.add[`.hopen.pc;`.tick.pc]{[zw] update hdl:0ni from `.tick.con where zw = hdl;}

upd:{[tname;data] .bt.action[`.tick.upd] `tname`data!( $[10h = type tname;`$;(::)] tname;data); }

.bt.add[`;`.tick.upd]{[allData;tname;data]
 data:$[.tick.a tname;.tick.addTime;(::)]data;
 .tick.l enlist d:(`upd;tname;data);
 .tick.i:.tick.i + 1;
 data:.tick.addCols[tname;data];
 tname insert data;
 }

.bt.addDely[`.tick.publish.data]{`tipe`time!(`in;00:00:00.500)}
.bt.add[`.tick.init.schemas`.tick.publish.data;`.tick.publish.data]{
 {[tname0]
  hdls:exec hdl from .tick.con where tname = tname0,not null hdl;
  d:(`upd;tname0;get tname0);
  -25!(hdls;d);
  .tick.j:.tick.i;   
  }@'.tick.t where 0<(count get @)@'.tick.t;
 }

.bt.addIff[`.tick.askForLogs]{[data] .proc.uid = data`uid}
.bt.add[`;`.tick.askForLogs]{ `topic`data!(`.tick.logFiles;`uid`logFiles`d # .tick,.proc)}

.bt.addOnlyBehaviour[`.tick.askForLogs]`.bus.sendTweet

/