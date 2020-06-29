
.bt.add[`.library.init;`.hopen.init]{[allData]}

.poc.con:enlist`time`ftime`ipa`userId`hdl!(.z.P;.z.P;.Q.host .z.a;.z.u;0ni)

.pw.con:enlist`time`user`passwd`result!(.z.P;`;enlist"";0b)

.z.pc:{ .bt.action[`.hopen.pc] enlist[`zw]!enlist x }
.z.po:{ .bt.action[`.hopen.po] `zw`zu`za!(.z.w;.z.u;.Q.host .z.a) } 

.z.pw:{[user;passwd] r:.bt.action[`.hopen.pw] `user`passwd!(user;passwd);r`result }


.bt.add[`;`.hopen.po]{[zw;zu;za] `.poc.con insert `time`ftime`ipa`userId`hdl!(.z.P;0np;za;zu;zw);}
.bt.add[`;`.hopen.pc]{[zw] update ftime:.z.P from `.poc.con where hdl=zw,null ftime; }

.bt.add[`;`.hopen.pw]{[allData] `.pw.con insert cols[.pw.con]#o:allData,`time`result!.z.P,1b;o}

/ `.hopen.po.internal

.bt.addIff[`.hopen.po.internal]{[zu] (not null zu) and zu in exec uid from .hopen.con }
.bt.add[`.hopen.po;`.hopen.po.internal]{[zu;za;zw]
 update hdl:zw from `.hopen.con where uid = zu;
 .bt.md[`result]select from .hopen.con where uid = zu
 }

.hopen.con:1!enlist`uid`host`port`user`passwd`hdl!(`;`;0nj;`;enlist"";0ni)

.bt.add[`;`.hopen.add]{[allData]
 if[not min `uid`host`port in key allData;.bt.stdOut0[`error;`hopen] "Uid,host and port are missing";'`.hopen.param];
 if[null allData`uid;.bt.stdOut0[`error;`hopen] "uid is null";'`.hopen.param];  
 `.hopen.con upsert cols[.hopen.con]#(`user`passwd`hdl!``,0ni),allData;
 }


.hopen.connect:{ 
   hp:`$.bt.print[":%host%:%port%:%user%:%passwd%"] x;
   hp:@[hopen;(hp;$[.z.h=x`host;1000;300]);0ni];
   @[x;`hdl;:;hp]
   }

.bt.addDelay[`.hopen.loop]{`tipe`time!(`in;first 00:00:07+1?7)}

.bt.add[`.hopen.init`.hopen.loop;`.hopen.loop]{
 procs:(.bt.action[`.pm.init] (`subsys`cmd`proc`debug`print!``status`all,10b),`folder`env#$[()~key `.proc;.env.arg;.proc])`result;
 a:.hopen.con lj 1!select uid,pid from procs;
 a:select from a where null hdl, not null uid;
 a:select from a where not (host=.z.h) and null pid; 
 result:{@[.hopen.connect;x;x] }@'0!a:delete pid from a;
 if[0=count result;:.bt.md[`result] 0#a];
 .hopen.con:.hopen.con lj 1!result;
 .bt.md[`result]select from result where not null hdl	
 }

.bt.addIff[`.hopen.success]{[result] not 0=count result }
.bt.add[`.hopen.loop`.hopen.po.internal;`.hopen.success]{} / signal other library

.bt.add[`;`.hopen.remove.uid]{[uid]uid0:uid;
 remove:0!select from .hopen.con where uid=uid0;
 delete from `.hopen.con where uid = uid0; 
 hclose@'exec hdl from remove where not null hdl ;
 .bt.md[`remove] remove
 }


.bt.add[`.hopen.pc;`.hopen.remove.hdl]{[zw]
 update hdl:0ni from `.hopen.con where hdl = zw;
 }


/ 

select from .bt.history where action = `.hopen.loop
