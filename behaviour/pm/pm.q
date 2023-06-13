/ pm.q:localhost:9088::


/ 
 q pm.q -folder folder -cfg cfg_file -library library -trace 1 [status|start|kill|stop|restart|debug|sbl|json|info|heartbeat|tblcnt] proc[all]
 q pm.q -folder  plant -cfg cfg_file -library library -trace 1 status proc[all]
 q pm.q -folder  plant -cfg cfg_file -library library -trace 1 status proc[all] 
 q pm.q -folder  plant -cfg cfg_file -subsys subsys -library library -trace 1 status all  
 q pm.q
\

d) module
 pm
 pm stands short for process management. It provides several functions to start/stop kdb processes. 
 q).behaviour.module`pm


.bt.addIff[`.pm.parseFolder]{[cfg] null cfg}
.bt.add[`.pm.init;`.pm.parseFolder]{[allData]
 t:([]root:enlist `$.bt.print[":%folder%"] allData); 
 t:update sroot:`${1_string x}@'root from t;
 t:ungroup update file:key@'root from t;
 t:select from t where max file like/:("*.json";"*.yml"); 
 t:update cfg:`${first "." vs string x}@'file from t;
 t:update cmd:.bt.print["q pm.q -folder %sroot% -cfg %cfg% status all"]@'t from t;
 enlist[`result]!enlist t 
 }

