

/ admin.q:localhost:8888::
/ 
 * Start the whole plant
 * check all processes are up
 * check that all the admin tables have been populated
 * heartbeat
 * beforeExecution
 * afterExecution
 * error
\

.test.sleep 1;

r:.bt.action[`.pm.init] (`folder`env`subsys`proc`cmd`debug`print!(`testPlant```all`status,10b) ), (``env#.test.env); 

.test.sleep 10; /give processes time to come up

result:update hdl:{@[hopen;x;0ni] }@'hp from select uid,hp:{enlist[;2000] `$ .bt.print[":localhost:%0::"] enlist x }@'port,pid from r`result

result:update hdl:{@[hopen;x;0ni] }@'hp from result where null hdl;

.test.add[`admin;"All processes are up"] not any null result`pid;
.test.add[`admin;"All processes are connectable"] not any null result`hdl;

/ raze exec {`uid xcols update uid:x from y "select from .bt.history where not null error"}'[uid;hdl] from deepData where not null hdl

hdls:exec uid!hdl from result;

.test.sleep 5; /sleep for 5 secs to collect heartbeat 

.test.add[`admin;"All tables are created"] min `afterExecution`beforeExecution`berror`heartbeat`info`tblcnt in hdls[ `admin.rdb.0] "tables[]";

.test.sleep 5;

.test.add[`admin;"Heartbeats are created"] 0 < hdls[ `admin.rdb.0] (count get@;`heartbeat);

.test.sleep 10;

.test.add[`admin;"Heartbeats are published by all process"] count[result] = hdls[ `admin.rdb.0] ({count select by uid from heartbeat};());

cnt:2*count (exec hdl from result where `usage.client in/: library)@\:"1+1";

@[;"1+`a";()]@'(exec hdl from result where `usage.client in/: library);

.test.sleep 5;

.test.add[`admin;"beforeExecution is working"] cnt = count hdls[ `admin.rdb.0] "beforeExecution";

.test.add[`admin;"afterExecution is working"] cnt = count hdls[ `admin.rdb.0] "afterExecution";

.test.sleep 5;

.test.add[`admin;"usage is working"] cnt = count hdls[ `admin.rdb.0] "usage";

/ test error
/ test beforeExecution
/ test afterExecution

hdls[ `admin.tick.0] "\\t 0"; / stop admin tickerplant

hdls[ `admin.tick.0] "delete from `.bt.repository where mode=`delay,sym = `.tick.stream.eod";
hdls[ `admin.tick.0] "delete from `.bt.behaviours where sym = `.tick.stream.eod, trigger = `.tick.stream.eod";

hdls[ `admin.tick.0] "delete from `.bt.repository where mode=`delay,sym = `.tick.stream.cLogFile";

hdls[ `admin.tick.0] "delete from `.bt.behaviours where sym = `.tick.stream.cLogFile, trigger = `.tick.stream.cLogFile";

.test.sleep 1;

hdls[ `admin.tick.0] (".bt.action";`.tick.stream.cLogFile;()!());

.test.sleep 5;

hdls[ `admin.tick.0] (".bt.action";`.tick.stream.eod;()!());

.test.sleep 10;

.test.add[`admin;"heartbeat in hdb"] 0<count hdls[ `admin.cdb.0] "select from heartbeat";

.test.add[`admin;"berror in hdb"] 0=count hdls[ `admin.cdb.0] "select from berror";

.test.add[`admin;"afterExecution in hdb"] 0<count hdls[ `admin.cdb.0] "select from afterExecution";

.test.add[`admin;"beforeExecution in hdb"] 0<count  hdls[ `admin.cdb.0] "select from beforeExecution";

.test.add[`admin;"beforeExecution has been truncated"] 0 = count hdls[ `admin.rdb.0] "beforeExecution";

.test.add[`admin;"afterExecution has been truncated"] 0 = count hdls[ `admin.rdb.0] "afterExecution";

