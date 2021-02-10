
if[ not`bt in key `;system "l ",getenv[`BTSRC],"/bt.q"];

if[ not`env in key `;
 .env.arg:.Q.def[(1#`folder)!1#`plant] .Q.opt .z.x;
 ];

.bt.outputTrace:.bt.outputTrace1

.bt.trace:(`notrace`trace!(.bt.trace0;.bt.trace2)) .env.arg`trace

.env.plantsrc:{x:`$"/"sv -1_"/"vs string x;$[null x;`.;x]}  .env.arg`folder

.env.loadLib:{{@[system;;()] .bt.print["l %btsrc%/lib/%lib%/%lib%.q"] .env , enlist[`lib]!enlist x}@'x};
.env.loadBehaviour:{{
 arg:.env , `behaviour`module! (first` vs x),x;
 files:.bt.md[`bfile] .bt.print["%btsrc%/behaviour/%behaviour%/%module%.q"]arg;
 files:files,.bt.md[`ofile] .bt.print["%plantsrc%/behaviour/%behaviour%/%module%.q"]arg;
 if[f~key f:`$.bt.print[":%ofile%"]files;:@[system;;()] .bt.print["l %ofile%"]files];
 if[f~key f:`$.bt.print[":%bfile%"]files;:@[system;;()] .bt.print["l %bfile%"]files];
 }@'x};


.env.btsrc:getenv`BTSRC;
.env.libs:`util`action`tick;
/ .env.yml2json:"yaml2json"
.env.behaviours:1#`pm;

.env.win:"w"=first string .z.o;
.env.lin:not .env.win;

.env.loadLib .env.libs;
.env.loadBehaviour .env.behaviours;

.bt.scheduleIn[.bt.action[`.action.init];;00:00:01] enlist .env.arg;

.bt.add[`.action.init;`.action.parse.cfg]{[allData]
 .sys:t:.action.parseCfg allData;
 .bt.md[`result] select from t where subsys=allData`subsys,process=allData`process,id="J"$string allData`id
 }

.bt.addIff[`.action.set.cfg]{[result] 1=count result}
.bt.add[`.action.parse.cfg;`.action.set.cfg]{[result]
 .proc:result 0;
 .proc.za:.Q.host .z.a;
 .env.loadBehaviour .proc.library;
 .proc
 }

/ .bt.putAction `.action.parse.schema

.bt.add[`.action.set.cfg;`.action.parse.schema]{[allData]
 .schemas.core:`$.bt.print[":%btsrc%/core/core/schemas"] .env,.global;
 .schemas.plant:`$.bt.print[":%folder%/%env%/schemas"] .env,.proc;
 t:([]plant:`core`plant; path: .schemas `core`plant );
 t:ungroup update subsys: key@'path from t;
 t:update path:path .Q.dd'subsys  from t;
 t:ungroup update file: key@'path from t;
 t:update path:path .Q.dd'file from t;
 t:select from t where file like "*.json";
 t:update src:{@[{"c"$read1 x};x;enlist""]}@'path from t;
 t:update json:.j.k@'src from t;
 t:(select subsys from t),'exec `tname`column`addTime`tipe`rattr`hattr`tick`rsubscriber`hsubscriber`upd`ocolumn#/:{(`ocolumn`upd`addTime`tick`rsubscriber`hsubscriber!("";"(::)"),0b,3#enlist"default"),x} @'json from t;
 t:update ocolumn:column from t where 0=count each ocolumn;
 t:update tname:`$tname,column:`${","vs x}@'column,tick:`${","vs x}@'tick,rsubscriber:`${","vs x}@'rsubscriber,hsubscriber:`${","vs x}@'hsubscriber,ocolumn:`${","vs x}@'ocolumn from t;
 t:update schema:column{enlist x!y$\:()}'tipe from t;
 t:update upd:get@'upd from t; 
 .schemas.con:t; 
 } 

.bt.addIff[`.action.set.win.os]{.env.win}
.bt.add[`.action.parse.schema;`.action.set.win.os]{
 .proc.cwd:system "cd";
 .proc.del:"\\";
 }

.bt.addIff[`.action.set.lin.os]{.env.lin}
.bt.add[`.action.parse.schema;`.action.set.lin.os]{
 .proc.cwd:system "pwd";
 .proc.del:"/";	
 }



/ execute this to init the libraries
.bt.add[`.action.set.lin.os`.action.set.win.os;`.action.load.file]{
 t:([]sym:`gfile`lfile`gcorefile`lcorefile;folder: {hsym `$x}@'.proc `gfile`lfile`gcorefile`lcorefile);
 t:ungroup update file:.util.getFiles@'folder from t;
 t:update file:.util.wlin@'1_/:string file from t;
 t:update name: { last .proc.del vs x}@'file from t; 
 t:update suffix: `${ {x 1}"." vs x}@'name from t;
 t:update cmd:{"l ",x }@'file from t;
 t:update error:{@[{system x;`};x;{`$x}] }@'cmd from t where suffix=`q;
 t:update error:{[name;file] .[{[name;file] name set get file;`};(`$name;hsym`$file);{`$x}] }'[name;file] from t where suffix=`;
 .proc.pfile:t;
 }


.bt.add[`.action.load.file;`.library.init]{.proc`mergeArg}

/

.bt.tme
select from .bt.history

.z.ts[]