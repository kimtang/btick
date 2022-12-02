
d) module
 action
 This behaviour is used to initialise all processes from pm. 
 q).behaviour.module`action

.import.require`action`util`tick`behaviour;

.bt.add[`.action.init;`.action.parse.cfg]{[allData]
 .sys:t:.action.parseCfg allData;
 .bt.md[`result] select from t where subsys=allData`subsys,process=allData`process,id=allData`id
 }

.bt.addIff[`.action.set.cfg]{[result] 1=count result}
.bt.add[`.action.parse.cfg;`.action.set.cfg]{[result]
 .proc:result 0;
 .proc.za:.Q.host .z.a;
 .behaviour.module@' .proc.library;
 .proc
 }

.bt.add[`.action.set.cfg;`.action.parse.schema]{[allData]
 .schemas.core:`$.bt.print[":%btsrc%/core/core/schemas"] allData;
 .schemas.plant:`$.bt.print[":%folder%/%env%/schemas"] .proc;
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

.bt.addIff[`.action.set.win.os]{.util.isWin}
.bt.add[`.action.parse.schema;`.action.set.win.os]{
 .proc.cwd:system "cd";
 .proc.del:"\\";
 }

.bt.addIff[`.action.set.lin.os]{.util.isLin}
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
 .proc.pfile
 }


.bt.add[`.action.load.file;`.library.init]{.proc`mergeArg}

.bt.add[`.library.init;`.action.load.qlib]{ .import.module@'.proc[`qlib] except `;}