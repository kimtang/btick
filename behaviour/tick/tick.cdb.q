
.bt.add[`.bus.handshake;`.tick.init.schemas]{
 .tick.schemas:select from .schemas.con where subsys = .proc`subsys;
 .tick.c:exec tname!column from .tick.schemas;
 .tick.t:exec tname!tname from .tick.schemas; 
 .tick.tipe: 2!ungroup select tname,column,tipe from .tick.schemas;
 .tick.hattr: 2!ungroup select tname,column,hattr from .tick.schemas; 
 .tick.u: (enlist[`]!enlist {[x;y]}), exec tname!count[i]#enlist[{x insert y}] from .tick.schemas;  
 .tick.a:exec tname!hattr from .tick.schemas;
 .tick.con:first select uid from .sys where subsys = .proc`subsys,`tick.replay {max x in y}/:library;
 .tick.replay:first select from .sys where uid = .tick.con`uid;
 .tick.cdb:.bt.print["%hdb%/cdb"] .tick.replay; 
 .tick.cwd:"";
 }


.bt.addIff[`.tick.loadHdb]{ not ()~key hsym `$ $[.tick.cwd~"";.tick.cdb;"."] }

.bt.add[`.tick.init.schemas`.replay.eod;`.tick.loadHdb]{
 dbpath:$[.tick.cwd~"";.tick.cdb;"."];
 system "l ",dbpath;
 .tick.cwd:.tick.cdb;
 }


.bt.addIff[`.replay.eod]{[data] .tick.con[`uid] in data`uid  }

.bt.add[`;`.replay.eod]{[allData]}

/

tables[]
select from property