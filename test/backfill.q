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

r:.bt.action[`.pm.init] (`folder`env`subsys`proc`cmd`debug`print!(`testPlant```all`status,10b) ), (``env#.test.env); 

.test.sleep 20; /give processes time to come up

result:update hdl:{@[hopen;x;0ni] }@'hp from select uid:.Q.dd'[subsys;flip (process;id)],hp:{enlist[;2000] `$ .bt.print[":localhost:%0::"] enlist x }@'port,pid,library from r`result;

result:update hdl:{@[hopen;x;0ni] }@'hp from result where null hdl;

.test.add[`backfill;"All processes are up"] not any null result`pid;
.test.add[`backfill;"All processes are connectable"] not any null result`hdl;

/ raze exec {`uid xcols update uid:x from y "select from .bt.history where not null error"}'[uid;hdl] from deepData where not null hdl

.test.add[`backfill;"Bus available"]  not max null exec hdl@\:".bus.hdl" from select uid,hdl from result where not uid like "*bus*";

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


