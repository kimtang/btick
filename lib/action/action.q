
.action.calcPort:()!()
.action.calcPort[`setPort]:{[mergeArg;id] get .bt.print[$[10h=type mergeArg`setPort;::;string]mergeArg`setPort ] mergeArg   }
.action.calcPort[`dynamicPort]:{[mergeArg;id] id + get  .bt.print[$[10h=type mergeArg`dynamicPort;::;string]mergeArg`dynamicPort ] mergeArg }
.action.calcPort[`noPort]:{[mergeArg;id] 0nj}

.action.parseCfg:{[allData]
 .cfg : .j.k "c"$read1 `$ .bt.print[":%folder%/%env%.json"] .env,allData;
 .core: .j.k "c"$read1 `$ .bt.print[":%btsrc%/core/core.json"] .env,.cfg.global;
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
 t:update host:mergeArg[;`host],port:{[library;mergeArg;id] .action.calcPort[first `noPort ^ desc (k!k:key .action.calcPort) library] [mergeArg;id]}'[library;mergeArg;id] from t;
 t:update proc:.Q.dd'[process;id] from t;
 t:update uid:.Q.dd'[folder;flip(env;subsys;process;id)] from t; 
 t:update hdb: {.bt.print["%data%/%folder%/%env%/%subsys%/hdb"] .global,x}@'t from t; 
 t:update audit: {.bt.print["%audit%/%folder%/%env%/%subsys%/%process%/%id%"] .global,x}@'t from t;
 t:update gData: {.bt.print["%data%/%folder%/%env%/%subsys%/%process%"] .global,x}@'t from t;   
 t:update data: {.bt.print["%data%/%folder%/%env%/%subsys%/%process%/%id%"] .global,x}@'t from t;
 t:update gfile: {.bt.print["%folder%/%env%/%subsys%/%process%/global"] .global,x}@'t from t;
 t:update lfile: {.bt.print["%folder%/%env%/%subsys%/%process%/%id%"] .global,x}@'t from t;
 t:update gcorefile: { .util.wlin .bt.print["%btsrc%/core/core/%subsys%/%process%/global"] .env,.global,x}@'t from t;
 t:update lcorefile: { .util.wlin .bt.print["%btsrc%/core/core/%subsys%/%process%/%id%"] .env,.global,x}@'t from t;
 .bt.md[`result]t
 }