
.d.conFunc:2!flip`module`func`desc`example`body!()
.d.conMod:1!flip`module`desc`example!()

.d.e0:()!()
.d.e0[`function]:{[x]
 `.d.conFunc upsert enlist `module`func`desc`example`body!(`$x 0;`$x 1;x 2;"\n"sv 3_x ; @[get;`$x 1;{`notavail}] );
 }

.d.e0[`module]:{[x]
 `.d.conMod upsert enlist `module`desc`example!(`$x 0;x 1;"\n" sv 2_x);
 }

.d.e:{
 .d.e0[`$first a] 1_a:"\n" vs x 
 }

d) module
 import
 Library to import module into kdb+
 q) .import.module / Autmatically loaded on startup


.import.repositories:flip`name`path!();

`.import.repositories insert (`btsrc;getenv `btsrc);

.import.repository:{[x]
 if[max x~/:(`;::);:.import.repositories];
 `.import.repositories insert cols[.import.repositories]#x ;
 .import.repositories:distinct .import.repositories ;
 .import.repositories
  }

d) function
 import
 .import.repository
 Function to add new repository. This repository is used to search for libraries
 q) .import.repository[] / show all repositories
 q) .import.repository` / show all repositories
 q) .import.repository `name`path!(`yourname;"path_to_repository")

.import.summary0:{[t]
 b:enlist[" "]~/:1#/:src:read0 t`fullPath;
 b:{x[;0]!x}value group sums neg[b] + 1+ a:"d)"~/:2#/:src;
 {get "\n" sv x}@'src b where a;	
 }

.import.summary:{  
 repositories:.import.repository[];
 t:raze { .os.tree .bt.print[":%path%/qlib"] x}@'repositories;
 / t:.os.tree .bt.print[":%btsrc%/qlib"] .env;
 t:select from t where {x ~ key x}@'fullPath;
 .import.summary0@'t;
 if[max x~/:(`;::);:.d.conMod];
 r:0!$[-11h = type x;select from .d.conFunc where (func=x) or module = x;select from .d.conFunc where body ~' x];
 r
 }

d) function
 import
 .import.summary
 Function to show all available modules
 q) .import.summary[] / show all modules
 q) .import.summary` / show all modules
 q) .import.summary`os / show all function in module os
 q) .import.summary`import
 q) .import.summary`.import.module
 q) .import.summary .import.module
 q) .import.summary .import.summary

.import.ex:{ 
  r:.import.summary x;
  if[not 1=count r;:r ];
  first exec example from r
 }

d) function
 import
 .import.ex
 Function to show all available modules
 q) .import.ex[] / show all modules
 q) .import.ex` / show all modules
 q) .import.ex`os / show all function in module os
 q) .import.ex`import
 q) .import.ex`.import.module
 q) .import.ex .import.module
 q) .import.ex .import.summary


.import.module0:flip`uid`module`file`stime`etime`error!()

.import.module:{
 if[10h = abs type x;x:`$x];
 if[max x~/:(`;::);:select by module from .import.module0];
 x: (.bt.md[`uid] first .bt.guid0 1),$[99h = type x;x;.bt.md[`module] x];

 if[`file in key x;:{
 	stime:.z.P;
 	error:@[{system .bt.print["l %btsrc%/qlib/%file%"] .env,x;`};x;{`$x}];
 	etime:.z.P;
 	`.import.module0 insert r:cols[.import.module0]#x,`stime`etime`error!(stime;etime;error);
 	enlist r
 	}x
 ];

 if[mfile~key mfile:`$.bt.print[":%btsrc%/qlib/%module%/%module%.q"] .env,x;:.import.module x,.bt.md[`file] `$.bt.print["%module%/%module%.q"] x ];
 if[mfile~key mfile:`$.bt.print[":%btsrc%/qlib/%module%"] .env,x;:.import.module x,bt.md[`file] `$.bt.print["%module%"] x ];
 }


d) function
 import
 .import.module
 Function to load library.
 q) .import.module[] / this will show loaded libraries and files 
 q) .import.module` / this will show loaded libraries and files 
 q) .import.module `tree / this will load tree/tree.q
 q) .import.module `tree/tree.q / this will load tree/tree.q
 q) .import.module `tree/ / this will load tree/*.q
 q) .import.module `tree/util / this will load tree/util/util.q
 q) .import.module `tree/util/util.q / this will load tree/util/util.q
 q) .import.module `tree/util/ / this will load tree/util/*.q


.import.module `os

