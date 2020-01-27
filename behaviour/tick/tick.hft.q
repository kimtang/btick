

.bt.add[`;`.tick.upd]{[allData;tname;data]
 data:$[.tick.a tname;.tick.addTime;(::)]data;
 .tick.l enlist d:(`upd;tname;data);
 .tick.i:.tick.i + 1;
 hdls:exec hdl from .tick.con where tname = allData`tname,not null hdl;
 / hdls@\:d;
 -25!(hdls;d);
 .tick.j:.tick.j + 1;
 }

/

.tick.eodTime:23:59:59.999

.bt.add[`.library.init;`.tick.init.schemas]{
 .tick.schemas:select from .schemas.con where subsys = .proc`subsys,`default`tick.uid {max x in y}/:tick;
 .tick.c:exec tname!column from .tick.schemas;
 .tick.t:exec tname from .tick.schemas;
 .tick.a:exec tname!addTime from .tick.schemas;
 rsubscribers:exec uid by subsys  from .sys where env = .proc`env,`tick.sub in/:library;
 rsubscribers:rsubscribers,(enlist[`default]!exec uid from .sys where subsys = .proc.subsys,`tick.sub in/:library);
 t:ungroup select subsys,tname,rsubscriber:{distinct raze x} each rsubscribers rsubscriber from .tick.schemas;
 t:update hdl:0ni from t;
 .tick.con:t;
 }



.bt.add[`.tick.init.schemas;`.tick.hft.iLogFile]{
 .tick.nLogFile:0;	
 .tick.logFiles:`$();
 .tick.d:.z.D;
 .tick.L: `$.bt.print[":%data%/tick/%d%.%nLogFile%"] .tick,.proc;
 .[.tick.L;();:;()];
 .tick.l:hopen .tick.L;
 .tick.i:0;
 .tick.j:0;
 }

.bt.addDelay[`.tick.hft.cLogFile]{`tipe`time!(`in;00:30)}
.bt.add[`.tick.hft.iLogFile`.tick.hft.cLogFile;`.tick.hft.cLogFile]{
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

.bt.addOnlyBehaviour[`.tick.hft.cLogFile]`.bus.sendTweet

.bt.addDelay[`.tick.hft.eod]{`tipe`time!(`at;.tick.d + .tick.eodTime )}
.bt.add[`.tick.hft.iLogFile`.tick.hft.eod;`.tick.hft.eod]{
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

.bt.addOnlyBehaviour[`.tick.hft.eod]`.bus.sendTweet

.bt.add[`;`.tick.sub]{[uid] update hdl:.z.w from `.tick.con where rsubscriber = uid; `L`i`j#.tick}

.bt.add[`.hopen.pc;`.tick.pc]{[zw] update hdl:0ni from `.tick.con where zw = hdl;}

upd:{[tname;data] .bt.action[`.tick.upd] `tname`data!( $[10h = type tname;`$;(::)] tname;data); }

.bt.add[`;`.tick.upd]{[allData;tname;data]
 data:$[.tick.a tname;.tick.addTime;(::)]data;
 .tick.l enlist d:(`upd;tname;data);
 .tick.i:.tick.i + 1;
 hdls:exec hdl from .tick.con where tname = allData`tname,not null hdl;
 / hdls@\:d;
 -25!(hdls;d);
 .tick.j:.tick.j + 1;
 }

.bt.addIff[`.tick.askForLogs]{[data] .proc.uid = data`uid}
.bt.add[`;`.tick.askForLogs]{ `topic`data!(`.tick.logFiles;`uid`logFiles`d # .tick,.proc)}

.bt.addOnlyBehaviour[`.tick.askForLogs]`.bus.sendTweet

/ 

heartbeat

select from .bt.history where not null error