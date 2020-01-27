/ tick.sub is needed

.bt.add[`.tick.init.schemas;`.tick.ctp.init]{[tick] .u.init[]; }

upd:{[tname;data]
 tname:.tick.t tname;
 data:.tick.addCols[tname;data]; / now distribute to the 
 .u.pub[tname;data];
 }

/ we remove the unwanted behaviours

.bt.remove@'`.tick.init.logFiles`.tick.replay.logFiles`.tick.sub`.tick.eod;

.bt.add[`.tick.success;`.ctp.sub]{[result]
 hdls:exec distinct hdl from result;
 {
 	subsys0:first exec subsys from .tick.con where hdl = x;
 	con:select subsys,tname,rsubscriber:.proc.uid from .tick.schemas where subsys = subsys0;
 	x (`.bt.action;`.tick.sub;`uid`con!(.proc`uid;con)) 
 	}@'hdls;
 }

.bt.add[`.hopen.pc;`.tick.u.pc]{[zw] .u.del[;zw]each .u.t }

\d .u

init:{w::t!(count t::tables`.)#()}

del:{w[x]_:w[x;;0]?y};

/ .z.pc:{del[;x]each t};

sel:{$[`~y;x;select from x where sym in y]}

pub:{[t;x]{[t;x;w]if[count x:sel[x]w 1;(neg first w)(`upd;t;x)]}[t;x]each w t}

add:{$[(count w x)>i:w[x;;0]?.z.w;.[`.u.w;(x;i;1);union;y];w[x],:enlist(.z.w;y)];(x;$[99=type v:value x;sel[v]y;0#v])}

sub:{if[x~`;:sub[;y]each t];if[not x in t;'x];del[x].z.w;add[x;y]}

end:{(neg union/[w[;;0]])@\:(`.u.end;x)}


/