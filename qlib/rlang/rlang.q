
.rlang.repository:`btsrc

d) module
 rlang
 Library for transforming table to tree and back
 q).import.module`rlang

.bt.add[`;`.rlang.init]{
 .rlang.arg:.bt.md[`qhome] getenv`QHOME;
 .rlang.json:.bt.print["%qhome%/bt.json"] .rlang.arg;
 .j.k "c"$ read1 hsym `$.rlang.json
 }

.rlang.summary:{ raze { ([]env:x;val:";"vs  getenv x) } @'`PATH`R_HOME}

d) function
 rlang
 .rlang.summary
 Function to give a sumnmary of the rlang module
 q) .rlang.summary[]
 q) .rlang.summary`

.rlang.setv:{[x]
 {x[`env] setenv x[`val] } @'0!select val:";"sv val by env from x;
 .rlang.summary`
 }

d) function
 rlang
 .rlang.setv
 Function to setup path to PATH and R_HOME
 q) variable:.rlang.summary[];variable:update val:enlist["C:\\Program Files\\R\\R-4.1.1\\bin\\i386"] from variable where val like"*R-4.1.1\\bin\\x64*"  ;.rlang.setv variable;


.rlang.init:{
 // config:.import.ljson[]; 
 .rlang.dll:`$.bt.print[":%BTSRC%/qlib/rlang/r/rserver/%zo%/rserver"] `zo`BTSRC! (.z.o;getenv `BTSRC);
 .rlang.rclose: .rlang.dll 2:(`rclose;1);
 .rlang.ropen:  .rlang.dll  2:(`ropen;1);
 .rlang.rcmd:   .rlang.dll   2:(`rcmd;1);
 .rlang.rget0:   .rlang.dll   2:(`rget;1);
 .rlang.rset0:  .rlang.dll   2:(`rset;2);
 .rlang.nsc:"kdb.";
 .rlang.i:0; / index to store the anonymous variable
 .rlang.s:.z.o;
 .rlang.calc:1b;
 if[not `.rlang.ts in  exec arg[;0] from .bt.tme where null runAt,-11h = type@'arg[;0];.bt.action[`.rlang.ts] ()!();]; 
 }

d) function
 rlang
 .rlang.init
 Function to init r
 q) .rlang.init[]
 r) plot(c(1,2,3,4))
 p) c(1,2,3,4)


.bt.add[``.rlang.ts;`.rlang.ts]{.rlang.Rts[]};
.bt.addDelay[`.rlang.ts]{`tipe`time!(`in;00:00:00.400)};

.rlang.Rset_      : ()!()
.rlang.Rset_[1b] : { t:@[value;x;()];t:$[100h=type t ;();t];if[0<count t; .rlang.rset0[string x;t] ]; :x} / for symbol
.rlang.Rset_[0b] : { .rlang.rset0[n:.rlang.nsc,string .rlang.i;x];.rlang.i+:1; :`$n } / for non-symbol



.rlang.Rset: {x:$[10h=abs type x;`$x;x];:{ .rlang.Rset_[-11h=type x] x}each x }

d) function
 rlang
 .rlang.Rset
 Function to set the variable
 q)tmp:([]a:1 2 3 4; b: 5 6 7 8); .rlang.Rset `tmp 
 r) View(tmp)

.rlang.Rset0: {[x;y] .rlang.rset0[x;y] }


d) function
 rlang
 .rlang.Rset0
 Function to set the variable
 q).rlang.Rset0 [`tmp ] ([]a:1 2 3 4; b: 5 6 7 8)
 r) View(tmp)

.rlang.con:{distinct `$ ssr[;"`";""] each res where {x like "`*"} res:{raze y vs/:x} over enlist[enlist x]," $(,~=<-)"}

.r.e:{ if[not .rlang.calc;:0N!"R turned off"]; .rlang.Rset t:.rlang.con x;.rlang.rcmd str:ssr[;"`";""] x;"r)",1_str; }
.p.e:{  .r.e "print(",x,")" }

.rlang.conv:()!()
.rlang.conv[`Date]:{`date$x[1]-10957}
.rlang.conv[`levels]:{ syms: `$x . 0 0; :syms x[1] - 1 }
.rlang.conv[`string]:{ `$x }
.rlang.frame_:()!()
.rlang.frame_[1b]:{r:raze {$[type[x] in (0 10h);`$x; x]} each x 0;
			r:$[10h=type r;`string;r];
			sym:first key[.rlang.conv] inter r;
			 .rlang.conv[sym] x}
.rlang.frame_[0b]:{x}

.rlang.Rts:{@[.rlang.rcmd;"try(system('dir', intern = FALSE, ignore.stdout = TRUE, ignore.stderr = TRUE))";()]};

.rlang.Rget:{x:(),x; .rlang.Rset t:.rlang.con x:$[10h=abs type x;x;string x];.rlang.rget0 ssr[;"`";""] x }

.rlang.Rframe:{ 
    t:.rlang.Rget x;
    arg:{y!x} . flip 2 cut t 0;
    nme:`$arg`names;
    rns:arg`row.names;
    mat:{ .rlang.frame_[0h=type x]  x } each t[1];
    rns:$[count[rns]=count first mat; @[(`$);rns;rns];til count first mat];
     /(nme;rns;mat)
     flip ((`$"row_names"),nme)!enlist[rns],mat 
 }

/ file:"rlang/ggplot2_formatter.r"
/ repo:`btsrc

.rlang.source:{[file;repo]
 repositories:exec name!path from .import.repository[];
 arg:`file`repo!(file;repositories repo);
 cmd:.bt.md[`path] ssr[;"\\";"/"] .bt.print["%repo%/qlib/%file%"] arg;
 "r" ssr[;"\\";"/"] .bt.print["source('%path%')"] cmd;    
 }

d) function
 rlang
 .rlang.source
 Function to source a file
 q) .rlang.source["rlang/ggplot2_formatter.r";`btsrc]

.rlang.init[]