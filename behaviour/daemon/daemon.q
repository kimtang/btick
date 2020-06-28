
/ daemon will restart all process

.bt.add[`.library.init;`.daemon.init]{[allData]
 .daemon.con:select folder,env,subsys,process,id from .sys where (not `daemon in/:library ) , subsys = .proc.subsys;
 .daemon.arg:(`folder`env`subsys`proc`debug`print`cmd!(`plant;`ex1;`;`all;1b;1b;`status)),(key[.env.arg] inter `folder`env`subsys)# .env.arg;


 }



/
select id,fnc,arg[;0] from .bt.tme