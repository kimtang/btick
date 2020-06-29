
/ daemon will restart all process

.bt.add[`.library.init;`.daemon.init]{[allData]
 .daemon.con:select uid,restart:0j,pid:0nj,pTime:0np from .sys where (not `daemon in/:library ) , subsys = .proc.subsys, {[arg;global] (global,arg)`daemon }'[arg;global];
 }

.bt.addIff[`.daemon.placeholder]{0<count .daemon.con}
.bt.add[`.daemon.init;`.daemon.placeholder]{[allData]}


.bt.addDelay[`.daemon.loop]{`tipe`time!(`in;first 00:00:07+1?7)}
.bt.add[`.daemon.placeholder`.daemon.loop;`.daemon.loop]{
 procs:1!select uid,pid,pTime:.z.P from (.bt.action[`.pm.init] (`cmd`proc`debug`print!`status`all,00b),`folder`env`subsys#.proc)`result;
 .daemon.con:.daemon.con lj procs;
 }

.bt.addIff[`.daemon.startProcess]{0<count select from .daemon.con where null pid, restart < 4 }

.bt.add[`.daemon.loop;`.daemon.startProcess]{
 a:select from .daemon.con where null pid, restart < 4; / dont restart all, only hdbs and gws but no replay or 
 r:raze {
 	uid:`$"." sv -2#"." vs string x`uid;
 	select uid,pid,pTime:.z.P,nrestart:1 from (.bt.action[`.pm.init] (`cmd`debug`print`proc!`start,00b,uid),`folder`env`subsys#.proc)`result
 	}@'a;
 .daemon.con:cols[.daemon.con]# update restart:restart + 0^nrestart from (.daemon.con) lj 1!r;
 }

/



berror

.tick.replay.logFiles