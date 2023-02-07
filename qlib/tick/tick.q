d) module
 tick
 tick provides a set of functions for the tick processes
 q).import.module`tick


.tick.addTime0:()!()
.tick.addTime0[0h]:{[data] enlist[.z.p],data }
.tick.addTime0[98h]:{[data] `time xcols update time:.z.p from data } / table
.tick.addTime0[99h]:{[data] (`time,key[data])# @[;`time;:;.z.p] (.bt.md[`]{}), data  } /dictionary
.tick.addTime:{[data] .tick.addTime0[ $[type[data] in 0 98 99h;type data;0h] ] data }

.tick.addDate0:()!()
.tick.addDate0[0h]:{[data] enlist[.z.d],data }
.tick.addDate0[98h]:{[data] `date xcols update date:.z.d from data } / table
.tick.addDate0[99h]:{[data] @[data;`date;:;.z.d]  } /dictionary
.tick.addDate:{[data] .tick.addDate0[ $[type[data] in 0 98 99h;type data;0h] ] data }

.tick.addCols0:()!()
.tick.addCols0[0h]:{[tname;data] flip .tick.oc[tname]!data }
.tick.addCols0[98h]:{[tname;data] data }
.tick.addCols0[99h]:{[tname;data] enlist data }
.tick.addCols:{[tname;data] .tick.addCols0[type data][tname;data] }