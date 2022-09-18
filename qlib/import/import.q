d) module
 import
 Library to import module into kdb+
 q) .import.module / Autmatically loaded on startup
 Import module will load a file called qlib.json as well in the current working directory.
 If you dont have it you can create it with .import.cjson and reload it with .import.ljson.

.import.config:(); / important to keep this variable as list so we will trigger .bt.action[`.import.ljson] ()!() at start up.

.import.repositories:1!flip`name`path!();

`.import.repositories upsert (`btsrc;getenv `btsrc);

.import.repository:{[x]
 if[max x~/:(`;::);:.import.repositories];
 `.import.repositories upsert cols[.import.repositories]#x ;
 .import.ljson[];
 .import.repositories
  }

d) function
 import
 .import.repository
 Function to add new repository. This repository is used to search for libraries
 q) .import.repository[] / show all repositories
 q) .import.repository` / show all repositories
 q) .import.repository `name`path!(`yourname;"path_to_repository")


.bt.add[`.import.ljson;`.import.addRepo]{
 if[not `repositories in key .import.config;:()];
 .import.repository update name:`$name from .import.config`repositories;
 }

.import.summary0:{[t]
 st0:"qlib"vs string t`fullPath; 
 st1:"behaviour"vs st0 0;
 .d.folder:$[1=count st1;`qlib;`behaviour];
 b:enlist[" "]~/:1#/:src:read0 t`fullPath;
 b:{x[;0]!x}value group sums neg[b] + 1+ a:"d)"~/:2#/:src;
 {get "\n" sv x}@'src b where a;	
 }

.import.summary:{  
 repositories:0!.import.repository[];
 t:raze {
  ignore:{
  ignorePath:`$.bt.print[":%path%/qlib/.dignore"] x;
  if[not {x~key x}ignorePath ;:()];
  {[x;v]`$ .bt.print[":%path%/qlib/%val%"]x,.bt.md[`val]v }[x]@'read0 ignorePath
  } x;  
  .os.treeIgnore[ignore] .bt.print[":%path%/qlib"] x
  }@'repositories;
 / t:.os.tree .bt.print[":%btsrc%/qlib"] .env;
 t:select from t where {x ~ key x}@'fullPath;
 .d.isSummary:1b;
 .import.summary0@'t;
 .d.isSummary:0b;
 if[max x~/:(`;::);:.d.conMod];
 k:first k where x ~/:get@'.Q.dd[`;]@'k:key `;
 if[not null k;x:k;];
 if[max k:x ~/: .Q.dd[`;]@'key `; x:first key [`] where k ];
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

.import.doc:{ 
  r:.import.summary x;
  if[not 1=count r;:r ];
  first exec example from r
 }

d) function
 import
 .import.doc
 Function to show all available modules
 q) .import.doc[] / show all modules
 q) .import.doc` / show all modules
 q) .import.doc`os / show all function in module os
 q) .import.doc`import
 q) .import.doc`.import.module
 q) .import.doc .import.module
 q) .import.doc .import.summary


.import.module0:flip`uid`module`file`stime`etime`error!()

.import.module1:{[x;y]
 st0:"qlib"vs string y`fullPath; 
 st1:"behaviour"vs st0 0;
 .d.folder:$[1=count st1;`qlib;`behaviour];  
  x:y,(.bt.md[`uid] first .bt.guid0 1),.bt.md[`module] x;
  stime:.z.P;
  error:@[{system x`cmd;`};x;{`$x}];
  etime:.z.P;
  `.import.module0 insert r:cols[.import.module0]#x,`stime`etime`error!(stime;etime;error);    
 }

