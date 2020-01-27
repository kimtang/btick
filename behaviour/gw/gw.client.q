
.bt.add[`.library.init;`.gw.init]{[allData]
 .gw.con:select uid,env,subsys,process,`$host,port,hdl:0ni from .sys where `gw.server in/:library,subsys=.proc.subsys;
 .bt.action[`.hopen.add] @'`uid`host`port#.gw.con;
 }


.bt.add[`.hopen.success;`.gw.success]{[result] 
 result:select from result where uid in .gw.con`uid;
 .gw.con:.gw.con lj 1!result:select uid,hdl from result;
 {x (".bt.action";`.gw.handshake;`uid`tipe!(.proc.uid;`rdb`hdb `tick.hdb in .proc.library)) }@'exec neg hdl from result;
 } 


.bt.add[`;`.hopen.pc]{[zw] update hdl:0ni from `.gw.con where zw = hdl;  } 