.bt.add[`.pm.parseFolder;`.pm.showFolder]{[allData;result]
 1 .bt.print["The folder %folder% contains %num% plant(s).\nUse the following commands to inspect the processes.\n" ] allData,enlist[`num]!enlist count result;
 {1 .bt.print["%cmd%\n"] x}@'result;
 } 

.bt.addIff[`.pm.parseEnv]{[cfg] not null cfg}
.bt.add[`.pm.init;`.pm.parseEnv] {[allData] 
 .sys:result:update pwd:.util.pwd[] from .action.parseCfg allData;
 .bt.md[`result] result
 } 

.bt.addIff[`.pm.os.json]{[cmd] cmd = `json}
.bt.add[`.pm.parseEnv;`.pm.os.json]{[result]
 result:select uid,folder,cfg,subsys,proc,port from result;
 1 .j.j update host:.z.h from result;
 .bt.md[`result] result 
 } 

.bt.addIff[`.pm.linux.addPid]{[cmd] .util.isLin and not cmd=`json }
.bt.add[`.pm.parseEnv;`.pm.linux.addPid]{[result;allData]
 result:update cmd:{.bt.print["q %btsrc%/action.q -folder %pwd%/%folder% -cfg %cfg% -subsys %subsys% -process %process% -id %id% -trace %trace%"] .env.arg,.env,x}@'result from result;
 result:update startcmd:.bt.print["nohup %cmd% >nohup.out 2>&1 &"]@'result from result;
 pids:.pm2.getLinStatus[];
 pids:update args:{raze raze value `cfg`subsys`process`id #(`cfg`subsys`process`id!4#""),  .Q.opt " " vs x}@'cmd from pids;
 result:update args:{raze raze value `cfg`subsys`process`id #(`cfg`subsys`process`id!4#""), .Q.opt " " vs x}@'cmd from result; 
 result:result lj 1!select args,pid from pids;
 // result:result lj 1!select cmd,pid from .pm2.getLinStatus[];
 result:select from result where (proc in allData`proc) or `all=allData`proc,(subsys in allData`subsys) or null allData`subsys;  
 result:update pm2:.bt.print["q pm.q -folder %folder% -cfg %cfg% -subsys %subsys% status %proc%"]@'result from result; 
 .bt.md[`result] result  
 }

.pm2.getLinStatus:{[x;y]
 tbl:system "ps -e -o %p -o ,%C, -o %mem -o ,%a";
 update name:{first " "vs x}@'cmd from `pid`cpu`mem`cmd xcol( "JFF*";", ") 0: tbl
 }

.pm2.getWinStatus:{[result;allData]
  lines: system .bt.print["pwsh --command \"%0\""] enlist"Get-Process -Name q* | select Id,CommandLine | ConvertTo-Csv -NoTypeInformation"; 
  tbl:`id`cmd xcol ("I*";", ") 0: lines;
  result:update args:{raze raze value `cfg`subsys`process`id #(`cfg`subsys`process`id!4#""), .Q.opt " " vs x}@'cmd from result;
  result:result lj 1!select args:{ raze raze value `cfg`subsys`process`id #(`cfg`subsys`process`id!4#""),  .Q.opt " " vs last "action.q" vs x }@'cmd,pid:id from tbl;
  result
 }

.pm2.getWinStatusOld:{[result;allData]
  tbl:system "tasklist /V /FI \"IMAGENAME eq q.exe\" /FO CSV";
  tbl:`name`pid`mem`cputime`cmd xcol( "*J  *  **";", ") 0: tbl;
  pmFile:`$.bt.print[":%folder%/%cfg%/pm"] allData;
  pms:(0#`)!0#0ni;
  if[not ()~key pmFile;pms:get pmFile];
  pms:{value[x]!key x} pms;
  pids:update cmd: {.bt.print["-cfg %cfg% -subsys %subsys% -process %process% -id %id%"] `cfg`subsys`process`id!"."vs x}@'string pms pid from tbl where pid in key pms;
  pids:update args:{raze raze value `cfg`subsys`process`id #(`cfg`subsys`process`id!4#""),  .Q.opt " " vs x}@'cmd from pids;
  result:update args:{raze raze value `cfg`subsys`process`id #(`cfg`subsys`process`id!4#""), .Q.opt " " vs x}@'cmd from result; 
  result:result lj 1!select args,pid from pids;
  result
 }

.pm2.getOsStatus:$[.util.isWin;.pm2.getWinStatus;.pm2.getLinStatus]
.pm2.killstr:$[.util.isWin;"taskkill /F /PID %pid%";"kill -9 %pid%"]


/ .bt.putAction `.pm.win.addPid
/ .bt.putAction `.pm.win.addPid

.bt.addIff[`.pm.win.addPid]{[cmd] .util.isWin and not cmd=`json }
.bt.add[`.pm.parseEnv;`.pm.win.addPid]{[result;allData]
 result:update cmd:{.bt.print["q %btsrc%/action.q -folder %folder% -cfg %cfg% -subsys %subsys% -process %process% -id %id% -trace %trace%"] x,y}[allData]@'result from result;
 result:update startcmd:.bt.print["start \"%cmd%\" %cmd%"]@'result from result;
 result:.pm2.getWinStatus[result] allData;
 / pids:update args:{raze raze value `cfg`subsys`process`id #(`cfg`subsys`process`id!4#""),  .Q.opt " " vs x}@'cmd from pids;
 / result:update args:{raze raze value `cfg`subsys`process`id #(`cfg`subsys`process`id!4#""), .Q.opt " " vs x}@'cmd from result; 
 / result:result lj 1!select args,pid from pids;
 result:select from result where (proc in allData`proc) or `all=allData`proc,(subsys in allData`subsys) or null allData`subsys,(library {any x in y}\: allData`library) or null allData`library;  
 result:update pm2:.bt.print["q pm.q -folder %folder% -cfg %cfg% -subsys %subsys% status %proc%"]@'result from result; 
 / result:select from result where .z.h = `$host;
 .bt.md[`result] result  
 }

.bt.addIff[`.pm.os.no_cmd]{[cmd] not cmd in `status`start`kill`stop`restart`debug`sbl`json`status`heartbeat`info`tblcnt`sblh`statusAll }
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.no_cmd]{[result;allData]
 result:select from result where .z.h = `$host;	
 result:select subsys,proc,port,pid,pm2 from result;	
 1 .Q.s .bt.print["cmd: %cmd% not implemented"] allData;
 .bt.md[`result] result 
 }


.bt.addIff[`.pm.os.status]{[cmd] cmd = `status}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.status]{[result]
 result:select from result where .z.h = `$host;
 result:select subsys,proc,uid,port,pid,pm2 from result;
 .bt.md[`result] result 
 }

.bt.addIff[`.pm.os.statusAll]{[cmd] cmd = `statusAll}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.statusAll]{[result]
 result:select from result where .z.h = `$host;
 .bt.md[`result] result 
 } 

.bt.addIff[`.pm.os.start]{[cmd] cmd = `start}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.start]{[result;allData]
 result:select from result where .z.h = `$host;
 {@[system;x;()]}@'exec startcmd from result where null pid;
 .util.sleep 4;
 result:.pm2.getWinStatus[result] allData;
 result:select subsys,proc,port,pid,pm2 from result;
 .bt.md[`result] result
 }

.bt.addIff[`.pm.os.kill]{[cmd] cmd in `kill`stop}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.kill]{[result;allData]
 result:select from result where .z.h = `$host;
 {@[system ;x;()]}@'.bt.print[.pm2.killstr] @'select from result where not null pid;
 result:update pid:0nj from result;
 result:.pm2.getWinStatus[result] allData;
 result:select subsys,proc,port,pid,pm2 from result;
 .bt.md[`result] result
 }

.bt.addIff[`.pm.os.restart]{[cmd] cmd = `restart}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.restart]{[result;allData]
 result:select from result where .z.h = `$host;
 {@[system ;x;()]}@'.bt.print[.pm2.killstr] @'select from result where not null pid;
 {@[system;x;()]}@'exec startcmd from result where null pid;
 result:.pm2.getWinStatus[result] allData;
 result:select subsys,proc,port,pid,pm2 from result;
 .bt.md[`result] result
 }  

.bt.addIff[`.pm.os.debug]{[cmd;result] cmd = `debug}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.debug]{[result;allData]
 if[not 1=count result;1 "Only one process is allowed in debug mode";:()];
 result:result 0;
 if[not null result`pid;{@[system ;x;()]} .bt.print[.pm2.killstr] result];
 .env.arg:@[;`cmd;:;`start]allData;
 .env.arg:@[;`process;:;first` vs .env.arg`proc] .env.arg;
 .env.arg:@[;`id;:;"J"$string last` vs .env.arg`proc] .env.arg;
 .bt.history:1#.bt.history;
 .bt.seq:0;
 delete from `.bt.repository where sym in `.pm.exit`.pm.show;
 delete from `.bt.behaviours where (sym in `.pm.exit`.pm.show) or trigger in `.pm.exit`.pm.show;
 .behaviour.module`action;
 .bt.action[`.action.init] .env.arg; 
 }

.bt.addIff[`.pm.os.heartbeat]{[cmd;result] cmd = `heartbeat}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.heartbeat]{[result;allData]
 .env.result:result;
 .behaviour.require `pm.heartbeat;
 .bt.scheduleIn[.bt.action[`.pm.heartbeat.init];;00:00:01] enlist allData;
 / system .bt.print["l %btsrc%/behaviour/pm/pm.heartbeat.q"] .env;
 } 

