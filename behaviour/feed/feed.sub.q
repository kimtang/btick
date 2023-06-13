

.bt.add[`.library.init;`.feed.init.schemas]{
 .feed.schemas:select from .schemas.con where (.proc[`subsys] in/:rsubscriber) or ((subsys = .proc`subsys) and `default in/:rsubscriber);
 .feed.c:exec tname!column from .feed.schemas;
 .feed.t:exec tname!tname from .feed.schemas; 
 .feed.u: (enlist[`]!enlist {[x;y]}), exec tname!upd from .feed.schemas;
 .feed.oc: exec tname!ocolumn from .feed.schemas;   
 .feed.a:exec tname!rattr from .feed.schemas;
 .feed.con:select uid,subsys,host:`$host,user:.proc.uid,port,passwd,hdl:0ni from .sys where subsys in (distinct .feed.schemas`subsys),`tick.batch`tick.hft {max x in y}/:library;
 / .bt.execute[{[tname;column;tipe] tname set `date xcols update date:.z.D from flip column!tipe$\:()}]@'.feed.schemas;  
 .bt.action[`.hopen.add] @'`uid`host`port`user`passwd#.feed.con;
 }



.bt.addIff[`.feed.success]{[result] 0< count select from result where uid in .feed.con`uid  }
.bt.add[`.hopen.success;`.feed.success]{[result] 
 result:select from result where uid in .feed.con`uid;
 .feed.con:.feed.con lj 1!result:select uid,hdl from result;
 .bt.md[`result]result
 }


.bt.add[`.hopen.pc;`.feed.pc]{[zw] update hdl:0ni from `.feed.con where zw = hdl;  }

.feed.upd:{[tname;data] (neg .feed.con[`hdl]0) ("upd";tname;data)}