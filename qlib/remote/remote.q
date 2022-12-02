d) module
 remote
 remote provides connections to your bt plant
 q).import.module`remote

 

.remote.init:{[x]
 .import.require`util`rlang;
  if[not `hopen in key `;
   system .bt.print["l %btsrc%/behaviour/hopen/hopen.q"] (1#`btsrc)!enlist getenv`btsrc;
   .bt.action[`.hopen.init] ()!();
  ];
 }

.remote.con:flip`uid`host`port`user`passwd!"ssjs*"$\:()


.remote.summary:{[x]
 if[max x~/:(::;`);:.remote.con];
 select from .remote.con where uid = x
 }

 

d) function
 remote
 .remote.summary
 Function to give a summary of available connection
 q) .remote.summary[]  / show all available repository


.remote.add:{[x] `.remote.con insert x }

 
d) function
 remote
 .remote.add
 Function to add a connection
 q) .remote.add `uid`host`port`user`passwd!(`kx_platform_hdb;`sgsupp01.firstderivatives.com; 23003;`;1#"")

 

.remote.query:{[proc;query]
 if[not -11h = type proc;:.remote.summary[] ];
 if[0=count select from .hopen.con where uid = proc;
   allProcs:.remote.summary proc;
   if[ not proc in allProcs`uid;'`.remote.proc_not_found ];
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

 if[null procData`hdl;'`.remote.proc_not_connected];
 st:.z.P;
 r:@[{`result`error!(x y;`)}[procData`hdl];query;{`result`error!(();`$x)}];
 et:.z.P;
 :r,`st`et`proc!st,et,proc
 }

 
d) function
 remote
 .remote.query
 Function to give a query of available connection
 q) .remote.proc:`kx_platform_hdb
 q) .remote.query[`] "1+3"
 f) 1+3


.remote.proc:`
.remote.q:{
  r:.remote.query[;x]@'.remote.proc;
  if[0<type .remote.proc;:r ];
  if[not null r`error;'r`error];
  r`result
 }

 

d) function
 remote
 .remote.q
 Function to give a query of available connection
 q) .remote.proc:`kx_platform_hdb
 q) .remote.q "1+3"
 f) 1+3


.f.q:{ .f.r:.remote.q x;.f.r }
.f.e:{ .f.q x }
.s.e:{ .s.r:.f.q (system;{$[" "= x 0;1_x;x] } over x);.s.r }

 
.remote.sbl:{[x]
 summary:.remote.summary x;
 cfg:(.bt.md[`path] "../cfg"),.import.config`remote;
 (`$.bt.print[":%path%/system.sbl"] cfg) 0:  .bt.print["/ %uid%:%host%:%port%:%user%:%passwd%:"]@'summary
 }

 

d) function
 remote
 .remote.sbl
 Function to write a config file for sbl. Path can be config in the qlib.json. "remote":{"path": "../cfg","user":"yourname","passwd":"yourpasswd"}
 q) .remote.sbl `repository`env!`btsrc`ex1

 
.remote.duplicate0:()!()
.remote.duplicate0[1]:{[fnc;arg0] .remote.q (fnc;arg0)}
.remote.duplicate0[2]:{[fnc;arg0;arg1] .remote.q (fnc;arg0;arg1)}
.remote.duplicate0[3]:{[fnc;arg0;arg1;arg2] .remote.q (fnc;arg0;arg1;arg2)}
.remote.duplicate0[4]:{[fnc;arg0;arg1;arg2;arg3] .remote.q (fnc;arg0;arg1;arg2;arg3)}
.remote.duplicate0[5]:{[fnc;arg0;arg1;arg2;arg3;arg4] .remote.q (fnc;arg0;arg1;arg2;arg3;arg4)}
.remote.duplicate0[6]:{[fnc;arg0;arg1;arg2;arg3;arg4;arg5] .remote.q (fnc;arg0;arg1;arg2;arg3;arg4;arg5)}
.remote.duplicate0[7]:{[fnc;arg0;arg1;arg2;arg3;arg4;arg5;arg6] .remote.q (fnc;arg0;arg1;arg2;arg3;arg4;arg5;arg6)}

 

.remote.duplicate:{[x]
 if[(not type[x] in 10 -11h) or max x~/:(`;::);:.import.doc`.remote.duplicate];
 if[10h=abs type x;x:`$x];
 result:.remote.q x;
 if[not 100h = type result;x set result;:x ];
 l:count get[ result]1;
 x set .remote.duplicate0[l][string x]
 }

 

 

d) function
 remote
 .remote.duplicate
 Function to duplicate the fnc
 q) .remote.duplicate[]  / show this doc
 q) .remote.duplicate `.bt.action

 

.remote.deepDuplicate:{[x]
 if[(not type[x] in 10 -11h) or max x~/:(`;::);:.import.doc`.remote.duplicate];
 if[10h=abs type x;x:`$x];
 result:.remote.q x;
 if[not 100h = type result;x set result;:x ];
 l:(get[ result]3) except `;
 (x set result),.remote.duplicate@'l
 }

 

d) function
 remote
 .remote.deepDuplicate
 Function to deepDuplicate the fnc
 q) .remote.deepDuplicate[]  / show this doc
 q) .remote.q "`thisFunc1 set {[a;b] a + thisFunc2 b }"
 q) .remote.q "`thisFunc2 set {[b] exp b }"
 q) .remote.deepDuplicate `thisFunc2


.remote.init[]