.import.module:{
 if[11h = type x;:.import.module@'x ];
 if[max x~/:(`;::);:select by module from .import.module0];
 if[-11h = type x;x:string x];
 repositories:.import.repository[]; 
 t:raze {
  ignore:{
  ignorePath:`$.bt.print[":%path%/qlib/.dignore"] x;
  if[not {x~key x}ignorePath ;:()];
  {[x;v]`$ .bt.print[":%path%/qlib/%val%"]x,.bt.md[`val]v }[x]@'read0 ignorePath
  } x;  
  .os.treeIgnore[ignore] .bt.print[":%path%/qlib"] x
  }@'repositories;
 / t:.os.tree .bt.print[":%btsrc%/qlib"] .env;
 t:select from t where {x ~ key x}@'fullPath;
 fileToLoad:();
 if[".q" ~ -2#x;
   fileToLoad:select from t where max fullPath like/:{ .bt.print[":%path%/qlib/%module%"] x,y}[.bt.md[`module] x]@'repositories;
   ];

 if["/" ~ last x;
   fileToLoad:select from t where max fullPath like/:{ .bt.print[":%path%/qlib/%module%*.q"] x,y}[.bt.md[`module] x]@'repositories;
   ];

 if[not (".q" ~ -2#x) or ("/" ~ last x);
   fileToLoad:select from t where max fullPath like/:{ .bt.print[":%path%/qlib/%module%/%module%.q"] x,y}[.bt.md[`module] x]@'repositories;
   ];

 / if[fileToLoad~();:'`module_not_found];
 fileToLoad:update sPath:1_/:string fullPath from fileToLoad;
 fileToLoad:update cmd:.bt.print["l %sPath%"]@'fileToLoad,file:fullPath from fileToLoad;
 :raze .import.module1[`$x]@'fileToLoad
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


.import.loadBehaviour:{}

d) function
 import
 .import.loadBehaviour
 Function to load library.
 q) .import.loadBehaviour[] / this will show loaded libraries and files 
 q) .import.loadBehaviour` / this will show loaded libraries and files 
 q) .import.loadBehaviour `tree / this will load tree/tree.q
 q) .import.loadBehaviour `tree/tree.q / this will load tree/tree.q
 q) .import.loadBehaviour `tree/ / this will load tree/*.q
 q) .import.loadBehaviour `tree/util / this will load tree/util/util.q
 q) .import.loadBehaviour `tree/util/util.q / this will load tree/util/util.q
 q) .import.loadBehaviour `tree/util/ / this will load tree/util/*.q

.import.require:{
 if[11h = type x;:.import.require@'x ];
 if[max x~/:(`;::);:select by module from .import.module0];
 if[0<count select from .import.module0 where module =x;:select by module from .import.module0];
 :.import.module x
 }


d) function
 import
 .import.require
 Function to load a library if it is not loaded.
 q) .import.require[] / this will show loaded libraries and files 
 q) .import.require` / this will show loaded libraries and files 
 q) .import.require `tree / this will load tree/tree.q
 q) .import.require `tree/tree.q / this will load tree/tree.q
 q) .import.require `tree/ / this will load tree/*.q
 q) .import.require `tree/util / this will load tree/util/util.q
 q) .import.require `tree/util/util.q / this will load tree/util/util.q
 q) .import.require `tree/util/ / this will load tree/util/*.q



.import.ljson:{
 global:1_string .Q.dd[;`.btick] hsym `$getenv $[.util.isWin;`USERPROFILE;`HOME];
 tmp:0!.import.repositories,1!flip`name`path!(`local`global;(enlist".";global));
 tmp:update priority:0wj^(`global`local!0 1) name from tmp; 
 / tmp:0!.import.repositories,1!enlist[`name`path!`local,enlist"."]; 
 tmp:update file:`$.bt.print[":%path%/qlib.json"]@'tmp from tmp;
 tmp:select from tmp where {x~key x}@'file; 
 tmp:update cfg:{.j.k "c"$ read1 x}@'file from tmp;
 result:.util.deepMerge over (exec cfg from `priority xasc tmp),2#enlist()!();
 / if[ `globalJson in key result;
 /  globalJson:hsym `$result`globalJson;
 /  if[globalJson~key globalJson;
 /    gJson:.j.k "c"$ read1 globalJson;
 /    result:.util.deepMerge[gJson] result;
 /  ];];
 / if[result~();result:()!()];
 if[.import.config ~ result;:.import.config];
 .import.config:result;
 .bt.action[`.import.ljson] ()!();
 .import.config
 }


d) variable
 import
 .import.ljson
 Configuration loaded from qlib.json 
 q) .import.ljson[] / this trigger to reload the configuration file
 q) .import.config / It will also parse a lobal json file from "globalJson" keyword  


.import.cjson:{[name;path]
 if[ `qlib.json in key `:.;'`.import.json.exists];
 `:qlib.json 0: enlist .j.j (1#`repositories)!enlist enlist`name`path!(name;path)
 }


d) variable
 import
 .import.cjson
 This will create a qlib.json in the current working directory. 
 q) .import.cjson[] / this will create the json file


.import.module`util;


.import.ljson[]; / we will try to load the json file on startup.

