
.tick.zd:17 3 6

.bt.add[`.bus.handshake;`.tick.init.schemas]{
 .tick.uid: `$.bt.print["%subsys%.%process%.%id%"] .proc;
 .tick.schemas:select from .schemas.con where subsys = .proc`subsys,((`default;.tick.uid) {max x in y}/:tick);
 .tick.c:exec tname!column from .tick.schemas;
 .tick.t:exec tname!tname from .tick.schemas; 
 .tick.tipe: 2!ungroup select tname,column,tipe from .tick.schemas;
 .tick.hattr: 2!ungroup select tname,column,hattr from .tick.schemas; 
 .tick.u: (enlist[`]!enlist {[x;y]}), exec tname!upd from .tick.schemas;
 .tick.oc: exec tname!ocolumn from .tick.schemas;
 .tick.a:exec tname!hattr from .tick.schemas;
 .tick.con:first select uid from .sys where subsys = .proc`subsys,`tick.batch`tick.hft {max x in y}/:library;
 .bt.execute[{[tname;column;tipe] tname set flip column!tipe$\:()}]@'.tick.schemas; 
 .tick.files:flip`date`file`num`replay!();
 .tick.symFile: `$.bt.print["%subsys%sym"] .proc;
 .tick.osymFile: `$.bt.print["o%subsys%sym"] .proc; 
 .tick.eod:flip `date`staging`tname`column`tipe`hattr`hdb`saved!"dsssccsb"$\:();
 }


.bt.addIff[`.tick.waitForTick]{[data] 1 = count select from data where uid = .tick.con`uid }
.bt.add[`.bus.avail;`.tick.waitForTick]{
 `topic`data!(`.tick.askForLogs;.tick.con)
 } 

.bt.addOnlyBehaviour[`.tick.waitForTick]`.bus.sendTweet



.bt.addIff[`.tick.logFiles]{[data] 0<count raze exec logFiles from data where uid in .tick.con`uid }
.bt.add[`;`.tick.logFiles]{[data]
 logFiles:raze exec logFiles from data where uid in .tick.con`uid;
 t:update date:data`d from ([]file:logFiles);
 t:update num:{"J"$last "." vs x}@'string file,replay:0b from t;
 .tick.files : `date`num xasc  0!(2!t) uj 2!.tick.files; 
 }

.bt.addDelay[`.tick.replay.loop]{`tipe`time!(`in;00:00:01)}
.bt.addIff[`.tick.replay.loop]{0<count select from .tick.files where not replay }
.bt.add[`.tick.logFiles`.tick.replay.loop;`.tick.replay.loop]{
 a:first select from .tick.files where not replay;
 update replay:1b from `.tick.files where file = a`file,date = a`date;
 a  
 }


.bt.add[`.tick.replay.loop;`.tick.replay.logFile]{[allData]
 -11!allData`file;
 / t:tables[] 0;
 {[a;t]
  cls:.tick.c t; 
  staging:`$.bt.print[":%data%/staging/%date%/%tname%"] a,.proc,.bt.md[`tname] t;
  {[t;cl;file] .[file;();,;t cl] }'[t;cls;staging .Q.dd/:cls];
  ![t;();0b;0#`]; 
  }[allData]@'key .tick.t;	
 }

.bt.addIff[`.tick.eod]{[data] .tick.con[`uid] = data`uid }

.bt.add[`;`.tick.eod]{[data]
 .tick.eod:0#.tick.eod;
 t:update date:data`d from ([]file:data`logFiles);
 t:update num:{"J"$last "." vs x}@'string file,replay:0b from t;
 t:`date`num xasc  0!(2!t) uj 2!select from .tick.files where file in t`file;
 delete from `.tick.files where file in t`file; 
 .bt.action[`.tick.replay.logFile]@'{select from x where not replay}t;
 / hdbpath:`$.bt.print[":%data%/hdb"] .proc;
 s:([]date:data`d;staging:enlist `$.bt.print[":%data%/staging/%d%"] data,.proc);
 s:ungroup update tname: key@'staging from s;
 s:update staging:staging .Q.dd'tname  from s;
 s:ungroup update column:key@'staging from s;
 s:select from s where not column like "*#"; 
 s:update staging:staging .Q.dd'column from s;
 s:s lj .tick.tipe;
 s:s lj .tick.hattr;
 / {([]k:key x;v:value x)}.proc
 s:update hdb:{`$.bt.print[":%hdb%/cdb/%date%/%tname%/%column%"] x,.proc}@'s from s;
 symFile:`$.bt.print[":%hdb%/cdb/%symFile%"] .tick,.proc;
 (.tick`symFile`osymFile) set\: $[symFile~key symFile;get symFile; ()];
 {x set .tick.symFile?get x}@'exec staging from s where tipe="s";
 {x set {.tick.symFile?x}@'get x}@'exec staging from s where tipe="S";
 (`$.bt.print[":%hdb%/archive/%d%/%symFile%"] .tick,data,.proc) set get .tick.symFile;
 symFile set get .tick.symFile;
 .tick.eod:update saved:0b from s; 
 / {[s;t] .bt.md[`data] select from s where tname = t}[s]@'key .tick.t
 }


.bt.addDelay[`.tick.saveTbl]{`tipe`time!(`in;00:00:01)}

.bt.addIff[`.tick.saveTbl]{not 0=count select from .tick.eod where not saved}

.bt.add[`.tick.eod`.tick.saveTbl;`.tick.saveTbl]{
 t:first exec tname from .tick.eod where not saved;
 update saved:1b from `.tick.eod where tname = t;
 s:select from .tick.eod where tname=t;
 if[not 1=count a:select from s where hattr="p";{'`$"missing_p_",x}[t]];
 a:get first[ a]`staging;
 b:$[1=count b:select from s where hattr="S";get first[b]`staging;a];
 iorder:{exec ind from x} `a`b xasc update ind:i from ([]a;b);
 {[iorder;o]
 	data:get[o`staging] iorder;
 	if[o[`hattr] in "pg";data:(`$o[`hattr])#data];
 	(o[`hdb],.tick.zd) set data;
  }[iorder]@'s;

 dpath:.Q.dd[;`.d] -1_` vs s[ 0]`hdb;
 dpath set .tick.c t;
 / save down tbl
 }

.bt.addIff[`.tick.send.replay.eod]{0=count select from .tick.eod where not saved}
.bt.add[`.tick.saveTbl;`.tick.send.replay.eod]{
 `topic`data!(`.replay.eod;.proc,.bt.md[`eod] .tick.eod)
 }

.bt.addOnlyBehaviour[`.tick.send.replay.eod]`.bus.sendTweet


upd:{[tname;data] 
 tname:.tick.t tname;
 data:.tick.addCols[tname;data];
 tname insert .tick.u[ tname ] data;
 }

/ 
