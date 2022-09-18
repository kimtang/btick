/ pm.q:localhost:32002::
/ pm.q:localhost:8888::
/ pm.q:localhost:9876::

args:.Q.def[`name`port!("pm1";8888);].Q.opt .z.x

/ remove this line when using in production
/ pm1:localhost:8888::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 8888"; } @[hopen;`:localhost:8888;0];
/ 
 q pm1.q -folder folder -cfg cfg_file -subsys subsys -trace 1 [status|start|kill|stop|restart|debug|sbl|json|info|heartbeat|tblcnt] proc[all]
 q pm1.q -folder plant  -cfg cfg_file -subsys subsys -trace 1 status proc[all]
 q pm1.q -folder plant  -cfg cfg_file -subsys subsys -trace 1 status proc[all] 
 q pm1.q -folder plant  -cfg cfg_file -subsys subsys -trace 1 status all  
 q pm1.q
\

\l qlib.q

\c 1000 1000

.import.module`action`behaviour;
.behaviour.module`pm;

.bt.addCatch[`]{[error] .bt.stdOut0[`error;`pm] .bt.print["Please investigate the following error: %0"] enlist error;'error};
.bt.add[`.pm.os.status`.pm.os.start`.pm.os.kill`.pm.os.restart;`.pm.show]{[result]
  1 .Q.s update `$pm2 from `port xasc result
  };

.bt.addIff[`.pm.exit]{[debug] not debug};
.bt.add[`.pm.showFolder`.pm.show`.pm.os.sbl`.pm.os.sblh`.pm.os.json`.pm.os.no_cmd;`.pm.exit]{exit 0};

.env.arg:
  .util.arg
  .util.posArg0[`cmd;`;`noCmd]
  .util.posArg0[`proc;`;`noProc]
  .util.optArg0[`btsrc;`;`$getenv`BTSRC]  
  .util.optArg0[`folder;`;`$getenv[`BTSRC],"/plant"] 
  .util.optArg0[`cfg;`;`] 
  .util.optArg0[`subsys;`;`]
  .util.optArg0[`trace;"J";0]
  ("-folder";"plant";"-cfg";"ex1";"-subsys";"admin";"debug";"bus.0");

.bt.action[`.pm.init] .env.arg;

/

allData:.env.arg

select from .bt.history where mode =`behaviour
select from .bt.history where not null error

.bt.putArg 58j



result