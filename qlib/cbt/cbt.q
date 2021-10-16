
d) module
 cbt
 cbt provides connections to your bt plant
 q).import.module`cbt

.cbt.init:{[x]
 .import.require`util`action;
 if[not `hopen in key `;
   system .bt.print["l %btsrc%/behaviour/hopen/hopen.q"] .env;
   .bt.action[`.hopen.init] ()!();
 ];

 }


.cbt.summary:{[x]
 if[not any 98 99h in type x ;:{select repository,env:`${first "."vs x}@'string env from x where env like "*.json"}ungroup select repository:name,env:key @'`$.bt.print[":%path%/plant"]@'.import.repositories from .import.repositories]; 
 x:update file:`$.bt.print["%env%.json"]@'x from x;
 repo:select repository:name,root:`$path from .import.repositories where name in x`repository;
 / if[0=count repo;:()];
 repo:ungroup update file:{key `$.bt.print[":%root%/plant"] x}@'repo,path:{`$.bt.print[":%root%/plant"] x}@'repo,root from repo;
 repo:update path:path .Q.dd'file from repo;
 repo:select from repo where ([]repository;file) in `repository`file#x ;
 repo:update folder:`$.bt.print["%root%/plant"]@'repo,cfg:`${first "."vs x}@'string file from repo;
 / tmp:.action.parseCfg `folder`cfg!(`$"C:\\dev\\gambling\\horseracing\\src\\plant";`horseracing);
 tmp:raze .action.parseCfg @'repo;
 select repository,uid:`$.bt.print["%repository%.%uid%"]@'tmp,`$host,port,user:.z.u,passwd from tmp:tmp lj 1!select folder,repository from repo
 }

d) function
 cbt
 .cbt.summary
 Function to give a summary of available connection
 q) .cbt.summary[]  / show all available repository
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
.f.e:{ .f.r:.cbt.query[.cbt.proc] x;.f.r }
.s.e:{ .s.r:.cbt.query[.cbt.proc] (system;{$[" "= x 0;1_x;x] } over x);.s.r }

.cbt.init[]

/

