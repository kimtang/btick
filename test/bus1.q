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

.test.add[`bus;"Bus available in client"] not max null exec hdl@\:".bus.hdl" from select  from result where `bus.client in/:library

