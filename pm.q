/ pm.q:localhost:8888::
/ pm.q:ktang-virtualbox:8888::


/ 
 q pm.q -folder folder -env env [status|start|kill|stop|restart|debug|sbl] proc[all]
 q pm.q -folder plant -env pm status proc[all]
 q pm.q -folder plant -env pm_example -subsys subsys status all  
 q pm.q
\

.env.win:"w"=first string .z.o;
.env.lin:not .env.win;
.env.btsrc:getenv`BTSRC

if[""~getenv`BTSRC;
 0N!"Please define the missing variable BTSRC to point to the btick3 implementation";
 exit 0;
 ];


if[ not`bt in key `;system "l ",.env.btsrc,"/bt.q"];

\c 1000 1000

.bt.addCatch[`]{[error] .bt.stdOut0[`error;`pm] .bt.print["Please investigate the following error: %0"] enlist error;'error}


.env.libs:1#`util
.env.behaviours:0#`
.env.arg:.Q.def[`folder`env`subsys`proc`debug!`plant```all,0b] .Q.opt { rest:-2#("status";"all"),rest:x (til count x)except  w:raze 0 1 +/:where "-"=first each x;(x w),(("-cmd";"-proc"),rest) 0 2 1 3 } .z.x


if[not .env.arg`debug;.bt.outputTrace:.bt.outputTrace1];


{@[system;;()] .bt.print["l %btsrc%/lib/%lib%/%lib%.q"] .env , enlist[`lib]!enlist x}@'.env.libs;
{@[system;;()] .bt.print["l %btsrc%/behaviour/%behaviour%/%behaviour%.q"] .env , enlist[`behaviour]!enlist x}@'.env.behaviours;

/ .bt.scheduleIn[.bt.action[`.pm.init];;00:00:01] enlist .env.arg;


.bt.addIff[`.pm.parseFolder]{[env] null env}
.bt.add[`.pm.init;`.pm.parseFolder]{[allData]
 t:([]root:enlist `$.bt.print[":%folder%"] allData); 
 t:update sroot:`${1_string x}@'root from t;
 t:ungroup update file:key@'root from t;
 t:select from t where file like "*.json"; 
 t:update env:{`$ -5_/:string x}@file from t;
 t:update cmd:.bt.print["q pm.q -folder %sroot% -env %env% status all"]@'t from t;
 enlist[`result]!enlist t 
 }

.bt.add[`.pm.parseFolder;`.pm.showFolder]{[allData;result]
 1 .bt.print["The folder %folder% contains %num% plant(s).\nUse the following commands to inspect the processes.\n" ] allData,enlist[`num]!enlist count result;
 {1 .bt.print["%cmd%\n"] x}@'result;
 } 

.pm2.calcPort:()!()
.pm2.calcPort[`setPort]:{[mergeArg;id] get .bt.print[$[10h=type mergeArg`setPort;::;string]mergeArg`setPort ] mergeArg   }
.pm2.calcPort[`dynamicPort]:{[mergeArg;id] id + get  .bt.print[$[10h=type mergeArg`dynamicPort;::;string]mergeArg`dynamicPort ] mergeArg }
.pm2.calcPort[`noPort]:{[mergeArg;id] 0nj}

.bt.addIff[`.pm.parseEnv]{[env] not null env}
.bt.add[`.pm.init;`.pm.parseEnv]{[allData]
 .cfg : .j.k "c"$read1 `$.bt.print[":%folder%/%env%.json"] .env,allData;
 .core: .j.k "c"$read1 `$ .bt.print["%btsrc%/core/core.json"] .env,.cfg.global;
 .cfg : .cfg,.util.deepMerge[.core].cfg;
 .global: .cfg.global;
 .cfg:delete global from .cfg;
 t:{[allData;x]  ([]folder:allData`folder;env:allData`env;subsys:key x;val:value x)}[allData] .cfg;
 t:update process:key @'val[;`process], library:{value[x]@\:`library}@'val[;`process], arg:{value[x]@\:`arg}@'val[;`process] from t;
 t:update global: {[ksubsys;subsys] (ksubsys _ .global), .global subsys   }[subsys] @'subsys from t;
 t:update global:process{count[x]#enlist y }'global from t;
 t:update local:{ {`library`arg _ x} each value x }@'val[;`process] from t;
 t:ungroup delete val from t;
 t:update instance:global{"j"$ (x,y)`instance }'local from t;
 t:raze {update id:til ins from (ins:x `instance)#enlist x}@'t;
 t:update library:{`$"," vs x}@'library from t; 
 t:update mergeArg:{[arg;global;local] .util.deepMerge[global] .util.deepMerge[local] arg }'[arg;global;local] from t; 
 t:update port:{[library;mergeArg;id] .pm2.calcPort[first `noPort ^ desc (k!k:key .pm2.calcPort) library] [mergeArg;id]}'[library;mergeArg;id] from t;
 t:update proc:.Q.dd'[process;id] from t;
 .bt.md[`result]t
 }

/ .bt.putAction `.pm.linux.addPid

.bt.addIff[`.pm.linux.addPid]{ .env.lin }
.bt.add[`.pm.parseEnv;`.pm.linux.addPid]{[result;allData]
 result:update cmd:{.bt.print["q %btsrc%/action.q -folder %folder% -env %env% -subsys %subsys% -process %process% -id %id% -p %port%"] .env,x}@'result from result;
 result:update startcmd:.bt.print["nohup %cmd% >nohup.out 2>&1 &"]@'result from result;
 result:result lj 1!select cmd,pid from .pm2.getLinStatus[];
 result:select from result where (proc in allData`proc) or `all=allData`proc,(subsys in allData`subsys) or null allData`subsys;  
 result:update pm2:.bt.print["q pm.q -folder %folder% -env %env% -subsys %subsys% status %proc%"]@'result from result; 
 .bt.md[`result] result  	
 }

.pm2.getLinStatus:{
 tbl:system "ps -e -o %p -o ,%C, -o %mem -o ,%a";
 update name:{first " "vs x}@'cmd from `pid`cpu`mem`cmd xcol( "JFF*";", ") 0: tbl
 }

.pm2.getWinStatus:{
  tbl:system "tasklist /V /FI \"IMAGENAME eq q.exe\" /FO CSV";
  `name`pid`mem`cputime`cmd xcol( "*J  *  **";", ") 0: tbl
 }

.pm2.getOsStatus:$[.env.win;.pm2.getWinStatus;.pm2.getLinStatus]
.pm2.killstr:$[.env.win;"taskkill /F /PID %pid%";"kill -9 %pid%"]




.bt.addIff[`.pm.win.addPid]{ .env.win }
.bt.add[`.pm.parseEnv;`.pm.win.addPid]{[result;allData]
 result:update cmd:{.bt.print["q %btsrc%/action.q -folder %folder% -env %env% -subsys %subsys% -process %process% -id %id%"] .env,x}@'result from result;
 result:update startcmd:.bt.print["start \"%cmd%\" /MIN %cmd%"]@'result from result;
 result:result lj 1!select cmd,pid from .pm2.getWinStatus[];
 result:select from result where (proc in allData`proc) or `all=allData`proc,(subsys in allData`subsys) or null allData`subsys;  
 result:update pm2:.bt.print["q pm.q -folder %folder% -env %env% -subsys %subsys% status %proc%"]@'result from result; 
 .bt.md[`result] result  
 }


.bt.addIff[`.pm.os.status]{[cmd] cmd = `status}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.status]{[result]
 result:select subsys,proc,port,pid,pm2 from result;
 1 .Q.s result
 }

.bt.addIff[`.pm.os.start]{[cmd] cmd = `start}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.start]{[result]
 {@[system;x;()]}@'exec startcmd from result where null pid;
 result:result lj 1!select cmd,pid from .pm2.getOsStatus [];
 result:select subsys,proc,port,pid,pm2 from result;
 1 .Q.s result  
 }

.bt.addIff[`.pm.os.kill]{[cmd] cmd in `kill`stop}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.kill]{[result]
 {@[system ;x;()]}@'.bt.print[.pm2.killstr] @'select from result where not null pid;
 result:update pid:0nj from result;
 result:result lj 1!select cmd,pid from .pm2.getOsStatus[];
 result:select subsys,proc,port,pid,pm2 from result;
 1 .Q.s result  
 }

.bt.addIff[`.pm.os.restart]{[cmd] cmd = `restart}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.restart]{[result]
 {@[system ;x;()]}@'.bt.print[.pm2.killstr] @'select from result where not null pid;
 {@[system;x;()]}@'exec startcmd from result where null pid;
 result:result lj 1!select cmd,pid from .pm2.getOsStatus[];
 result:select subsys,proc,port,pid,pm2 from result;
 1 .Q.s result  
 }  

.bt.addIff[`.pm.os.debug]{[cmd;result] cmd = `debug}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.debug]{[result]
 if[not 1=count result;1 "Only one process is allowed in debug mode";:()];
 result:result 0;
 if[not null result`pid;{@[system ;x;()]} .bt.print[.pm2.killstr] result];
 .env.arg:.Q.def[(1#`folder)!1#`plant] .Q.opt 2_" " vs result`cmd;
 system .bt.print["l %btsrc%/action.q"] .env
 }

.bt.addIff[`.pm.os.sbl]{[cmd;result] cmd = `sbl}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.sbl]{[result]
 1 "We will create system.sbl";
 `:../cfg/system.sbl 0: .bt.print["/ %uid%:%host%:%port%::"] @'select uid:.Q.dd'[env;flip (subsys;process;id)],host:`localhost,port from result where not null port} 

.bt.addIff[`.pm.exit]{[debug] not debug}
.bt.add[`.pm.showFolder`.pm.os.status`.pm.os.start`.pm.os.kill`.pm.os.restart`.pm.os.sbl;`.pm.exit]{exit 0 }


if[.z.f like "*pm.q";.bt.action[`.pm.init] .env.arg];



/



select from .bt.history where not null error

.bt.putAction `.pm.os.start