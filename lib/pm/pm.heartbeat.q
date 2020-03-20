/ pm.heartbeat.q:localhost:8877::

.bt.scheduleIn[.bt.action[`.pm.heartbeat.init];;00:00:01] enlist .env.arg;

.bt.add[`.pm.heartbeat.init;`.pm.heartbeat.parse.cfg]{
 .pm.heartbeat.heartbeatTime:(.env.result`uid)!count[.env.result]#0nt;	
 adminCtp:first update hp:`$.bt.print[":%host%:%port%"]@'r from r:select uid,`$host,port from .sys where subsys = `admin, process = `ctp;
 .env.loadBehaviour `hopen;
 .pm.heartbeat.adminCtp:@[;`hdl;:;0n] adminCtp;
 .pm.heartbeat.counter:0;
 .bt.action[`.hopen.add] `uid`host`port#.pm.heartbeat.adminCtp;
 }

.bt.addIff[`.pm.heartbeat.pc]{[zw] zw=.pm.heartbeat.adminCtp.hdl }
.bt.add[`.hopen.pc;`.pm.heartbeat.pc]{[zw]	
 .pm.heartbeat.adminCtp.hdl:0ni;
 .pm.heartbeat.heartbeatTime:(.env.result`uid)!count[.env.result]#0nt;	
 }

.bt.addIff[`.pm.heartbeat.success]{[result] .pm.heartbeat.adminCtp.uid in result`uid }
.bt.add[`.hopen.success;`.pm.heartbeat.success]{[result] 
 .pm.heartbeat.adminCtp.hdl:hdl:first exec hdl from result where uid = .pm.heartbeat.adminCtp.uid;
 hdl (".u.sub";`heartbeat;`);
 }

.bt.addDelay[`.pm.heartbeat.loop]{`tipe`time!(`in;`second$1)}
.bt.add[`.pm.heartbeat.parse.cfg`.pm.heartbeat.loop;`.pm.heartbeat.loop]{
 1"\n";
 1(10b!("not_connected";"connected")) null .pm.heartbeat.adminCtp.hdl;	
 1"\n";
 .pm.heartbeat.counter:(.pm.heartbeat.counter + 1) mod 4; 
 show {([]beat:@[````;;:;`$"*"]@'(.pm.heartbeat.counter + til count x) mod 4 ;uid:key x;time:?[00:00:03>.z.T - value x;0nt;.z.T - value x ];heartbeat:?[00:00:03>.z.T - value x ;`;`$"no heartbeat"] )} .env.result.uid#.pm.heartbeat.heartbeatTime	
 }

upd:{[tname;data]
 .pm.heartbeat.heartbeatTime ,: exec uid!time from select time:"t"$max time by uid from data where uid in .env.result`uid;
 }

