
.import.require`util`action`rlang;

d) module
 cbt
 cbt provides connections to your bt plant
 q).import.module`cbt

.cbt.init:{[x]
  "r" "library(igraph)";
  "r" "library(RColorBrewer)";
 }


.cbt.repo:{
 x:update file:`$.bt.print["%env%.json"]@'x from x;
 repo:select repository:name,root:`$path from (0!.import.repositories) where name in x`repository;
 repo:repo lj 1!select repository,env from x;
 / if[0=count repo;:()];
 repo:ungroup update file:{key `$.bt.print[":%root%/plant"] x}@'repo,path:{`$.bt.print[":%root%/plant"] x}@'repo,root from repo;
 repo:update path:path .Q.dd'file from repo;
 repo:select from repo where ([]repository;file) in `repository`file#x ;
 repo:update folder:`$.bt.print["%root%/plant"]@'repo,cfg:`${first "."vs x}@'string file from repo;
 repo  
 }

/ (::)x:(::)

.cbt.summary:{[x]
 if[max x~/:(::;`);x:`$.import.config[`cbt]`plant];
 if[99h = type x; x:$[0>type x`repository;enlist x;flip x] ];
 if[not any 98 99h in type x ;:{select repository,env:`${first "."vs x}@'string env from x where env like "*.json"}ungroup select repository:name,env:key @'`$.bt.print[":%path%/plant"]@'repositories from repositories:0!.import.repositories];
 repo:.cbt.repo x;
 tmp:raze {.action.parseCfg x,``btsrc!(();`$getenv[`BTSRC])} @'repo;
 cfg0:(`user`passwd!("yourname";"yourpasswd") ),.import.config`cbt;
 select repository,uid:`$.bt.print["%repository%.%uid%"]@'tmp,`$host,port,user:`$count[i]#enlist cfg0`user ,passwd:count[i]#enlist cfg0`passwd from tmp:tmp lj 1!select folder,repository from repo
 }

d) function
 cbt
 .cbt.summary
 Function to give a summary of available connection.You can also set a plant object in config file
 q) .cbt.summary[]  / show all available repository
 q) .cbt.summary `repository`env!`btsrc`ex1
 q) .cbt.summary enlist `repository`env!`btsrc`ex1


.cbt.schemas:{[x]
 if[max x~/:(::;`);x:`$.import.config[`cbt]`plant];
 if[99h = type x; x:$[0>type x`repository;enlist x;flip x] ];
 if[not any 98 99h in type x ;:{select repository,env:`${first "."vs x}@'string env from x where env like "*.json"}ungroup select repository:name,env:key @'`$.bt.print[":%path%/plant"]@'repositories from repositories:0!.import.repositories];
 repo:.cbt.repo x;
 `uid xcols raze{ data:.action.parseSchema arg:(``btsrc!(();`$getenv[`BTSRC])),x; update uid:.Q.dd . arg`repository`env from data`con }@'repo
 }

d) function
 cbt
 .cbt.schemas
 Function to give a summary of available connection.You can also set a plant object in config file
 q) .cbt.schemas[]  / show all available repository
 q) .cbt.schemas `repository`env!`btsrc`ex1
 q) .cbt.schemas enlist `repository`env!`btsrc`ex1

 
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
 / "r" "v1 <- subcomponent(net, which(V(net)$name=='.action.init'), 'all')";
 / "r" "net1 <- subgraph(net, v1)";
 "p" "plot(net, vertex.size=4, edge.arrow.size=.5, vertex.label.color='black', vertex.label.dist=1.5)";
 / "p" "legend('topleft',bty = 'n',legend=colors$module,fill=colors$color, border=NA)";
 }

d) function
 cbt
 .cbt.igraph
 Function to plot the behaviour of the bt process
 q) .cbt.igraph[]  / plot own behaviour
 q) .cbt.igraph .bt.behaviours / plot the behaviours

.cbt.init[]
