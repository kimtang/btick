/ pm.error.q:localhost:8877::

.bt.scheduleIn[.bt.action[`.pm.error.init];;00:00:01] enlist .env.arg;

.bt.add[`.pm.error.init;`.pm.error.parse.cfg]{
 adminCtp:first update hp:`$.bt.print[":%host%:%port%"]@'r from r:select uid,`$host,port from .sys where subsys = `admin, process = `ctp;
 .env.loadBehaviour `hopen;
 .pm.error.adminCtp:@[;`hdl;:;0n] adminCtp;
 .pm.error.counter:0;
 .bt.action[`.hopen.add] `uid`host`port#.pm.error.adminCtp;
 }

.bt.addIff[`.pm.error.pc]{[zw] zw=.pm.error.adminCtp.hdl }
.bt.add[`.hopen.pc;`.pm.error.pc]{[zw] .pm.error.adminCtp.hdl:0ni;}


.bt.addIff[`.pm.error.success]{[result] .pm.error.adminCtp.uid in result`uid }
.bt.add[`.hopen.success;`.pm.error.success]{[result] 
 .pm.error.adminCtp.hdl:first exec hdl from result where uid = .pm.error.adminCtp.uid;
 {x set y} . .pm.error.adminCtp.hdl (".u.sub";`error;`);
 {x set y} . .pm.error.adminCtp.hdl (".u.sub";`berror;`);
 }

.bt.addDelay[`.pm.error.loop]{`tipe`time!(`in;`second$1)}

.bt.add[`.pm.error.parse.cfg`.pm.error.loop;`.pm.error.loop]{
 1"\n";
 1(10b!("not_connected";"connected")) null .pm.error.adminCtp.hdl;
 1"\n";
 .pm.error.counter:(.pm.error.counter + 1) mod 4;
 str:@["     %error% (error) %berror% (berror)";;:;"*"] .pm.error.counter;
 1 .bt.print[str] `error`berror!@[{count get x};;0ni]@'`error`berror
 }

upd:{[tname;data]tname insert data}

/

select from .bt.history where not null error