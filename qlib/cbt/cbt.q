
d) module
 cbt
 cbt provides connections to your bt plant
 q).import.module`cbt

.cbt.init:{[x]
 if[not `hopen in key `;
   system .bt.print["l %btsrc%/behaviour/hopen/hopen.q"] .env;
   .bt.action[`.hopen.init] ()!();
 ];

 }


.cbt.summary:{[x]
 if[not any 98 99h in type x ;:.import.repositories];
 x:update file:`$.bt.print["%env%.json"]@'x from x;
 repo:select repository:name,root:`$path from .import.repositories where name in x`repository;
 repo:ungroup update file:{key `$.bt.print[":%root%/plant"] x}@'repo,path:{`$.bt.print[":%root%/plant"] x}@'repo,root from repo;
 repo:update path:path .Q.dd'file from repo;
 repo:select from repo where ([]repository;file) in `repository`file#x ;
 repo:update folder:`$.bt.print["%root%/plant"]@'repo,cfg:`${first "."vs x}@'string file from repo;
 / tmp:.action.parseCfg `folder`cfg!(`$"C:\\dev\\gambling\\horseracing\\src\\plant";`horseracing);
 tmp:raze .action.parseCfg @'repo;
 select repository,uid:`$.bt.print["%repository%.%uid%"]@'tmp,host,port,user:.z.u,passwd from tmp:tmp lj 1!select folder,repository from repo
 }

d) function
 cbt
 .cbt.summary
 Function to give a summary of available connection
 q) .cbt.summary[]  / show all available repository
 q) .cbt.summary enlist `repository`env!`btsrc`ex1


.cbt.query:{[process;query]}


.cbt.init[]

/

