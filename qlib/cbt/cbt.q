
d) module
 cbt
 cbt provides connections to your bt plant
 q).import.module`cbt


/ x:`btsrc`horseracing

.cbt.summary:{[x]
 if[(not 11h =  abs type x) or max x ~/:(`;::) ;:.import.repositories];
 repo:select from .import.repositories where name in x;
 repo:ungroup update file:{key `$.bt.print[":%path%/plant"] x}@'repo,root:{`$.bt.print[":%path%/plant"] x}@'repo,`$path from repo;
 (::)repo:update root:root .Q.dd'file from repo
 (::)repo:select from repo where file like "*.json"

first tmp:.action.parseCfg `folder`cfg!(`$"C:\\dev\\gambling\\horseracing\\src\\plant";`horseracing)

select folder,env,uid,host,port,user:.z.u,passwd from tmp

 }