.bt.addIff[`.pm.os.info]{[cmd;result] cmd = `info}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.info]{[result]
 .env.result:result;
 system .bt.print["l %btsrc%/behaviour/pm/pm.info.q"] .env;
 }

.bt.addIff[`.pm.os.tblcnt]{[cmd;result] cmd = `tblcnt}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.tblcnt]{[result]
 .env.result:result;
 system .bt.print["l %btsrc%/behaviour/pm/pm.tblcnt.q"] .env;
 }  

.bt.addIff[`.pm.os.sbl]{[cmd;result] cmd = `sbl}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.sbl]{[result]
 1 "We will create cfg/system.sbl";
 `:cfg/system.sbl 0: .bt.print["/ %uid%:%host%:%port%::"] @'select uid:.Q.dd'[env;flip (subsys;process;id)],host:`localhost,port from result where not null port
 } 

.bt.addIff[`.pm.os.sblh]{[cmd;result] cmd = `sblh}
.bt.add[`.pm.win.addPid`.pm.linux.addPid;`.pm.os.sblh]{[result]
 1 "We will create cfg/system.sbl";
 `:cfg/system.sbl 0: .bt.print["/ %uid%:%host%:%port%::"] @'select uid:.Q.dd'[env;flip (subsys;process;id)],host:`localhost,port from result where not null port
 }  
