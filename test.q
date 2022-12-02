/ test.q:localhost:8888::


/ 
 q test.q -interactive 1 -folder folder -cfg cfg [show] all
 q test.q -interactive 1 -folder testPlant -cfg deepData show all
 q test.q
\

\l qlib.q

\c 1000 1000

.import.module`action`behaviour;
.behaviour.module`pm`test;

.bt.addCatch[`]{[error] .bt.stdOut0[`error;`test] .bt.print["Please investigate the following error: %0"] enlist error;'error}

.env.arg:
 .util.arg
 .util.posArg0[`cmd;`;`noCmd]
 .util.posArg0[`proc;`;`noProc]
 .util.optArg0[`btsrc;`;`$getenv`BTSRC]  
 .util.optArg0[`folder;`;`$"plant"] 
 .util.optArg0[`cfg;`;`] 
 .util.optArg0[`subsys;`;`]
 .util.optArg0[`trace;"J";0]
 .util.optArg0[`debug;"B";0b]
 .z.x;

.bt.action[`.test.init] .env.arg;


/


.env.arg:.Q.def[`folder`testFile`mode`debug`interactive`trace!`test``,00b,0] .Q.opt .z.x

if[not .env.arg`debug;.bt.outputTrace:.bt.outputTrace1];

{@[system;;()] .bt.print["l %btsrc%/lib/%lib%/%lib%.q"] .env , enlist[`lib]!enlist x}@'.env.libs;
{@[system;;()] .bt.print["l %btsrc%/behaviour/%behaviour%/%behaviour%.q"] .env , enlist[`behaviour]!enlist x}@'.env.behaviours;

.pm.parseFolder:first .bt.repository[enlist `.pm.parseFolder`behaviour]`fnc
.pm.parseEnv:first .bt.repository[enlist `.pm.parseEnv`behaviour]`fnc




.z.exit:{
 if[not `ex in key `.env;:()];
 .bt.action[`.pm.init] .env.ex,.bt.md[`cmd] `stop;	
 }


.bt.action[`.test.init] .env.arg;




/


select from .bt.history







