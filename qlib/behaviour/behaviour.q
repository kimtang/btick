d) module
 behaviour
 Library to import behaviours into kdb+
 q) .import.module`behaviour / Automatically loaded on startup
 It will parse the directory of behaviour.

.behaviour.summary:{  
 repositories:0!.import.repository[];
 t:raze {
  ignore:{
  ignorePath:`$.bt.print[":%path%/behaviour/.dignore"] x;
  if[not {x~key x}ignorePath ;:()];
  {[x;v]`$ .bt.print[":%path%/behaviour/%val%"]x,.bt.md[`val]v }[x]@'read0 ignorePath
  } x;  
  .os.treeIgnore[ignore] .bt.print[":%path%/behaviour"] x
  }@'repositories;
 / t:.os.tree .bt.print[":%btsrc%/qlib"] .env;
 t:select from t where {x ~ key x}@'fullPath,fullPath like "*.q";
 .d.isSummary:1b;
 .import.summary0@'t;
 .d.isSummary:0b;
 if[max x~/:(`;::);:select from .d.conMod where folder=`behaviour];
 r:0!$[-11h = type x;select from .d.conFunc where (func=x) or module = x;select from .d.conFunc where body ~' x];
 r
 } 

d) function
 behaviour
 .behaviour.summary
 Function to show available behaviours.
 q) .behaviour.summary[] / show all modules
 q) .behaviour.summary` / show all modules
 q) .behaviour.summary`hopen / show all function in module os
 q) .behaviour.summary`.hopen.add


.behaviour.module0:flip`uid`module`file`stime`etime`error!()

.behaviour.module1:{[x;y]
 st0:"qlib"vs string y`fullPath; 
 st1:"behaviour"vs st0 0;
 .d.folder:$[1=count st1;`qlib;`behaviour];      
  x:y,(.bt.md[`uid] first .bt.guid0 1),.bt.md[`module] x;
  stime:.z.P;
  error:@[{system x`cmd;`};x;{`$x}];
  etime:.z.P;
  `.behaviour.module0 insert r:cols[.behaviour.module0]#x,`stime`etime`error!(stime;etime;error);    
 }

.behaviour.module:{
 if[11h = type x;:.behaviour.module@'x ];
 if[max x~/:(`;::);:select by module from .behaviour.module0];
 if[-11h = type x;x:string x];
 repositories:.import.repository[];
 t:raze {
  ignore:{
  ignorePath:`$.bt.print[":%path%/behaviour/.dignore"] x;
  if[not {x~key x}ignorePath ;:()];
  {[x;v]`$ .bt.print[":%path%/behaviour/%val%"]x,.bt.md[`val]v }[x]@'read0 ignorePath
  } x;
  .os.treeIgnore[ignore] .bt.print[":%path%/behaviour"] x
  }@'repositories;
 / t:.os.tree .bt.print[":%btsrc%/qlib"] .env;
 t:select from t where {x ~ key x}@'fullPath;
 fileToLoad:();
 if[".q" ~ -2#x;
   fileToLoad:select from t where max fullPath like/:{ .bt.print[":%path%/behaviour/%module%"] x,y}[.bt.md[`module] x]@'repositories;
   ];

 if["/" ~ last x;
   fileToLoad:select from t where max fullPath like/:{ .bt.print[":%path%/behaviour/%module%*.q"] x,y}[.bt.md[`module] x]@'repositories;
   ];

 if[not (".q" ~ -2#x) or ("/" ~ last x);
   fileToLoad:select from t where max fullPath like/:{ .bt.print[":%path%/behaviour/%folder%/%module%.q"] x,y}[`module`folder!(x;first "."vs  x)]@'repositories;
   ];

 / if[fileToLoad~();:'`module_not_found];
 fileToLoad:update sPath:1_/:string fullPath from fileToLoad;
 fileToLoad:update cmd:.bt.print["l %sPath%"]@'fileToLoad,file:fullPath from fileToLoad;
 :raze .behaviour.module1[`$x]@'fileToLoad
 }

d) function
 behaviour
 .behaviour.module
 Function to load library.
 q) .behaviour.module[] / this will show loaded libraries and files 
 q) .behaviour.module` / this will show loaded libraries and files 
 q) .behaviour.module `hopen / this will load tree/tree.q
 q) .behaviour.module `hopen/hopen.q / this will load tree/tree.q
 q) .behaviour.module `hopen/ / this will load tree/*.q
 q) .behaviour.module `hopen/util / this will load tree/util/util.q
 q) .behaviour.module `hopen/util/util.q / this will load tree/util/util.q
 q) .behaviour.module `hopen/util/ / this will load tree/util/*.q

.behaviour.doc:{ 
  r:.behaviour.summary x;
  if[not 1=count r;:r ];
  first exec example from r
 }

d) function
 behaviour
 .behaviour.doc
 Function to show all available modules
 q) .behaviour.doc[] / show all modules
 q) .behaviour.doc` / show all modules
 q) .behaviour.doc`hopen / show all function in module os
 q) .behaviour.doc`.hopen.add


.behaviour.require:{ 
 if[x in .behaviour.module0`module;:()];
 :.behaviour.module x  
 }

d) function
 behaviour
 .behaviour.require
 Load only once
 q) .behaviour.require`hopen / load hopen only once




