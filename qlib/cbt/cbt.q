
.import.require`action;

d) module
 cbt
 cbt provides connections to your bt plant
 q).import.module`cbt

.cbt.init:{[x]
 .import.require`util`action`rlang;
  "r" "library(igraph)";
  "r" "library(RColorBrewer)";
 if[not `hopen in key `;
   system .bt.print["l %btsrc%/behaviour/hopen/hopen.q"] .env;
   .bt.action[`.hopen.init] ()!();
 ];

 }


.cbt.summary:{[x]
 if[99h = type x; x:$[0>type x`repository;enlist x;flip x] ];
 if[not any 98 99h in type x ;:{select repository,env:`${first "."vs x}@'string env from x where env like "*.json"}ungroup select repository:name,env:key @'`$.bt.print[":%path%/plant"]@'repositories from repositories:0!.import.repositories];
 x:update file:`$.bt.print["%env%.json"]@'x from x;
 repo:select repository:name,root:`$path from (0!.import.repositories) where name in x`repository;
 / if[0=count repo;:()];
 repo:ungroup update file:{key `$.bt.print[":%root%/plant"] x}@'repo,path:{`$.bt.print[":%root%/plant"] x}@'repo,root from repo;
 repo:update path:path .Q.dd'file from repo;
 repo:select from repo where ([]repository;file) in `repository`file#x ;
 repo:update folder:`$.bt.print["%root%/plant"]@'repo,cfg:`${first "."vs x}@'string file from repo;
 tmp:raze .action.parseCfg[.env] @'repo;
 cfg0:(`user`passwd!("yourname";"yourpasswd") ),.import.config`cbt;
 select repository,uid:`$.bt.print["%repository%.%uid%"]@'tmp,`$host,port,user:`$count[i]#enlist cfg0`user ,passwd:count[i]#enlist cfg0`passwd from tmp:tmp lj 1!select folder,repository from repo
 }

d) function
 cbt
 .cbt.summary
 Function to give a summary of available connection
 q) .cbt.summary[]  / show all available repository
 q) .cbt.summary `repository`env!`btsrc`ex1
 q) .cbt.summary enlist `repository`env!`btsrc`ex1


.cbt.query:{[proc;query]
 if[not -11h = type proc;:.cbt.summary[] ];
 if[0=count select from .hopen.con where uid = proc;
   allProcs:.cbt.summary enlist `repository`env!2#` vs proc;
   if[ not proc in allProcs`uid;'`.cbt.proc_not_found ];
   .bt.action[`.hopen.add] @' `uid`host`port`user`passwd#select from allProcs where uid=proc;
 ];
 procData:first 0!select from .hopen.con where uid = proc;
 seq:3;
 while[(null procData`hdl) and seq-:1;
   .util.sleep 3; / sleep for 3 secs
   delete from `.bt.tme where null runAt ,fnc = `.bt.action,`.hopen.loop ~/:arg[;0];
   .bt.action[`.hopen.loop] ()!();
   procData:first 0!select from .hopen.con where uid = proc;
 ];

 if[null procData`hdl;'`.cbt.proc_not_connected];
 .cbt.st:.z.P;
 r:@[{`result`error!(x y;`)}[procData`hdl];query;{`result`error!(();`$x)}];
 .cbt.et:.z.P;
 if[not null r`error;'r`error];
 :r`result
 }


d) function
 cbt
 .cbt.query
 Function to give a query of available connection
 q) .cbt.query[`btsrc.ex1.admin.bus.0] "1+3"
 q) .cbt.proc:`btsrc.ex1.admin.bus.0
 f) 1+3

.cbt.proc:`
.cbt.q:.cbt.query[.cbt.proc]

d) function
 cbt
 .cbt.q
 Function to give a query of available connection
 q) .cbt.proc:`btsrc.ex1.admin.bus.0
 q) .cbt.q "1+3"
 f) 1+3


.f.e:{ .f.r:.cbt.query[.cbt.proc] x;.f.r }
.s.e:{ .s.r:.cbt.query[.cbt.proc] (system;{$[" "= x 0;1_x;x] } over x);.s.r }


.cbt.sbl:{[x]
 summary:.cbt.summary x;
 cfg:(.bt.md[`path] "../cfg"),.import.config`cbt;
 (`$.bt.print[":%path%/system.sbl"] cfg) 0:  .bt.print["/ %uid%:%host%:%port%:%user%:%passwd%:"]@'summary
 }

d) function
 cbt
 .cbt.sbl
 Function to write a config file for sbl. Path can be config in the qlib.json. "cbt":{"path": "../cfg","user":"yourname","passwd":"yourpasswd"}
 q) .cbt.sbl `repository`env!`btsrc`ex1
 
