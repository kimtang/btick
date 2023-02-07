
d) module
 hopen
 hopen provides a set of functions to maintain connections in kdb+. After loading it you need to trigger .hopen.init
 q).behaviour.module`hopen


.bt.add[`;`.hopen.init]{[allData]}

d) function
 hopen
 `.hopen.init
 Start the hopen loop to open connections 
 q) .bt.action[`.hopen.init] ()!()


.poc.con:enlist`time`ftime`ipa`userId`hdl!(.z.P;.z.P;.Q.host .z.a;.z.u;0ni)

.pw.con:enlist`time`user`passwd`result!(.z.P;`;enlist"";0b)

.z.pc:{ .bt.action[`.hopen.pc] enlist[`zw]!enlist x }
.z.po:{ .bt.action[`.hopen.po] `zw`zu`za!(.z.w;.z.u;.Q.host .z.a) } 

.z.pw:{[user;passwd] r:.bt.action[`.hopen.pw] `user`passwd!(user;passwd);r`result }


.bt.add[`;`.hopen.po]{[zw;zu;za] `.poc.con insert `time`ftime`ipa`userId`hdl!(.z.P;0np;za;zu;zw);}
.bt.add[`;`.hopen.pc]{[zw] update ftime:.z.P from `.poc.con where hdl=zw,null ftime; }

.bt.add[`;`.hopen.pw]{[allData] `.pw.con insert cols[.pw.con]#o:allData,`time`result!.z.P,1b;o}

.bt.addIff[`.hopen.po.internal]{[zu] (not null zu) and zu in exec uid from .hopen.con }
.bt.add[`.hopen.po;`.hopen.po.internal]{[zu;za;zw]
 update hdl:zw from `.hopen.con where uid = zu;
 .bt.md[`result]select from .hopen.con where uid = zu
 }

.hopen.con:1!enlist`uid`host`port`user`passwd`hdl!(`self;.z.h;"j"$system"p";`;enlist"";0i)

.bt.add[`;`.hopen.add]{[allData]
 if[not min `uid`host`port in key allData;.bt.stdOut0[`error;`hopen] "Uid,host and port are missing";'`.hopen.param];
 if[null allData`uid;.bt.stdOut0[`error;`hopen] "uid is null";'`.hopen.param];  
 `.hopen.con upsert cols[.hopen.con]#(`user`passwd`hdl!``,0ni),allData;
 }

d) function
 hopen
 .hopen.add
 Add a connection 
 q) .bt.action[`.hopen.add] `uid`host`port!(`myuid;`localhost;8890)
 q) .bt.action[`.hopen.add] `uid`host`port`user`passwd!(`myuid;`localhost;8890;`username;"mypasswd")
 q) .hopen.con / to check the handle  


.hopen.connect:{ 
   hp:`$.bt.print[":%host%:%port%:%user%:%passwd%"] x;
   hp:@[hopen;(hp;$[.z.h=x`host;1000;2300]);0ni];
   @[x;`hdl;:;hp]
   }

.bt.addDelay[`.hopen.loop]{`tipe`time!(`in;first 00:00:07+1?7)}

/ .bt.add[`.hopen.init`.hopen.loop;`.hopen.loop.old]{
/  procs:(.bt.action[`.pm.init] (`subsys`cmd`proc`debug`print!``status`all,10b),`folder`cfg#$[()~key `.proc;.env.arg;.proc])`result;
/  a:.hopen.con lj 1!select uid,pid from procs;
/  a:select from a where null hdl, not null uid;
/  a:select from a where not (host=.z.h) and null pid; 
/  result:{@[.hopen.connect;x;x] }@'0!a:delete pid from a;
/  if[0=count result;:.bt.md[`result] 0#a];
/  .hopen.con:.hopen.con lj 1!result;
/  .bt.md[`result]select from result where not null hdl	
/  }

.bt.add[`.hopen.init`.hopen.loop;`.hopen.loop]{
 / procs:(.bt.action[`.pm.init] (`subsys`cmd`proc`debug`print!``status`all,10b),`folder`cfg#$[()~key `.proc;.env.arg;.proc])`result;
 / a:.hopen.con lj 1!select uid,pid from procs;
 a:select from .hopen.con where null hdl, not null uid;
 / a:select from a where not (host=.z.h) and null pid; 
 result:{@[.hopen.connect;x;x] }@'0!a:delete pid from a;
 if[0=count result;:.bt.md[`result] 0#a];
 .hopen.con:.hopen.con lj 1!result;
 .bt.md[`result]select from result where not null hdl 
 }


.bt.addIff[`.hopen.success]{[result] not 0=count result }
.bt.add[`.hopen.loop`.hopen.po.internal;`.hopen.success]{} / signal other library

d) function
 hopen
 .hopen.success
 Get notify when a connection was succesful 
 q) .bt.add[`.hopen.success;`.my.fnc]{[result] result } / result has the structure as from .hopen.con 

.bt.add[`;`.hopen.remove.uid]{[uid]uid0:uid;
 remove:0!select from .hopen.con where uid=uid0;
 delete from `.hopen.con where uid = uid0; 
 hclose@'exec hdl from remove where not null hdl ;
 .bt.md[`remove] remove
 }

d) function
 hopen
 .hopen.remove.uid
 Remove a connection using the id
 q) .bt.action[`.hopen.remove.uid] .bt.md[`uid] uidOfTheProcess 

.bt.add[`.hopen.pc;`.hopen.remove.hdl]{[zw]
 update hdl:0ni from `.hopen.con where hdl = zw;
 }

d) function
 hopen
 .hopen.pc
 get notify when a connection has been closed. In this case hopen will try to reopen
 q) .bt.add[`.hopen.pc;`.my.fnc]{[zw] zw } / zw is the closed handle  


.bt.action[`.hopen.init] ()!();