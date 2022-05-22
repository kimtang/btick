
\l qlib.q

.import.module`action`behaviour;
.behaviour.module`action;

if[ () ~ key `.env.arg;
 .env.arg:
  .util.arg
   .util.optArg0[`process;`;`noProcess]
   .util.optArg0[`id;"J";0ni]
   .util.optArg0[`btsrc;`;`$getenv`BTSRC]  
   .util.optArg0[`folder;`;`$getenv[`BTSRC],"/plant"] 
   .util.optArg0[`cfg;`;`] 
   .util.optArg0[`subsys;`;`]
   .util.optArg0[`trace;"J";0]
   .z.x;];

.bt.action[`.action.init] .env.arg;