.cbt.igraph:{[x]
 if[max x~/:(::;`);x:.bt.behaviours];
 nodes:select name:distinct (trigger,sym)from x;
 nodes:update module:{last 2#` vs x}@'name from nodes;
 colors:`$.rlang.rget0 .bt.print[" brewer.pal(%0, \"Set3\") "] 1#count select by module from nodes;
 colors:([]module:distinct nodes`module;color:colors);
 nodes:update color:(exec module!color from colors) module from nodes; 
 .rlang.Rset0[`behaviours] x;
 .rlang.Rset0[`nodes] nodes;
 .rlang.Rset0[`colors] colors; 
 "r" "net <- graph_from_data_frame(d=behaviours, vertices=nodes ,directed=T) ";
 "r" "v1 <- subcomponent(net, which(V(net)$name=='.action.init'), 'all')";
 "r" "net1 <- subgraph(net, v1)";
 "p" "plot(net1, vertex.size=4, edge.arrow.size=.5, vertex.label.color='black', vertex.label.dist=1.5)";
 "p" "legend('topleft',bty = 'n',legend=colors$module,fill=colors$color, border=NA)";
 }

d) function
 cbt
 .cbt.igraph
 Function to plot the behaviour of the bt process
 q) .cbt.igraph[]  / plot own behaviour
 q) .cbt.igraph .bt.behaviours / plot the behaviours

.cbt.duplicate0:()!()
.cbt.duplicate0[1]:{[fnc;arg0] .cbt.q (fnc;arg0)}
.cbt.duplicate0[2]:{[fnc;arg0;arg1] .cbt.q (fnc;arg0;arg1)}
.cbt.duplicate0[3]:{[fnc;arg0;arg1;arg2] .cbt.q (fnc;arg0;arg1;arg2)}
.cbt.duplicate0[4]:{[fnc;arg0;arg1;arg2;arg3] .cbt.q (fnc;arg0;arg1;arg2;arg3)}
.cbt.duplicate0[5]:{[fnc;arg0;arg1;arg2;arg3;arg4] .cbt.q (fnc;arg0;arg1;arg2;arg3;arg4)}
.cbt.duplicate0[6]:{[fnc;arg0;arg1;arg2;arg3;arg4;arg5] .cbt.q (fnc;arg0;arg1;arg2;arg3;arg4;arg5)}
.cbt.duplicate0[7]:{[fnc;arg0;arg1;arg2;arg3;arg4;arg5;arg6] .cbt.q (fnc;arg0;arg1;arg2;arg3;arg4;arg5;arg6)}

.cbt.duplicate:{[x]
 if[(not type[x] in 10 -11h) or max x~/:(`;::);:.import.doc`.cbt.duplicate];
 if[10h=abs type x;x:`$x];
 result:.cbt.q x;
 if[not 100h = type result;x set result;:x ];
 l:count get[ result]1;
 x set .cbt.duplicate0[l][string x]
 }


d) function
 cbt
 .cbt.duplicate
 Function to duplicate the fnc
 q) .cbt.duplicate[]  / show this doc
 q) .cbt.duplicate `.bt.action

.cbt.deepDuplicate:{[x]
 if[(not type[x] in 10 -11h) or max x~/:(`;::);:.import.doc`.cbt.duplicate];
 if[10h=abs type x;x:`$x];
 result:.cbt.q x;
 if[not 100h = type result;x set result;:x ];
 l:(get[ result]3) except `;
 (x set result),.cbt.duplicate@'l
 }

d) function
 cbt
 .cbt.deepDuplicate
 Function to deepDuplicate the fnc
 q) .cbt.deepDuplicate[]  / show this doc
 q) .cbt.q "`thisFunc1 set {[a;b] a + thisFunc2 b }"
 q) .cbt.q "`thisFunc2 set {[b] exp b }"
 q) .cbt.deepDuplicate `thisFunc2

.cbt.init[]

/

