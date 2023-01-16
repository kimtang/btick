d) module
 action
 action provides a set of functions that help you to read the config file. 
 q).import.module`action


.action.calcPort:()!()
.action.calcPort[`setPort]:{[mergeArg;id] get .bt.print[$[10h=type mergeArg`setPort;::;string]mergeArg`setPort ] mergeArg   }
.action.calcPort[`dynamicPort]:{[mergeArg;id] id + get  .bt.print[$[10h=type mergeArg`dynamicPort;::;string]mergeArg`dynamicPort ] mergeArg }
.action.calcPort[`noPort]:{[mergeArg;id] 0nj}

.action.parseCfg:{[allData]
 allVar:.action.createVar[allData];
 .cfg:allVar`cfg;
 .global:allVar`global;
 .core:allVar`core;
 .action.parseCfg1[allVar;allData]
 }


d) function
 action
 .action.parseCfg
 return the parsed config file with side effect
 q) .action.parseCfg `btsrc`folder`cfg`subsys`process`id`trace!(`$getenv`btsrc;`pathTo/plant;`horseracing;`scrapeData;`dev;0j;0j)
 q) .action.parseCfg `btsrc`folder`cfg`subsys`process`id`trace!(`$getenv`btsrc;`$getenv[ `btsrc],"/plant";`ex1;`scrapeData;`dev;0j;0j)


.action.parseCfg0:{[allData]
 allVar:.action.createVar[allData];
 .action.parseCfg1[allVar;allData]
 }


d) function
 action
 .action.parseCfg0
 return the parsed config file without side effect
 q) .action.parseCfg0 `btsrc`folder`cfg`subsys`process`id`trace!(`$getenv`btsrc;`pathTo/plant;`horseracing;`scrapeData;`dev;0j;0j)
 q) .action.parseCfg0 `btsrc`folder`cfg`subsys`process`id`trace!(`$getenv`btsrc;`$getenv[ `btsrc],"/plant";`ex1;`scrapeData;`dev;0j;0j)

.action.parseCfg1:{[allVar;allData]
 t:{[allData;allVar]  ([]folder:allData`folder;env:first `$(allVar`global)`env;subsys:key allVar`cfg;val:value allVar`cfg)}[allData;allVar];
 t:update cfg:allData`cfg from t;
 t:update process:key @'val[;`process], library:{value[x]@\:`library}@'val[;`process], qlib:{{((.bt.md[`qlib] ""),x) `qlib}@'value x}@'val[;`process], arg:{value[x]@\:`arg}@'val[;`process] from t;
 t:update global: {[global;ksubsys;subsys] (ksubsys _ global), global subsys   }[allVar`global;subsys] @'subsys from t;
 t:update global:process{count[x]#enlist y }'global from t;
 t:update local:{ {`library`arg _ x} each value x }@'val[;`process] from t;
 t:ungroup delete val from t;
 t:update instance:global{"j"$ (x,y)`instance }'local from t;
 t:raze {update id:til ins from (ins:x `instance)#enlist x}@'t;
 t:update library:{`$"," vs x}@'library from t;
 t:update qlib:{`$"," vs x}@'qlib from t;
 t:update mergeArg:{[arg;global;local] .util.deepMerge[global] .util.deepMerge[local] arg }'[arg;global;local] from t;
 t:update host:{$[any (.z.h,`localhost) in `$x;string .z.h;x 0]}@'mergeArg[;`host],port:{[library;mergeArg;id] .action.calcPort[first `noPort ^ desc (k!k:key .action.calcPort) library] [mergeArg;id]}'[library;mergeArg;id] from t;
 t:update passwd:mergeArg[;`passwd] from t;
 / t:update host:{string .z.h}@'mergeArg[;`host],port:{[library;mergeArg;id] .action.calcPort[first `noPort ^ desc (k!k:key .action.calcPort) library] [mergeArg;id]}'[library;mergeArg;id] from t;
 t:update proc:.Q.dd'[process;id] from t;
 t:update uid:.Q.dd'[env;flip(subsys;process;id)] from t;
 param:allData,allVar`global;
 t:update hdb: {[param;x] .bt.print["%data%/%env%/%subsys%/hdb"] param,x}[param]@'t from t;
 t:update audit: {[param;x] .bt.print["%audit%/%env%/%subsys%/%process%/%id%"] param,x}[param]@'t from t;
 t:update gData: {[param;x] .bt.print["%data%/%env%/%subsys%/%process%"] param,x}[param]@'t from t;
 t:update data: {[param;x] .bt.print["%data%/%env%/%subsys%/%process%/%id%"] param,x}[param]@'t from t;
 t:update gfile: {[param;x] .bt.print["%folder%/%env%/%subsys%/%process%/global"] param,x}[param]@'t from t;
 t:update lfile: {[param;x] .bt.print["%folder%/%env%/%subsys%/%process%/%id%"] param,x}[param]@'t from t;
 t:update gcorefile: {[param;x] .util.wlin .bt.print["%btsrc%/core/core/%subsys%/%process%/global"] param,x}[param]@'t from t;
 t:update lcorefile: {[param;x] .util.wlin .bt.print["%btsrc%/core/core/%subsys%/%process%/%id%"] param,x}[param]@'t from t;
 t
 }


.action.createVar:{[allData]
 cfg :$[()~key file:`$.bt.print[":%folder%/%cfg%.json"]allData;.j.k "\n"sv system .bt.print["yq -o=json %folder%/%cfg%.yml"]allData; .j.k "c"$read1 file];
 / cfg : .j.k "c"$read1 `$ .bt.print[":%folder%/%cfg%.json"] allData;
 core: .j.k "c"$read1 `$ .bt.print[":%btsrc%/core/core.json"] allData;
 ik:key[cfg`global] inter key core;
 core:(`global,ik)#core;
 cfg:.util.deepMerge[core]cfg;
 global: cfg`global;
 cfg:``global _ cfg;
 `cfg`global`core!(cfg;global;core)
 }


d) function
 action
 .action.createVar
 return all global variables
 q) .action.createVar[.env] `folder`cfg`subsys`process`id`trace!(`pathTo/plant;`horseracing;`scrapeData;`dev;0j;0j)
 q) .action.createVar[.env] `folder`cfg`subsys`process`id`trace!(`$getenv[ `btsrc],"/plant";`ex1;`scrapeData;`dev;0j;0j)


.action.parseSchema:{[allData]
 core:`$.bt.print[":%btsrc%/core/core/schemas"] allData;
 plant:`$.bt.print[":%folder%/%env%/schemas"] allData;
 t:([]plant:`core`plant; path:(core;plant) );
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
 `core`plant`con!(core;plant;t)     
 }


d) function
 action
 .action.parseSchema
 return all global variables
 q) .action.parseSchema[.env] `folder`cfg`subsys`process`id`trace!(`pathTo/plant;`horseracing;`scrapeData;`dev;0j;0j)
 q) .action.parseSchema[.env] `folder`cfg`subsys`process`id`trace!(`$getenv[ `btsrc],"/plant";`ex1;`scrapeData;`dev;0j;0j) 