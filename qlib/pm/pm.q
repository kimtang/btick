d) module
 pm
 process management library in btick 
 q).import.module`pm

.import.require`behaviour`util`action`behaviour;
.behaviour.module`pm;

.pm.parseArg:{[zx]
 if[(-10h=type zx) or max zx~/:(::;`);zx:"-folder plant"];
 if[10h=type zx;zx:" "vs zx];
 .util.arg
  .util.posArg0[`cmd;`;`noCmd]
  .util.posArg0[`proc;`;`noProc]
  .util.optArg0[`btsrc;`;`$getenv`BTSRC]  
  .util.optArg0[`folder;`;`$"plant"] 
  .util.optArg0[`cfg;`;`] 
  .util.optArg0[`subsys;`;`]
  .util.optArg0[`trace;"J";0]
  .util.optArg0[`debug;"B";0b]
  zx
 }


d) function
 pm
 .pm.parseArg
 Function to give a parse pm arguments to be used
 q) .pm.parseArg "-folder plant -cfg vas status all" / parse arguments for pm
 q) .pm.parseArg ("-folder";"plant";"-cfg";"vas";"status";"all") / this is also possible

.pm.main:{[x]
 {.bt.action[`.pm.init;x]`result } .pm.parseArg x
 }
 

d) function
 pm
 .pm.main
 Function to execute pm commands 
 q) .pm.main "-folder plant"
 q) .pm.main "-folder plant -cfg vas status all"


