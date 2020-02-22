/ tick.sub is needed


.cep.con:flip `time`uid`fnc!()

.bt.add[`.tick.init.schemas;`.tick.cep.init]{[tick] .u.init[]; }

/ we remove the unwanted behaviours

.bt.remove@'`.tick.init.logFiles`.tick.replay.logFiles`.tick.sub`.tick.eod;

.bt.add[`.tick.success;`.cep.sub]{[result]
 hdls:exec distinct hdl from result;
 {
 	subsys0:first exec subsys from .tick.con where hdl = x;
 	con:select subsys,tname,rsubscriber:.proc.uid from .tick.schemas where subsys = subsys0;
 	x (`.bt.action;`.tick.sub;`uid`con!(.proc`uid;con)) 
 	}@'hdls;
 }

.bt.add[`.hopen.pc;`.tick.u.pc]{[zw] .u.del[;zw]each .u.t }

upd:{[tname;data]
 tname:.tick.t tname;
 data:.tick.addCols[tname;data]; / now distribute to the 
 {[tname;data;cep] @[0;(cep`fnc;tname;data);]
 	{[error;tname;data;cep]
 	 / send the error ...
 	}[;tname;data;cep]  
 }[tname;data;] each .cep.con;
 }