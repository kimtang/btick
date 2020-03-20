/ pm.tblcnt.q:localhost:8877::

.bt.scheduleIn[.bt.action[`.pm.tblcnt.init];;00:00:01] enlist .env.arg;

.bt.add[`.pm.tblcnt.init;`.pm.tblcnt.parse.cfg]{
 .pm.tblcnt.tblcntTime:()!();	
 adminCtp:first update hp:`$.bt.print[":%host%:%port%"]@'r from r:select uid,`$host,port from .sys where subsys = `admin, process = `ctp;
 .env.loadBehaviour `hopen;
 .pm.tblcnt.adminCtp:@[;`hdl;:;0n] adminCtp;
 .pm.tblcnt.counter:0;
 .bt.action[`.hopen.add] `uid`host`port#.pm.tblcnt.adminCtp;
 }

.bt.addIff[`.pm.tblcnt.pc]{[zw] zw=.pm.tblcnt.adminCtp.hdl }
.bt.add[`.hopen.pc;`.pm.tblcnt.pc]{[zw]	
 .pm.tblcnt.adminCtp.hdl:0ni;
 .pm.tblcnt.tblcntTime:()!();	
 }

.bt.addIff[`.pm.tblcnt.success]{[result] .pm.tblcnt.adminCtp.uid in result`uid }
.bt.add[`.hopen.success;`.pm.tblcnt.success]{[result] 
 .pm.tblcnt.adminCtp.hdl:hdl:first exec hdl from result where uid = .pm.tblcnt.adminCtp.uid;
 hdl (".u.sub";`tblcnt;`);
 }

.bt.addDelay[`.pm.tblcnt.loop]{`tipe`time!(`in;`second$1)}
.bt.add[`.pm.tblcnt.parse.cfg`.pm.tblcnt.loop;`.pm.tblcnt.loop]{
 1"\n";
 1(10b!("not_connected";"connected")) null .pm.tblcnt.adminCtp.hdl;	
 1"\n";
 .pm.tblcnt.counter:(.pm.tblcnt.counter + 1) mod 4; 
 show {([]beat:@[````;;:;`$"*"]@'(.pm.tblcnt.counter + til count x) mod 4 ;tbl:key x;cnt:value x )} .pm.tblcnt.tblcntTime	
 }

upd:{[tname;data]
 .pm.tblcnt.tblcntTime +: exec tbl!cnt from select cnt:sum cnt by tbl from data;
 }

/

.u.t

.pm.tblcnt.adminCtp.hdl (".u.sub";`cnttbl;`)

select from .bt.history where not null error


