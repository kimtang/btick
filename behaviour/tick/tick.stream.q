.tick.eodTime:23:59:59.999

.bt.add[`.library.init;`.tick.init.schemas]{[allData]
 .tick.schemas:select from .schemas.con where subsys = .proc`subsys,`default`tick.uid {max x in y}/:tick;
 .tick.c:exec tname!column from .tick.schemas;
 .tick.t:exec tname from .tick.schemas;
 .tick.a:exec tname!addTime from .tick.schemas;
 .tick.u: (enlist[`]!enlist {[x;y]}), exec tname!upd from .tick.schemas;
 .tick.oc: exec tname!ocolumn from .tick.schemas;    
 rsubscribers:exec uid by subsys  from .sys where env = .proc`env,`tick.sub in/:library;
 rsubscribers:rsubscribers,(enlist[`default]!exec uid from .sys where subsys = .proc.subsys,`tick.sub in/:library);
 t:ungroup select subsys,tname,rsubscriber:{distinct raze x} each rsubscribers rsubscriber from .tick.schemas;
 t:update hdl:0ni from t;
 .tick.con0:t;
 .tick.con:0#.tick.con0;
 }

.bt.add[`.tick.init.schemas;`.tick.stream.iLogFile]{
 .tick.nLogFile:0;	
 .tick.logFiles:`$();
 .tick.d:.z.D;
 .tick.L: `$.bt.print[":%data%/tick/%d%.%nLogFile%"] .tick,.proc;
 .[.tick.L;();:;()];
 .tick.l:hopen .tick.L;
 .tick.i:0;
 .tick.j:0;
 }

.bt.addDelay[`.tick.stream.cLogFile]{`tipe`time!(`in;00:30)}
.bt.add[`.tick.stream.iLogFile`.tick.stream.cLogFile;`.tick.stream.cLogFile]{
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

.bt.addOnlyBehaviour[`.tick.stream.cLogFile]`.bus.sendTweet

.bt.addDelay[`.tick.stream.eod]{`tipe`time!(`at;.tick.d + .tick.eodTime )}
.bt.add[`.tick.stream.iLogFile`.tick.stream.eod;`.tick.stream.eod]{
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

.bt.addOnlyBehaviour[`.tick.stream.eod]`.bus.sendTweet

/ .bt.add[`;`.tick.sub]{[uid;con] update hdl:.z.w from con update hdl:.z.w from `.tick.con where rsubscriber = uid; `L`i`j#.tick}

.bt.add[`;`.tick.sub]{[uid;con] `.tick.con insert update hdl:.z.w from con ; `L`i`j#.tick}

.bt.add[`.hopen.pc;`.tick.pc]{[zw] delete from `.tick.con where zw = hdl;}

upd:{[tname;data] .bt.action[`.tick.upd] `tname`data!( $[10h = type tname;`$;(::)] tname;data); }

.bt.addIff[`.tick.askForLogs]{[data] .proc.uid = data`uid}
.bt.add[`;`.tick.askForLogs]{ `topic`data!(`.tick.logFiles;`uid`logFiles`d # .tick,.proc)}

.bt.addOnlyBehaviour[`.tick.askForLogs]`.bus.sendTweet

/ 