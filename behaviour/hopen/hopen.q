
.bt.add[`.library.init;`.hopen.init]{[allData]}


.poc.con:enlist`time`ftime`ipa`userId`hdl!(.z.P;.z.P;.Q.host .z.a;.z.u;0ni)


.z.pc:{ .bt.action[`.hopen.pc] enlist[`zw]!enlist x }
.z.po:{ .bt.action[`.hopen.po] enlist[`zw]!enlist .z.w } 

.bt.add[`;`.hopen.po]{[zw] `.poc.con insert `time`ftime`ipa`userId`hdl!(.z.P;0np; .Q.host .z.a;.z.u;zw);}
.bt.add[`;`.hopen.pc]{[zw] update ftime:.z.P from `.poc.con where hdl=zw,null ftime; }

.hopen.con:1!enlist`uid`host`port`user`passwd`hdl!(`;`;0nj;`;`;0ni)

.bt.add[`;`.hopen.add]{[allData]
 if[not min `uid`host`port in key allData;.bt.stdOut0[`error;`hopen] "Uid,host and port are missing";'`.hopen.param];
 if[null allData`uid;.bt.stdOut0[`error;`hopen] "uid is null";'`.hopen.param];  
 `.hopen.con insert cols[.hopen.con]#(`user`passwd`hdl!``,0ni),allData;
 }

.hopen.connect:{ 
   hp:`$.bt.print[":%host%:%port%"] a:(where not null enlist[`uid] _ x)#x;
   hp:@[hopen;(hp;1000);0ni];
   @[x;`hdl;:;hp]
   }

.bt.addIff[`.hopen.loop]{not 1=count select from .hopen.con where null hdl, not null uid }

.bt.addDelay[`.hopen.loop]{
	/ select from .hopen.con where null hdl, not null uid
	`tipe`time!(`in;00:00:10)
 }


.bt.add[`.hopen.init`.hopen.loop;`.hopen.loop]{
 procs:(.bt.action[`.pm.init] (`subsys`cmd`proc`debug`print!``status`all,01b),`folder`env#.proc)`result;
 a:.hopen.con lj 1!select uid,pid from procs;
 a:select from a where null hdl, not null uid;
 a:select from a where not (host=`localhost) and null pid; 
 result:{@[.hopen.connect;x;x] }@'0!a:delete pid from a;
 if[0=count result;:.bt.md[`result] 0#a];
 .hopen.con:.hopen.con lj 1!result;
 .bt.md[`result]select from result where not null hdl	
 }

.bt.addIff[`.hopen.success]{[result] not 0=count result }
.bt.add[`.hopen.loop;`.hopen.success]{} / signal other library

.bt.add[`;`.hopen.remove.uid]{[uid]uid0:uid;
 remove:0!select from .hopen.con where uid=uid0;
 delete from `.hopen.con where uid = uid0; 
 hclose@'exec hdl from remove where not null hdl ;
 .bt.md[`remove] remove
 }


.bt.add[`.hopen.pc;`.hopen.remove.hdl]{[zw]
 update hdl:0ni from `.hopen.con where hdl = zw;
 }


