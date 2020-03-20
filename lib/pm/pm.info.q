/ pm.error.q:localhost:8877::

.bt.scheduleIn[.bt.action[`.pm.info.init];;00:00:01] enlist .env.arg;

.bt.add[`.pm.info.init;`.pm.info.parse.cfg]{
 adminCtp:first update hp:`$.bt.print[":%host%:%port%"]@'r from r:select uid,`$host,port from .sys where subsys = `admin, process = `ctp;
 .env.loadBehaviour `hopen;
 .pm.info.adminCtp:@[;`hdl;:;0n] adminCtp;
 .pm.info.counter:0;
 .bt.action[`.hopen.add] `uid`host`port#.pm.info.adminCtp;
 }

.bt.addIff[`.pm.info.pc]{[zw] zw=.pm.info.adminCtp.hdl }
.bt.add[`.hopen.pc;`.pm.info.pc]{[zw] .pm.info.adminCtp.hdl:0ni;}


.bt.addIff[`.pm.info.success]{[result] .pm.info.adminCtp.uid in result`uid }
.bt.add[`.hopen.success;`.pm.info.success]{[result] 
 .pm.info.adminCtp.hdl:first exec hdl from result where uid = .pm.info.adminCtp.uid;
 {x set y} . .pm.info.adminCtp.hdl (".u.sub";`info;`);
 {x set y} . .pm.info.adminCtp.hdl (".u.sub";`berror;`);
 }

.bt.addDelay[`.pm.info.loop]{`tipe`time!(`in;`second$1)}

.bt.add[`.pm.info.parse.cfg`.pm.info.loop;`.pm.info.loop]{
 1"\n";
 1(10b!("not_connected";"connected")) null .pm.info.adminCtp.hdl;
 1"\n";
 .pm.info.counter:(.pm.info.counter + 1) mod 4;
 str:@["     %error% (error) %berror% (berror)";;:;"*"] .pm.info.counter;
 1 .bt.print[str] `error`berror!@[{count get x};;0ni]@'`info`berror
 }

upd0:(enlist`)!(enlist {})

upd0[`berror]:{[tname;data]tname insert data}
upd0[`info]:{[tname;data]tname insert select from data where not null error}

upd:{[tname;data] upd0[tname][tname] data}

/

select from .bt.history where not null error