/ backfill.q:localhost:8888::

/ 
 * Start the whole plant
 * check all processes are up
 * check that all the backfill tables have been populated
 * create a schedule
 * publish data
 * acceptschedule
 * runSchedule
\

.test.sleep 10;

r:.bt.action[`.pm.init] (`folder`env`subsys`proc`cmd`debug`print!(`testPlant```all`status,10b) ), (``cfg#.test.env); 

.test.sleep 20; /give processes time to come up

result:update hdl:{@[hopen;x;0ni] }@'hp from select uid,hp:{enlist[;2000] `$ .bt.print[":localhost:%0::"] enlist x }@'port,pid from r`result;

.test.add[`bus1;"All processes are available in 2 secs"] not any null result`hdl; 

result:update library:{x ".proc.library"}@'hdl from result;

/ raze exec {`uid xcols update uid:x from y "select from .bt.history where not null error"}'[uid;hdl] from deepData where not null hdl

.test.add[`bus;"Bus available in client"]  not max null exec hdl@\:".bus.hdl" from 
select uid,hdl from result where `bus.client in\:library
;

hdls:exec uid!hdl from result;

schedule:hdls[`backfill.rdb.0] enlist[".bt.action";`.backfill.createSchedule;] `subsys`tname!`admin`heartbeat;

.test.sleep 10; /give time to create schdedule

.test.add[`backfill;"Schedule created"] not null schedule`uid;

.test.add[`backfill;"Table in rdb populated"] `heartbeat in hdls[`backfill.rdb.0] "tables[]";

.test.add[`backfill;"Table in tick populated"] 0<count hdls[`backfill.tick.0] ".backfill.con";

heartbeat:update date:date - 1  from hdls[`admin.rdb.0] "heartbeat";

hdls[`backfill.tick.0] ("upd";schedule`uid;heartbeat);

.test.add[`backfill;"Data in backfill rdb"] count[heartbeat]=hdls[`backfill.rdb.0] "count heartbeat";

hdls[`backfill.rdb.0] (".bt.action";`.backfill.acceptSchedule;``uid#schedule);

.test.sleep 5;

backfillcon:hdls[`backfill.rdb.0] ({first select from .backfill.con where uid = x};schedule`uid);

.test.add[`backfill;"Schdule accepted"]  `scheduleAccepted = backfillcon`status;

hdls[`backfill.rdb.0] (".bt.action";`.backfill.runSchedule;``uid#schedule);

.test.sleep 5;

backfillcon:hdls[`backfill.rdb.0] ({first select from .backfill.con where uid = x};schedule`uid);

.test.add[`backfill;"Schdule ran"]  `runSchedule = backfillcon`status;

/ hdls[`admin.cdb.0] (".bt.action";`.tick.loadHdb;()!())

.test.add[`backfill;"table in cdb"] `heartbeat in hdls[`admin.cdb.0] "tables[]";

/ 


